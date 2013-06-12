module FedoraRails
  class FedoraAttributes < ActiveRecord::Base
    require 'rubydora'

    attr_accessible :pid, :fedorable_id, :fedorable_type

    belongs_to :fedorable, polymorphic: true
    before_save :assign_pid

    @@repo = Rubydora.connect :url => 'http://localhost:8983/fedora', :user => 'fedoraAdmin', :password => 'fedoraAdmin'

    def assign_pid
      self.pid = @@repo.mint if self.pid.nil?
    end
  end
end
