# Encryptatron

Used to load encrypted data from disk into configatron.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'encryptatron'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install encryptatron

## Usage

1. Run: `encryptatron encrypt file_to_encrypt.yml`
2. Add: `ENCRYPTATRON_KEY=whatever` to your .env file and any CI environments that need it
3. Initialize configatron: `Encryptatron.use('file_to_encrypt.yml')` or `configatron = Encryptatron.load('file_to_encrypt.yml')`
4. Check in: `file_to_encrypt.yml.enc` and `file_to_encrypt.yml.iv`, you can check in `file_to_encrypt.yml` if you remove the secrets

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/govdelivery/encryptatron.
