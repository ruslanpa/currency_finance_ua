require 'money'
require 'open-uri'

# CurrencyFinanceUA is a wrapper of currency.finance.ua.
# Possibility to get rate of exchange for current date.
#
# All data provided by @see http://content.finance.ua/ru/xml/currency-cash/
class CurrencyFinanceUA
  HOST = 'http://resources.finance.ua/ua/public/currency-cash.json'

  class << self
    attr_reader :organizations, :cities, :currency, :rate, :value_of_rate

    # Load json file and parse it to organization entity.
    #
    # Example:
    #   >> CurrencyFinanceUA.load
    #
    def load
      json = JSON.parse(open(HOST).read)
      @cities = json['cities'].to_h
      @organizations = []
      json['organizations'].each do |i|
        currencies = i['currencies']
        unless currencies.nil? || currencies.empty?
          @organizations << Organization.new(i['title'], find_city_by_id(i['cityId']), i['phone'], i['address'], i['link'], currencies)
        end
      end
    end

    # Example:
    #   >> usd = Money::Currency.new('USD')
    #   >> CurrencyFinanceUA.rate_of_exchange(usd, {:rate = > 'min', :bid_ask => 'ask'})
    #
    def rate_of_exchange(currency = Money::Currency.new('USD'), option)
      @currency = currency

      @rate = option[:rate]
      bid_ask = option[:bid_ask]

      unless @organizations.nil? || @organizations.empty?
        @value_of_rate = min_or_max(currency, @rate, bid_ask)
        @organizations.select do |organization|
          current_currency = organization.currencies[currency.iso_code.to_s]
          unless current_currency.nil?
            current_currency[bid_ask].to_s == @value_of_rate
          end
        end
      end
    end

    # @return min or max value for current currency rate
    def min_or_max(currency, rate, bid_ask)
      values = []
      @organizations.each do |organization|
        currencies = organization.currencies[currency.iso_code.to_s]
        unless currencies.nil?
          values << currencies[bid_ask]
        end
      end
      values.send rate
    end

    # Find city title by id
    def find_city_by_id(city_id)
      @cities[city_id]
    end

    private :min_or_max, :find_city_by_id
  end

  # The object witch store data of organization.
  #
  class Organization
    attr_accessor :title, :city, :phone, :address, :link, :currencies

    def initialize(title, city, phone, address, link, currencies)
      @title = title
      @city = city
      @phone = phone
      @address = address
      @link = link
      @currencies = currencies
    end

    def to_s
      "#{@title} | #{phone} | #{city}, #{@address} | #{@currencies.keys}"
    end
  end
end