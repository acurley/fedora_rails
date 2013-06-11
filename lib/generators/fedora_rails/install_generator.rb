module FedoraRails
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc "Creates an initializer for including FedoraRails in ActiveRecord objects."

      def copy_initializer
        template "fedora_rails_includes.rb", "config/initializers/fedora_rails_includes.rb"
      end
    end
  end
end