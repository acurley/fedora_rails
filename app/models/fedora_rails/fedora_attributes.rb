module FedoraRails
  class FedoraAttributes
    require 'rubydora'
    include Mongoid::Document
    include Mongoid::Timestamps

    field :pid, type: String

    belongs_to :fedorable, polymorphic: true
    before_save :assign_pid

    @@repo = Rubydora.connect :url => ENV['FEDORA_URL'], :user => ENV['FEDORA_USER'], :password => ENV['FEDORA_PASS']

    def assign_pid
      self.pid = @@repo.mint(namespace: ENV['FEDORA_NAMESPACE']) if self.pid.nil?
    end
  end
end
