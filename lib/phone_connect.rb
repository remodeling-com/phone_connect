require "phone_connect/version"
require "phone_connect/configuration"
require "phone_connect/real_phone_validation"

begin
rescue LoadError
end

module PhoneConnect
  class << self
    attr_accessor :configuration
  end

  def self.response phone_number
    @real_phone_validation_object = PhoneConnect::RealPhoneValidation.new(phone_number)
    @response = @real_phone_validation_object.hashed_response
  end

  def self.execution_time
    if @real_phone_validation_object
      @real_phone_validation_object.execution_time
    else
      fail 'Error.. '
    end
  end
  #optional functions if we need it
  #return just status

  def self.connected? phone_number
   if @real_phone_validation_object
     @response = @real_phone_validation_object.connected?
   else
     response phone_number
   end
  end


  # return data for a given attribute
  def self.data(name)
   if @real_phone_validation_object
     @response = @real_phone_validation_object.data(name)
   else
     'ERROR..NO RESposne'
   end
  end


  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.reset
   @configuration = Configuration.new
  end
end
