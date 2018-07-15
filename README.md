# Adaptor

[![Build Status](https://travis-ci.org/aldesantis/adaptor.svg?branch=master)](https://travis-ci.org/aldesantis/adaptor)
[![Coverage Status](https://coveralls.io/repos/github/aldesantis/adaptor/badge.svg?branch=master)](https://coveralls.io/github/aldesantis/adaptor?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/e51e8d7489eb72ab97ba/maintainability)](https://codeclimate.com/github/aldesantis/adaptor/maintainability)

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

### Single adaptor mode

You can use the library in single-adaptor mode:

```ruby
module DocumentProcessor
  class Pdf
    include Adaptor

    def self.supports?(document)
      document.mime_type == 'application/pdf'
    end

    def initialize(document)
      @document = document
    end

    def build_thumbnail
      # something with @document
    end
  end

  class Word
    include Adaptor

    def self.supports?(document)
      document.mime_type == 'application/msword'
    end

    def initialize(document)
      @document = document
    end

    def build_thumbnail
      # something with @document
    end
  end
end

module DocumentProcessor
  include Adaptor::Loader
  register Pdf, Word
end

# You can use #load_adaptor! if you want to raise an
# Adaptor::NoAdaptorError when no adaptor is found.
thumbnail = DocumentProcessor.load_adaptor(document).build_thumbnail
```

### Multiple adaptor mode

If it suits your use case, you can use multiple-adaptor mode:

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

# You can use #load_adaptors! if you want to raise an
# Adaptor::NoAdaptorError when no adaptors are found.
NotificationProcessor.load_adaptors(notification).each(&:deliver)
```

### Multiple arguments

Note that there is no limit to the number of arguments you can pass to the adaptors' `.supports?`
and `.new` methods. Here's an example that checks support only with one argument, but initializes
with multiple:

```ruby
module DocumentProcessor
  class Pdf
    include Adaptor

    def self.supports?(document)
      document.mime_type == 'application/pdf'
    end

    def initialize(document, options)
      @document = document
      @options = options
    end

    def build_thumbnail
      # something with @document and @options
    end
  end

  class Word
    include Adaptor

    def self.supports?(document)
      document.mime_type == 'application/msword'
    end

    def initialize(document, options)
      @document = document
      @options = options
    end

    def build_thumbnail
      # something with @document and @options
    end
  end
end

module DocumentProcessor
  include Adaptor::Loader
  register Pdf, Word
end

# You can use #load_adaptor! if you want to raise an
# Adaptor::NoAdaptorError when no adaptor is found.
thumbnail = DocumentProcessor.load_adaptor(document, stamp: true).build_thumbnail
```

As you can see, whatever you pass to `.load_adaptor` or `.load_adaptors` will be forwarded to
`.supports?` and `.new`, according to the methods' respective arity.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aldesantis/adaptor. This
project is intended to be a safe, welcoming space for collaboration, and contributors are expected
to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Adaptor project’s codebases, issue trackers, chat rooms and mailing
lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/adaptor/blob/master/CODE_OF_CONDUCT.md).
