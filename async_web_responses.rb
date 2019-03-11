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
        puts("#{number_of_requests} response#{'s' if number_of_requests != 1} in #{(end_time - start_time).round(3)} seconds")
        puts("")
        return response_data
    end
end