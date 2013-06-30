$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "fedora_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "fedora_rails"
  s.version     = FedoraRails::VERSION
  s.authors     = ["Andrew Curley (UVA)"]
  s.email       = ["andrew.curley@gmail.com"]
  s.homepage    = "https://github.com/uvalib-dcs/fedora_rails"
  s.summary     = "An engine that uses a Fedora repopsitory as a supplemental datastore for ActiveRecord objects."
  s.description = "FedoraRails enables select or all ActiveRecord objects to be serialized as XML and stored in a Fedora repository utilizing libraries from the Hydra framework."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.0"
  s.add_dependency 'rubydora', "~> 1.6"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
