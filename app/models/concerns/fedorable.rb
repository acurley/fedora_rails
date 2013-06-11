module Concerns::Fedorable
  extend ActiveSupport::Concern

  included do
    has_one :fedora_attribute, as: :fedorable, class_name: 'FedoraRails::FedoraAttributes'

    delegate :pid, to: :fedora_attribute, allow_nil: true
  end

end
