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
      @phone_data = phone_response[0]
    end

    def execution_time
      @time = phone_response[1]
      return @time
    end

     private

     #Clean phone number as 10 digits only
      def phone_number_cleaner!
        @phone_number =  @phone_number.gsub(/[^0-9]/, '')
        if @phone_number.to_s.size == 11 && @phone_number[0] == '1'
          @phone_number[0] = ''
        end
      end

      #return API response as HASH
      def phone_response
        token = PhoneConnect.configuration.token

         begin
           timeout(8) do
             url = "#{BASE_URI}#{token}&phone=#{@phone_number}"
             request_time = Time.now
             response = HTTParty.get(url)
             response_time = Time.now if response
             data = Hash.from_xml(response.parsed_response)['response']
             time = response_time - request_time if response
             #return Hashed response
             return data, time
           end
         rescue Exception => exception
           return true
         end
      end
   end
end
