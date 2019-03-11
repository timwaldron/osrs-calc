require 'net/http'
require 'typhoeus'

module Async_Web_Responses

    def self.retrieve_web_data(base_url, array_of_items, type_of_parse = "json")# header_data = "rank,level,experience\n")
        # base_url = 'http://services.runescape.com/m=itemdb_oldschool/api/catalogue/detail.json?item='
        response_data = [] # Array of hashes
        start_time = Time.now
        number_of_requests = array_of_items.length
        request_id = 0
        request_count = 0
        
        hydra = Typhoeus::Hydra.new
        number_of_requests.times do
          request = Typhoeus::Request.new(base_url + array_of_items[request_count], followlocation: true)
          request_count += 1

          request.on_complete do |response| # After each response finishes

            # Filter response data
            case response.code
            when 200..299
                if (type_of_parse.downcase == "json")
                    body_data = JSON.parse(response.body)
                elsif (type_of_parse == "csv")
                    # body_data = CSV.parse(header_data, headers: true) # parse our raw data into a variable with the headers flag/arguement set to true
                elsif (type_of_parse == "download")
                    body_data = {"file_name" => array_of_items[request_count], "file_data" => response.body}
                else
                    body_data = "Unimplemented Parse Type: #{type_of_parse}"
                    return nil
                end
            else
                body_data = "Check status code"
            end

            # Process reponse data
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