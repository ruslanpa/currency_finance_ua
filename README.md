currency_finance_ua
===================

It is a simple wrapper by http://content.finance.ua/ru/xml/currency-cash/

You can to get currency rate of exchange specified by max or min value and bid-ask spread.

usage
===================
    $ gem install currency_finance_ua
    $ require 'currency_finance_ua'

    # Get rate of exchange by current date
    # rate: 'min' or 'max'
    # bid_ask: 'bid' or 'ask' spread
    # return organization which are satisfied for all options
    $ CurrencyFinanceUA.rate_of_exchange('USD', { rate: 'min', bid_ask: 'ask' })