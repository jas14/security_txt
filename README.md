# SecurityTxt

This gem aims to provide a flexible Ruby interface to configure and generate an unsigned security.txt file. It includes some basic validations for certain field values.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'security_txt'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install security_txt

## Usage

Usage revolves around the `SecurityTxt::Config` object, which provides a thin layer around the `Security::Fields` data object.

First, set up a security.txt config object:
```ruby
require 'security_txt'

my_config = SecurityTxt::Config.new
```

Then, you can get or set individual field values in several different ways:

#### Get fields
```ruby
my_config.fields # => #<SecurityTxt::Config...>
```

#### Set individual fields
```ruby
# You can use the setter via two aliases:
my_config.fields.acknowledgments = ["https://www.example.com/thanks"]
my_config.fields.acknowledgments ["https://www.example.com/thanks"]
```

#### Set fields with a block
```ruby
my_config.fields do |fields|
  fields.acknowledgments = ["https://www.example.com/thanks"]
end
```

#### Set fields DSL-style
```ruby
my_config.fields do
  acknowledgments ["https://www.example.com/thanks"]
end
```

### Flexible values

Fields admitting multiple values can be set to an array or a singleton. The output will automatically be prope
Any optional fields that admit multiple values (acknowledgments, canonical, etc) can be set either as an array or as a single value which will be converted to an array:

```ruby
my_config.fields.preferred_languages 'en'
my_config.fields.preferred_languages ['en']
my_config.fields.preferred_languages ['en', 'es-AR']
```

### Accessing raw field values

`#to_h` is defined on `SecurityTxt::Fields` if you want to access the values as a hash.

### Converting to string

When you've configured your security.txt object to your liking, simply call `#to_s` on the `SecurityTxt::Fields` object to convert to a properly formatted string. Optional fields you haven't specified will not be included in the output. Fields will be converted to the expected format (see `Preferred-Languages` example below).

```ruby
my_config.to_s # =>
# Acknowledgments: https://www.example.com/thanks1
# Acknowledgments: https://www.example.com/thanks2
#
# Canonical: https://www.example.com/.well-known/security.txt
#
# Preferred-Languages: en, es-AR
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jas14/security_txt. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/jas14/security_txt/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SecurityTxt project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jas14/security_txt/blob/main/CODE_OF_CONDUCT.md).
