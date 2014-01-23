require "currency_finance_ua/version"
require "currency_finance_ua/entity/exchanger"
require "open-uri"
require "json"

# It's a simple wrapper under <http://content.finance.ua/ru/xml/currency-cash>
#
# Return organizations which are satisfied for all options.
module CurrencyFinanceUA
  attr_reader :currency, :option, :exchangers, :cities, :rates

  # Example:
  #   $ get_rate_of_exchange('EUR', { rate: 'min', bid_ask: 'ask' })
  #
  # Arguments:
  #   currency: (String)
  #     option: (Hash)
  def get_rate_of_exchange(currency = 'USD', option)
    @currency, @option = currency, option

    json = JSON.parse(open('http://resources.finance.ua/ua/public/currency-cash.json').read)

    get_cities json

    get_exchangers json

    @exchangers.select { |exchanger| exchanger.rate == @rates.send(@option[:rate]) }
  end

  # @return available exchangers which are contains currency
  #
  # Arguments:
  #   json: (JSON String)
  def get_exchangers(json)
    @exchangers = []
    @rates = []
    json['organizations'].each do |item|
      currency = item['currencies'][@currency.upcase]
      unless currency.nil?
        rate = Float(currency[@option[:bid_ask]])
        @rates << rate
        exchanger = Exchanger.new(
            item['title'],
            "#{find_city_by_id(item['cityId'])}, #{item['address']}",
            item['phone'],
            rate
        )
        @exchangers << exchanger
      end
    end
  end

  # @return cities as hash object
  def get_cities(json)
    @cities = json['cities'].to_hash
  end

  # @return city title by id
  def find_city_by_id(city_id)
    @cities[city_id]
  end

  private :get_exchangers, :get_cities, :find_city_by_id
end