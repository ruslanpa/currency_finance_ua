# CurrencyFinanceUA

It's a simple wrapper under <http://content.finance.ua/ru/xml/currency-cash>

All data provided by <http://content.finance.ua/ru/xml/currency-cash>

## Installation

Add this line to your application's Gemfile:

    gem 'currency_finance_ua'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install currency_finance_ua

## Usage

    $ require 'currency_finance_ua'

    Get rate of exchange by current date
    rate: 'min' or 'max'
    bid_ask: 'bid' or 'ask' spread
    return organizations which are satisfied for all options
    
    $ include CurrencyFinanceUA
    $ get_rate_of_exchange('EUR', { rate: 'min', bid_ask: 'ask' })

## Contributing

1. Fork it ( http://github.com/ruslanpa/currency_finance_ua/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
