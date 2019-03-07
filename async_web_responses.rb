require 'net/http'
require 'typhoeus'

module Async_Web_Responses

    def self.get_item_ge_data(array_of_item_ids_as_strings)
        grand_exchange_base_url = 'http://services.runescape.com/m=itemdb_oldschool/api/catalogue/detail.json?item='
        response_data = [] # Array of hashes
        start_time = Time.now
        number_of_requests = array_of_item_ids_as_strings.length
        request_id = 0
        request_count = 0
        
        hydra = Typhoeus::Hydra.new
        number_of_requests.times do
          request = Typhoeus::Request.new(grand_exchange_base_url + array_of_item_ids_as_strings[request_count], followlocation: true)
          request_count += 1
          request.on_complete do |response|

            case response.code
            when 200..299
                body_data = JSON.parse(response.body)
            else
                body_data = "Check status code"
            end

            response_data[request_id] = {"status" => response.code, "body" => body_data}
            request_id += 1
          end
          hydra.queue(request)
        end
        hydra.run
        
        end_time = Time.now
        puts("Received #{number_of_requests} responses in #{(end_time - start_time).round(3)} seconds")
        return response_data
    end
end

# include Async_Web_Responses

# my_data = Async_Web_Responses.get_http_response("null")
# binding.pry

# for i in 0...requests do

#     sleep(0.01)
    
#     Thread.new do
#         responses['response' + i.to_s] = test_class.get_http_response(grand_exchange_base_url + rand(1000..9000).to_s)
#         puts "Successfully requested"
    
#         if responses.count == requests
#             puts "Fetched all urls!"
#             break
#         end
#     end
# end

# end_time = Time.now
# sleep 10
# puts (responses.count.to_s)