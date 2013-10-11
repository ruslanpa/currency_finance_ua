require 'money'
require 'open-uri'
require 'organization'

# CurrencyFinanceUA is a wrapper of currency.finance.ua.
# Possibility to get rate of exchange for current date.
#
# All data provided by @see http://content.finance.ua/ru/xml/currency-cash/
class CurrencyFinanceUA

  HOST = 'http://resources.finance.ua/ua/public/currency-cash.json'

  attr_reader :json, :organizations, :currency

  # Load json file
  def load
    @json = JSON.parse(open(HOST).read)
    @organizations = []
    @json['organizations'].each do |org|
      @organizations.push Organization.new(org['title'], org['address'], org['phone'], org['link'], org['currencies'])
    end
  end

  def rate_of_exchange(currency = Money::Currency.new('USD'), option = {})
    @currency = currency
    organization option[:value], option[:spread]
  end

  private

  def organization(value, spread)
    value = value.nil? ? 'max' : value
    spread = spread.nil? ? 'ask' : spread

    currency_value = min_or_max value, spread

    available = []
    @organizations.each do |organization|
      currency = organization.currencies[@currency.iso_code.to_s]
      unless currency.nil?
        available.push organization if currency[spread].to_s.== currency_value
      end
    end
    available
  end

  private

  def min_or_max(value, spread)
    values = []
    @organizations.each do |organization|
      currency = organization.currencies[@currency.iso_code.to_s]
      values.push currency[spread] unless currency.nil?
    end
    values.send value
  end
end