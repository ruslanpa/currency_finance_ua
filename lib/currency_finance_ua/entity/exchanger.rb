# Exchanger entity class.
# A place where foreign currency can be exchanged.
#
# Arguments:
#              title: (String)
#            address: (String)
#              phone: (String)
#               rate: (Float)
class Exchanger
  attr_accessor :title, :address, :phone, :rate

  def initialize(title, address, phone, rate)
    @title, @address, @phone, @rate = title, address, phone, rate
  end

  def to_s
    "#{@title} | #{phone} | #{@address} | #{@rate} UAH"
  end
end