module FedoraRails
  class FedoraAttributes
    require 'rubydora'
    include Mongoid::Document
    include Mongoid::Timestamps

    field :pid, type: String

    belongs_to :fedorable, polymorphic: true
    before_save :assign_pid

    @@repo = Rubydora.connect :url => 'http://localhost:8983/fedora', :user => 'fedoraAdmin', :password => 'fedoraAdmin'

    def assign_pid
      self.pid = @@repo.mint if self.pid.nil?
    end
  end
end
