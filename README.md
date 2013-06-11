# FedoraRails

## Installation
Into an existing rails app, add FedoraRails to the Gemfile

```
gem 'fedora_rails'
```

## Adding FedoraRails to Rails app
For each ActiveRecord object that you wish to store in a Fedora repository, add the following just below the class definiton:

```
include FedoraRails::Concerns::Fedorable
```

This will mixin the ActiveSupport::Concern functionality to the object and provide all necessary methods and relationship to facilitate delivery to Fedora.