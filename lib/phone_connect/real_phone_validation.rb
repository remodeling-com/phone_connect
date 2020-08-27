require 'httparty'

module PhoneConnect
  class RealPhoneValidation
    include HTTParty
    base_uri 'https://api.realvalidation.com'

    attr_reader :phone_number, :execution_time

    def initialize(phone_number)
      @phone_number = phone_number
      normalize!
    end

    def connected?
      status = response['status']
      return false unless status

      !!status.match(/^(connected|connected-75|busy|pending)$/i)
    end

    def response
      @parsed_response ||= validate
    end

    def dnc_response
      @parsed_response ||= dnc_validate
    end

    private

    def normalize!
      @phone_number =  @phone_number.to_s.gsub(/[^0-9]/, '')
      # Remove first digit `1` (US key) if the phone's length is 11 digits
      @phone_number[0] = '' if @phone_number.length == 11 && @phone_number[0] == '1'
    end

    def options
      {
        verify: false,
        timeout: PhoneConnect.configuration.timeout,
        body: {
          output: 'json',
          token: PhoneConnect.configuration.token,
          phone: @phone_number
        }
      }
    end

    def validate
      start_time = Time.now
      retries = 3
      result = {}
      begin
        result = self.class.post('/rpvWebService/RealPhoneValidationTurbo.php', options).parsed_response
      rescue Timeout::Error
        retries -= 1
        if retries.positive?
          sleep 1; retry
        end
        result = { 'status' => 'TIMEOUT', 'error_text' => 'Timeout' }
      rescue Exception => exception
        result = { 'status' => 'ERROR', 'error_text' => exception.to_s }
      end
      @execution_time = Time.now - start_time

      result
    end

    def dnc_validate
      start_time = Time.now
      retries = 3
      result = {}
      begin
        result = self.class.post('/rpvWebService/DNCLookup.php', options).parsed_response
      rescue Timeout::Error
        retries -= 1
        if retries.positive?
          sleep 1; retry
        end
        result = { 'status' => 'TIMEOUT', 'error_text' => 'Timeout' }
      rescue Exception => exception
        result = { 'status' => 'ERROR', 'error_text' => exception.to_s }
      end
      @execution_time = Time.now - start_time

      result
    end
  end
end
