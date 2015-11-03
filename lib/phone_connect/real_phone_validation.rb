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
      @phone_data = phone_response
    end

    #  def connected?
    #    if  @phone_data
    #      if status = @phone_data
    #        status = status.strip
    #      end
    #    end
    #    puts status.class
    #    return status
    #  end
     #
    #  def data(name)
    #    value = nil
    #    if (@phone_data)
    #      if (name == 'response'  && ATTRIBUTES_LIST.include?(name))
    #        value = @phone_data
    #      else
    #        value = @phone_data[name]
    #      end
    #    end
    #    return value
    #  end

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
             puts url
             response = HTTParty.get(url)
             data = Hash.from_xml(response.parsed_response)['response']
             #return Hashed response
             return data
           end
         rescue Exception => exception
           puts "RealPhone.connected? #{exception.inspect}"
           return true
         end
      end
   end
end
