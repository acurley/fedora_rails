module FedoraRails
  class FedoraAttributes < ActiveRecord::Base
    attr_accessible :pid

    belongs_to :fedorable, polymorphic: true
  end
end
