module Concerns::Fedorable
  extend ActiveSupport::Concern

  require 'rubydora'

  included do
    has_one :fedora_attribute, as: :fedorable, class_name: 'FedoraRails::FedoraAttributes'

    delegate :pid, :object_exists?,
      to: :fedora_attribute, allow_nil: true

    after_save :synchronize_to_fedora
    
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

    def synchronize_to_fedora
      # Check to see that a FedoraAttribute object exists
      if fedora_attribute.nil?
        self.fedora_attribute = FedoraRails::FedoraAttributes.create(fedorable_id: self.id, fedorable_type: self.class.name)
      end

      # Create object if it doesn't exist, otherwise read into memory
      obj = @@repo.find_or_initialize(self.pid)
      obj.save if obj.new?
      
      # Create datasream for serialized XML if it doesn't exist, otherwise just update XML contnet
      # Rubydora params for creating a datastream:
      # {:controlGroup => :dsControlGroup, :dsLocation => :dsLocation, :altIDs => nil, :dsLabel => :dsLabel, :versionable => :dsVersionable, :dsState => :dsState, :formatURI => :dsFormatURI, :checksumType => :dsChecksumType, :checksum => :dsChecksum, :mimeType => :dsMIME, :logMessage => nil, :ignoreContent => nil, :lastModifiedDate => nil, :content => nil, :asOfDateTime => nil}

      Rubydora::Datastream.new(obj, 'preservationMetadata', {dsLabel: 'FedoraRails XML Serialization', mimeType: 'text/xml',controlGroup: 'M', dsState: 'A', versionable: true, content: self.to_xml}).save
    end
  end
end
