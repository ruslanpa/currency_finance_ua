class Organization

  attr_accessor :title, :address, :phone, :link, :currencies

  def initialize(title, address, phone, link, currencies)
    @title = title
    @address = address
    @phone = phone
    @link = link
    @currencies = currencies
  end

  # Correct string representation
  def to_s
    "#{@title} | #{@address} | #{phone} | #{format_currencies_as_hashes}"
  end

  # Return currencies as hash instead json object
  def format_currencies_as_hashes
    if Hash.try_convert(@currencies).nil?
      @currencies
    else
      @currencies.to_hash
    end
  end
end