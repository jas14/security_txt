# SecurityTxt

![Tests & Lints](https://github.com/jas14/security_txt/actions/workflows/main.yml/badge.svg)


This gem aims to provide a flexible Ruby interface to configure and generate an unsigned security.txt file, per [RFC 9116](https://www.rfc-editor.org/rfc/rfc9116.html). It includes some basic validations for certain field values.

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

Usage revolves around the `SecurityTxt::Fields` object, which represents the collection of fields and values making up a security.txt file.

First, set up this object:
```ruby
require 'security_txt'

my_fields = SecurityTxt::Fields.new
```

Then, you can get or set individual field values in several different ways:

#### Get individual fields
```ruby
my_fields.acknowledgments # => ["https://www.example.com/thanks"]
```

#### Set individual fields
```ruby
# You can use the setter via two aliases:
my_fields.acknowledgments = ["https://www.example.com/thanks"]
my_fields.acknowledgments ["https://www.example.com/thanks"]
```

#### Set fields with a block
```ruby
my_fields.configure do |fields|
  fields.acknowledgments = ["https://www.example.com/thanks"]
end
```

#### Set fields DSL-style
```ruby
my_fields.configure do
  acknowledgments ["https://www.example.com/thanks"]
end
```

#### Set fields on construction
```ruby
my_fields = SecurityTxt::Fields.new(
  acknowledgments: ["https://www.example.com/thanks"],
  canonical: ["https://www.example.com/.well-known/security.txt"],
  expires: "2023-01-01T00:00:00Z"
)
```

### Flexible values

Fields admitting multiple values can be set to an array or a singleton. The output will automatically be prope
Any optional fields that admit multiple values (acknowledgments, canonical, etc) can be set either as an array or as a single value which will be converted to an array:

```ruby
my_fields.preferred_languages 'en'
my_fields.preferred_languages ['en']
my_fields.preferred_languages ['en', 'es-AR']
```

### Accessing raw field values

Call the relevant setter with no arguments to get the field value:

```ruby
my_fields.preferred_languages # => ['en', 'es-AR']
```

`#to_h` is also defined on `SecurityTxt::Fields` if you want to access all the set values as a hash.

### Converting to string

When you've configured your security.txt object to your liking, simply call `#to_s` on the `SecurityTxt::Fields` object to convert to a properly formatted string. Optional fields you haven't specified will not be included in the output. Fields will be converted to the expected format (see `Preferred-Languages` example below).

```ruby
my_fields.to_s # =>
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
