currency_finance_ua
===================

It is a simple wrapper by @see http://content.finance.ua/ru/xml/currency-cash/

You can to get currency rate of exchange specified by max or min value and ask-bid spread.

usage
===================
    $ gem install currency_finance_ua
    $ require 'currency_finance_ua'

    # Create instance of CurrencyFinanceUA
    $ curr_today = CurrencyFinanceUA.new

    # Load data from server
    $ curr_today.load

    # Get rate of exchange by current date
    # value - gets 'min' or 'max'
    # also spread - ask-bid spread
    # return array of organization which are satisfied all option values
    $ curr_today.rate_of_exchange
    $ curr_today.rate_of_exchange(Money::Currency.new('USD'), {:value => 'min', :spread => 'ask'})
    
