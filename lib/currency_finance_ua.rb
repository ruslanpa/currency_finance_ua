require 'open-uri'
require 'json'

# CurrencyFinanceUA is a wrapper of currency.finance.ua.
# Possibility to get rate of exchange for current date.
#
# All data provided by http://content.finance.ua/ru/xml/currency-cash/
class CurrencyFinanceUA
  HOST = 'http://resources.finance.ua/ua/public/currency-cash.json'

  class << self
    attr_reader :organizations, :cities, :value_of_rate

    # Example:
    #   >> option = { rate: 'min', bid_ask: 'ask' }
    #   >> CurrencyFinanceUA.rate_of_exchange('usd', option)
    #
    # Arguments:
    #   currency: (String)
    #     option: (Hash)
    def rate_of_exchange(currency = 'USD', option)
      json = JSON.parse(open(HOST).read)

      parse_cities json
      parse_organizations json

      @value_of_rate = min_or_max(currency, option[:rate], option[:bid_ask])
      @organizations.select do |organization|
        current_currency = organization.currencies[currency.upcase]
        unless current_currency.nil?
          current_currency[option[:bid_ask]].to_s == @value_of_rate
        end
      end
    end

    private

    # @return organizations parsed from json file
    #
    # Arguments:
    #   json: (JSON String)
    def parse_organizations(json)
      @organizations = []
      json['organizations'].each do |item|
        address = "#{find_city_by_id(item['cityId'])}, #{item['address']}"
        organization = Organization.new(item['title'], address)
        organization.phone = item['phone']
        organization.currencies = item['currencies']
        organization.link = item['link']
        @organizations << organization
      end
    end

    private

    # @return array of city_id
    def parse_cities(json)
      @cities = json['cities'].to_h
    end

    private

    # @return min or max value for current currency rate
    def min_or_max(currency, rate, bid_ask)
      values = []
      @organizations.each do |organization|
        currencies = organization.currencies[currency.upcase]
        values << currencies[bid_ask] unless currencies.nil?
      end
      values.send rate
    end

    private

    # Find city title by id
    def find_city_by_id(city_id)
      @cities[city_id]
    end
  end

  # The object witch store data of organization.
  class Organization
    attr_accessor :title, :address, :phone, :link, :currencies

    def initialize(title, address)
      @title = title
      @address = address
    end

    def to_s
      "#{@title} | #{phone} | #{@address}"
    end
  end
end

puts CurrencyFinanceUA.rate_of_exchange('RUB', { rate: 'max', bid_ask: 'bid' })
puts CurrencyFinanceUA.value_of_rate