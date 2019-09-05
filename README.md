# PhoneConnect

This is Ruby gem integrated with [RealPhoneValidation](https://realphonevalidation.com/) API to validate / check if a US number number is active or not.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'phone_connect'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install phone_connect

## Usage

Add the following configurations in `config/initializers`:

```ruby
# phone_connect_config.rb
    
PhoneConnect.configure do |config|
  config.token = "5FA3B89E-21A4-C4E1-2AB2-B87BA3C1659F" # RealPhoneValidation Token
  config.timeout = 5 # Request Timeout
end
```

Then simply use the following command:
```ruby
response = PhoneConnect.response "9991112222" # your testing phone numebr
# => {"status"=>"connected", "error_text"=>nil, "iscell"=>"Y", "cnam"=>"WIRELESS CALLER", "carrier"=>"Verizon Wireless"}
# => {"status"=>"disconnected", "error_text"=>nil, "iscell"=>"N", "cnam"=>"Unavailable", "carrier"=>"Pioneer Tel Coop"}
# status could be connected|connected-75|busy|pending|disconnected
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/phone_connect. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

