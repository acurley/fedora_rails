module Concerns::Fedorable
  extend ActiveSupport::Concern

  require 'rubydora'

  included do
    has_one :fedora_attribute, as: :fedorable, class_name: 'FedoraRails::FedoraAttributes'

    delegate :pid, to: :fedora_attribute, allow_nil: true
    delegate :object_exists?, to: :fedora_attribute

    after_save :check_fedora_attribute_object

    private

    def check_fedora_attribute_object
      FedoraRails::FedoraAttributes.create(fedorable_id: self.id, fedorable_type: self.class.name) unless fedora_attribute
    end
  end
end
