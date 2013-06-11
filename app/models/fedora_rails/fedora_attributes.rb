module FedoraRails
  class FedoraAttributes < ActiveRecord::Base
    require 'rubydora'

    attr_accessible :pid

    belongs_to :fedorable, polymorphic: true
  end
end
