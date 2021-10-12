# Nomics

Ruby gem for querying the Nomics API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nomics'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install nomics

Or see [Development](#development) if you just want to experiment.

## Usage

Create client with:

```ruby
client = Nomics::Client.new(
  host: "https://api.nomics.com",
  params: {
    key: API_KEY
  }
)
```

### Currencies

#### Ticker

Retrieve a list of cryptocurrencies given a set of tickers:

```ruby
client.currencies.ticker(ids: ["BTC", "XRP", "ETH"])
```

Retrieve a (list) specific crypto currency and specific values based on the ticker and any other dynamic params:

```ruby
client.currencies.ticker(ids: ["BTC", "ETH"], attributes: [:circulating_supply, :max_supply, :name, :symbol, :price])
```

#### Metadata

Retrieve a list of cryptocurrencies and their metadata:

```ruby
client.currencies.metadata(ids: ["BTC", "ETH"])
```

Also, with attributes:

```ruby
client.currencies.metadata(ids: ["BTC", "ETH"], attributes: [:name, :markets_count])
```

### Sparkline

Retrieve a specific cryptocurrency to specific fiat. Ie: BTC in ZAR or ETH in USD:

```ruby
client.currencies.sparkline(ids: ["BTC"], convert: "ZAR")
```

Calculate the price of one cryptocurrency from another, in relation to their dollar value:

```ruby
client.currencies.sparkline(ids: ["ETH"], convert: "BTC")
```

Get latest price:

```ruby
client.currencies.sparkline(ids: ["BTC"], convert: "USD").first[:prices].last
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nomasprime/nomics.
