# Adaptor

[![Build Status](https://travis-ci.org/aldesantis/adaptor-rb.svg?branch=master)](https://travis-ci.org/aldesantis/adaptor-rb)
[![Dependency Status](https://gemnasium.com/badges/github.com/aldesantis/adaptor-rb.svg)](https://gemnasium.com/github.com/aldesantis/adaptor-rb)
[![Coverage Status](https://coveralls.io/repos/github/aldesantis/adaptor-rb/badge.svg?branch=master)](https://coveralls.io/github/aldesantis/adaptor-rb?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/e51e8d7489eb72ab97ba/maintainability)](https://codeclimate.com/github/aldesantis/adaptor-rb/maintainability)

Adaptor makes it easy to implement the [Adapter pattern](https://en.wikipedia.org/wiki/Adapter_pattern) in Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'adaptor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install adaptor

## Usage

You can use the library in single-adaptor mode:

```ruby
module Pagination
  include Adaptor::Loader
  register WillPaginate, Kaminari
end

module Pagination
  class Kaminari
    include Adaptor
        
    def self.supports?(object)
      # return whether this adaptor supports the object
    end
  end
  
  class WillPaginate 
    include Adaptor
    
    def self.supports?(object)
      # return whether this adaptor supports the object
    end
  end
end

adaptor = Pagination.load_adaptor(object)
adaptor.some_method
```

Or, if it suits your use-case, you can use it in multiple-adaptor mode:

```ruby
module NotificationProcessor
  class Email
    include Adaptor
        
    def self.supports?(notification)
      notification.user.email.present?
    end
    
    def initialize(notification)
      @notification = notification
    end
    
    def deliver
      # ...
    end
  end
  
  class Sms 
    include Adaptor
    
    def self.supports?(notification)
      notification.user.phone.present?
    end
    
    def initialize(notification)
      @notification = notification
    end
    
    def deliver
      # ...
    end
  end
end

module MultipleAdaptorLoader
  include Adaptor::Loader
  register Email, Sms
end

NotificationProcessor.load_adaptors(notifications).each(&:deliver)
```

Note that `#load_adaptor` will return `nil` when it cannot find any adaptors, while `#load_adaptors`
will return an empty array. If you prefer, you can also use `#load_adaptor!` and `#load_adaptors!` 
respectively to raise an `Adaptor::NoAdaptorError` when no adaptor can be found.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aldesantis/adaptor-rb. This 
project is intended to be a safe, welcoming space for collaboration, and contributors are expected 
to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Adaptor project’s codebases, issue trackers, chat rooms and mailing 
lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/adaptor/blob/master/CODE_OF_CONDUCT.md).
