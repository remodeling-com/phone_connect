require "phone_connect/version"
require "phone_connect/configuration"
require "phone_connect/real_phone_validation"

module PhoneConnect
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    def reset
      @configuration = Configuration.new
    end

    def fetch(phone_number)
      PhoneConnect::RealPhoneValidation.new(phone_number)
    end
  end
end
