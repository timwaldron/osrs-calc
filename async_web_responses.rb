require './prettifier'
require 'net/http'
require 'typhoeus'

module Async_Web_Responses

    def self.retrieve_web_data(base_url, array_of_items, type_of_parse = "json")
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
                    # body_data = {"file_name" => array_of_items[request_count], "file_data" => response.body}
                    body_data = {"file_data" => response.body}
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


    def self.check_calc_data()
        print(`clear`)
        base_url = 'http://services.runescape.com/m=itemdb_oldschool/api/catalogue/detail.json?item='
        skill_list = ["attack", "defence", "strength", "hitpoints", "ranged", "prayer", "magic", "cooking", "woodcutting", "fletching", "fishing", "firemaking", "crafting", "smithing", "mining", "herblore", "agility", "thieving", "slayer", "farming", "runecrafting", "hunter", "construction"]
        osrs_buddy_dir = "#{Dir.home}/.osrs_buddy/"
        calc_data_dir = "calc_data/"
        github_raw_repo_url = "https://raw.githubusercontent.com/timwaldron/osrs-calc/master/"
        files_pulled = 0
        dirs_made = 0

        puts("Checking local files in directory '$HOME/.osrs_buddy/'")

        if (!Dir.exist?(osrs_buddy_dir))

            puts("Directory '#{osrs_buddy_dir}' doesn't exist, creating now")
            Dir.mkdir(osrs_buddy_dir)
            Dir.mkdir(osrs_buddy_dir + calc_data_dir)
            dirs_made += 2
        end

        download_skills_queue = []
        skill_list.unshift("levels")

        skill_list.each do |skill|
            if (!File.exist?(osrs_buddy_dir + calc_data_dir + skill + ".csv"))
                download_skills_queue << skill
            end
        end

        puts("Checking for files on the GitHub master branch repository...")
        puts("URL: https://github.com/timwaldron/osrs-calc")
        puts("")
        
        start_time = Time.now
        hydra = Typhoeus::Hydra.new

        iterator = 0
        requests = download_skills_queue.length.times.map do
        # skill_list.each do |item|
            request = Typhoeus::Request.new(github_raw_repo_url + "calc_data/" + download_skills_queue[iterator] + ".csv", followlocation: true)
            iterator += 1
            hydra.queue(request)
            request
        end
        hydra.run
        
        responses = requests.map { |request|
            request.response.body
        }

        responses.each do |resp|
            
            if (!resp.include?("404: Not Found"))
                response_data_array = resp.split("\n") # Split the multi-lined response into a String array of each individual line
                skill_line_data = response_data_array[1].split(",") # Split each indiviual lines by a comma
                skill_name = skill_line_data[0] # The first index will always be the files name.
                
                puts(" * Pulled './calc_data/#{skill_name}.csv' from the master branch...")
                files_pulled += 1
                File.open(osrs_buddy_dir + calc_data_dir + skill_name + ".csv", "w") {|file| file.write(resp)}
            end
        end

        end_time = Time.now

        if (files_pulled > 0)
            puts("")
            puts("Processed #{download_skills_queue.length} requests in #{(end_time - start_time).round(3)} seconds")
            puts("Sucessfully pulled #{files_pulled} file#{'s' if files_pulled != 1} from the master branch")
            puts("")
            print("Press enter to continue...")
            gets()
        end
    end
end