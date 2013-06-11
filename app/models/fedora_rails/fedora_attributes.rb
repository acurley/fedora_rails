module FedoraRails
  class FedoraAttributes < ActiveRecord::Base
    require 'rubydora'

    attr_accessible :pid, :fedorable_id, :fedorable_type

    belongs_to :fedorable, polymorphic: true

    before_save :assign_pid
    after_save :create_or_update_fedora_object
    
    @@repo = Rubydora.connect :url => 'http://localhost:8983/fedora', :user => 'fedoraAdmin', :password => 'fedoraAdmin'

    def assign_pid
      self.pid = @@repo.mint if self.pid.nil?
    end

    def create_or_update_fedora_object
      obj = @@repo.find_or_initialize(self.pid)
      obj.save if obj.new?
    end

    def create_or_update_metadata_datastream

    end

    def object_exists?
      begin
        @@repo.find(self.pid)
        true
      rescue
        false
      end
    end
  end
end
