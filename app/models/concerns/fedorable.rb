module Concerns::Fedorable
  extend ActiveSupport::Concern

  require 'rubydora'

  included do
    attr_accessor :type_of_delete

    has_one :fedora_attribute, as: :fedorable, class_name: 'FedoraRails::FedoraAttributes'

    delegate :pid,
      to: :fedora_attribute, allow_nil: true

    after_save :synchronize_to_fedora
    after_destroy :delete_from_fedora, :delete_fedora_attribute
    
    @@repo = Rubydora.connect :url => ENV['FEDORA_URL'], :user => ENV['FEDORA_USER'], :password => ENV['FEDORA_PASS']

    def object_exists?
      begin
        @@repo.find(self.pid)
        true
      rescue
        false
      end
    end

    private

    def delete_fedora_attribute
      FedoraRails::FedoraAttributes.where(fedorable: self).destroy
    end

    # Fedora provides two types of delete: soft and hard. Soft deletes change the state value to D.  
    # Hard deletes remove the object from the system. Since Fedora is intended for preservation systems, the default 
    # will be soft delete (set object state = 'D') but will allow for option to pass hard delete.
    def delete_from_fedora
      obj = @@repo.find(self.pid)
      self.type_of_delete ||= 'soft'
      if self.type_of_delete == 'soft'
        obj.state =  'D'
        obj.save
      else
        obj.delete
      end
    end

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
