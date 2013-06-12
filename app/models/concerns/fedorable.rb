module Concerns::Fedorable
  extend ActiveSupport::Concern

  require 'rubydora'

  included do
    has_one :fedora_attribute, as: :fedorable, class_name: 'FedoraRails::FedoraAttributes'

    delegate :pid, :object_exists?,
      to: :fedora_attribute, allow_nil: true

    after_save :ensure_fedora_attribute_object, :create_or_update_fedora_object
    
    @@repo = Rubydora.connect :url => 'http://localhost:8983/fedora', :user => 'fedoraAdmin', :password => 'fedoraAdmin'

    def object_exists?
      begin
        @@repo.find(self.pid)
        true
      rescue
        false
      end
    end

    private

    def ensure_fedora_attribute_object
      if fedora_attribute.nil?
        self.fedora_attribute = FedoraRails::FedoraAttributes.create(fedorable_id: self.id, fedorable_type: self.class.name)
      end
    end

    def create_or_update_fedora_object
      obj = @@repo.find_or_initialize(self.pid)
      obj.save if obj.new?
      create_or_update_metadata_datastream(obj)
    end

    def create_or_update_metadata_datastream(obj)
      ds = obj.datastreams['preservationMetadata']
      if ds.new?
        ds.dsLabel = 'FedoraRails XML Serialization'
        ds.mimeType = 'text/xml'
        ds.controlGroup = 'M'
        ds.dsState = "A"
        ds.versionable = true
      end
      ds.content = self.to_xml
      ds.save
    end
  end
end
