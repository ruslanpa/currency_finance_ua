require 'open-uri'
require 'json'

# A simple wrapper under http://content.finance.ua/ru/xml/currency-cash/
# Possibility to get rate of exchange for current date, in the UAH equivalent
#
# All data provided by http://content.finance.ua/ru/xml/currency-cash/
class CurrencyFinanceUA
  HOST = 'http://resources.finance.ua/ua/public/currency-cash.json'

  class << self
    attr_reader :currency, :option, :orgs, :cities, :value_of_rate

    # Example:
    #   >> option = { rate: 'min', bid_ask: 'ask' }
    #   >> CurrencyFinanceUA.rate_of_exchange('USD', option)
    #
    # Arguments:
    #   currency: (String)
    #     option: (Hash)
    def rate_of_exchange(currency = 'USD', option)
      @currency, @option = currency, option

      json = JSON.parse(open(HOST).read)

      parse_cities json
      parse_orgs json

      min_or_max
      
      @orgs.select { |i| i.rate_of_exchange == @value_of_rate }
    end

    private

    # @return available organizations which contains current currency
    #
    # Arguments:
    #   json: (JSON String)
    def parse_orgs(json)
      @orgs = []
      json['organizations'].each do |i|
        c = i['currencies'][@currency.upcase]
        unless c.nil?
          address = "#{find_city_by_id(i['cityId'])}, #{i['address']}"
          org = Organization.new(i['title'], address, i['phone'])
          org.rate_of_exchange = Float(c[@option[:bid_ask]])
          @orgs << org
        end        
      end
    end  

    private

    # @return cities as hash object
    def parse_cities(json)
      @cities = json['cities'].to_hash
    end

    private

    # @return min or max value of rate
    def min_or_max
      @orgs.sort_by! { |a| a.rate_of_exchange}
      unless @orgs.empty?
        org = @orgs[0]
        if @option[:rate] == 'max' 
          org = @orgs[-1]
        end
        @value_of_rate = org.rate_of_exchange
      end      
    end

    private

    # @return city title by id
    def find_city_by_id(city_id)
      @cities[city_id]
    end
  end

  # The object witch store data of organization.
  #
  # Arguments:
  #              title: (String)
  #            address: (String)
  #              phone: (String)
  #   rate_of_exchange: (Float)
  class Organization
    attr_accessor :title, :address, :phone, :rate_of_exchange

    def initialize(title, address, phone)
      @title = title
      @address = address
      @phone = phone
    end

    def to_s
      "#{@title} | #{phone} | #{@address} | #{@rate_of_exchange} UAH"
    end
  end
end