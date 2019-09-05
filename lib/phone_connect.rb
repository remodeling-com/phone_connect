require "phone_connect/version"
require "phone_connect/configuration"
require "phone_connect/real_phone_validation"

module PhoneConnect
  class << self
    attr_accessor :configuration
  end

  def self.response(phone_number)
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

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.reset
   @configuration = Configuration.new
  end
end
