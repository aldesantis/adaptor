# Adaptor

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

```ruby
module Pagination
  extend Adaptor::Loader
end

module Pagination
  class WillPaginate 
    extend Adaptor
    
    def supports?(object)
      # return whether this adaptor supports the object
    end
  end
end

adaptor = Pagination.load_adaptor(object)
adaptor.some_method
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aldesantis/adaptor. This 
project is intended to be a safe, welcoming space for collaboration, and contributors are expected 
to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Adaptor project’s codebases, issue trackers, chat rooms and mailing 
lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/adaptor/blob/master/CODE_OF_CONDUCT.md).
