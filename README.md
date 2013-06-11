[![Build Status](https://travis-ci.org/uvalib-dcs/tracksys.png)](https://travis-ci.org/uvalib-dcs/fedora_rails)
[![Dependency Status](https://gemnasium.com/uvalib-dcs/tracksys.png)](https://gemnasium.com/uvalib-dcs/fedora_rails)
[![Coverage Status](https://coveralls.io/repos/uvalib-dcs/tracksys/badge.png?branch=master)](https://coveralls.io/r/uvalib-dcs/fedora_rails)
[![Code Climate](https://codeclimate.com/github/uvalib-dcs/tracksys.png)](https://codeclimate.com/github/uvalib-dcs/fedora_rails)

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