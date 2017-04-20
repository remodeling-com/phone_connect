 module PhoneConnect
   class RealPhoneValidation
     BASE_URI = 'http://api.realvalidation.com/rpvWebService/RealPhoneValidationTurbo.php?token='
     ATTRIBUTES_LIST = ['response', 'status', 'error_text', 'iscell', 'cnam', 'carrier']
     attr_accessor :phone_number

     def initialize(phone_number)
       @phone_number = phone_number
       phone_number_cleaner!
     end

    def hashed_response
      @phone_data, @execution_time = phone_response
      @phone_data
    end

    def execution_time
      @execution_time
    end

    private

      # Clean phone number as 10 digits only
      def phone_number_cleaner!
        @phone_number =  @phone_number.gsub(/[^0-9]/, '')
        if @phone_number.to_s.size == 11 && @phone_number[0] == '1'
          @phone_number[0] = ''
        end
      end

      #return API response as HASH
      def phone_response
        token = PhoneConnect.configuration.token
        timeout_period = PhoneConnect.configuration.timeout.to_i
        retries = 3
         begin
           Timeout.timeout(timeout_period) do
             url = "#{BASE_URI}#{token}&phone=#{@phone_number}"

             start_time = Time.now
             response = HTTParty.get(url)
             execution_time = Time.now - start_time

             data = Hash.from_xml(response.parsed_response)['response']

             # return Hashed response
             return data, execution_time
           end
         rescue Timeout::Error
           retries -= 1
           return [{'status' => 'TIMEOUT', 'error_text' => 'Timeout'}, timeout_period] if retries == 0
           sleep 2
           retry
         rescue Exception => exception
           return [{'status' => 'ERROR', 'error_text' => exception.to_s}, -1]
         end
      end
   end
 end
