require 'net/http'
require 'concurrent'
require 'typhoeus'

class Async_Web_Responses
    include Concurrent::Async

    def get_http_response(url_to_get_response)
        response = Net::HTTP.get_response(URI(url_to_get_response))
        return response.code
    end
end

test_class = Async_Web_Responses.new()
grand_exchange_base_url = 'http://services.runescape.com/m=itemdb_oldschool/api/catalogue/detail.json?item='



puts("Starting Requests: ")
start_time = Time.now
number_of_requests = 25
item_sample = ["1511", "1521", "1519", "6333", "1517", "6332", "1515", "1513", "19669"]

hydra = Typhoeus::Hydra.new
number_of_requests.times do
  request = Typhoeus::Request.new(grand_exchange_base_url + item_sample.sample, followlocation: true)
  request.on_complete do |response|
    puts("")
    puts("Response Code: #{response.code}")
    puts("Response Body: #{response.body}")
    puts("")
  end
  hydra.queue(request)
end
hydra.run

end_time = Time.now

puts("")
puts("Done!")
puts("Got #{number_of_requests} responses in #{end_time - start_time} seconds")
sleep


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