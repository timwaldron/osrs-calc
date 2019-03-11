require './osrs_api_wrapper'
require './prettifier'
require './async_web_responses'
require 'net/http'
require 'tty-spinner'
require 'csv'
require 'pry'
require 'terminal-table'

module SkillCalcs
    include Async_Web_Responses
     # Folder of the current working directory, future plan is to roll this out as ~/.calc_data/
    CALC_DATA_DIRECTORY = "calc_data/"

    # URL to the base data raw data in the master branch of the GitHub repository
    CALC_DATA_RAW_URL = "https://raw.githubusercontent.com/timwaldron/osrs-calc/master/"

    # Unshifted onto the front of '@available_calcs' variable to make sure we download 'levels.csv' as it's not a skill calculator
    LEVEL_DATA = "levels" 

    # Available calculators, future plan is to have this list potentially in GitHub so we can determine what calcs are avalable.
    # But this may limit someone who clones the repo from creating their own skill data
    @available_calcs = ["attack", "defence", "strength", "hitpoints", "ranged", "prayer", "magic", "cooking", "woodcutting", "fletching", "fishing", "firemaking", "crafting", "smithing", "mining", "herblore", "agility", "thieving", "slayer", "farming", "runecrafting", "hunter", "construction"]
    #@available_calcs = ["cooking", "firemaking", "fishing", "ranged", "woodcutting"]

    # @player_data is common variable name used throughout this project to store a hashed copy of
    # the user's hiscore data that's easily readable
    @player_data = false

    # Enable this to variable by setting it to true so you can test functions
    @testing_mode = true

    # Function to check if all the files that are utilised by this program are where they should be.
    def self.check_calc_data_files()
        puts(`clear`)
        puts("Checking local data files...")
        puts("")

        # Set this to true if there's any new information for the user to see (new files or folders created, etc)
        new_info_for_user = false 

        # This variable is used to capture the time before potentially have to download files (to give a user an estimate time to complete)
        start_time = Time.now

        # There's only 1 directory created at the moment, but using an Integer as opposed to a Boolean will futureproof this project.
        directories_created = 0
        
        # Same as the directories variable but used for when we pull data files from the master branch of the repo.
        files_downloaded = 0 

        # Checks if the directory doesn't exist, if it doesn't it'll make it
        if (!Dir.exist?(CALC_DATA_DIRECTORY)) 
            puts("Unable to find directory '#{CALC_DATA_DIRECTORY}', creating...")
            Dir.mkdir(CALC_DATA_DIRECTORY)
            puts("Created directory #{CALC_DATA_DIRECTORY}")
            directories_created += 1
        end

        # Even though it's not a calc file it's still needed, so we'll temporarily wack it onto the front of the array
        @available_calcs.unshift(LEVEL_DATA)

        # Stores the temporary responses of web requess
        files_to_pull = []
        temp_responses = {}
        # Run through the available calculators array
        puts("Repository: https://github.com/timwaldron/osrs-calc")
        @available_calcs.each do |skill_data_file_name|

            # Checks if the file doesn't exist in our ./calc_data
            if (!File.exist?("#{CALC_DATA_DIRECTORY}/#{skill_data_file_name}.csv"))
                puts("Requesting '#{CALC_DATA_DIRECTORY}#{skill_data_file_name}.csv' from the master branch... ")
                files_to_pull << "#{skill_data_file_name}.csv"
            end
        end

        puts("")
        skill_calc_web_data = Async_Web_Responses::retrieve_web_data("#{CALC_DATA_RAW_URL}/#{CALC_DATA_DIRECTORY}", files_to_pull, "download")

        skill_calc_web_data.each do |response|
            if (response["status"] == 200)
                # puts("#{response["body"]["file_name"]}")
                puts("Response: #{response}")
                # Simple write file statement using the data we pulled in the previous statement
                # File.open(CALC_DATA_DIRECTORY + skill_data_file_name + ".csv", "a") {|file| file.write(repo_response)} 
                files_downloaded += 1
            end
        end

        #         # Checks if the file returns a HTTPOK (2xx)
        #         if (OSRS_Api_Wrapper::is_http_response_valid?(CALC_DATA_RAW_URL + CALC_DATA_DIRECTORY + skill_data_file_name + ".csv")) 

        #             # This variable stores the raw data from our GitHub repo making it ready to dump into a file local.
        #             repo_response = Net::HTTP.get(URI(CALC_DATA_RAW_URL + CALC_DATA_DIRECTORY + skill_data_file_name + ".csv"))

        #             # Simple write file statement using the data we pulled in the previous statement
        #             File.open(CALC_DATA_DIRECTORY + skill_data_file_name + ".csv", "a") {|file| file.write(repo_response)} 

        #             puts("done!")
        #             files_downloaded += 1
        #         else
        #             # Remove the 404'd skill as other modules/files piggy-back off the @available_calcs variable
        #             @available_calcs = @available_calcs.delete(skill_data_file_name) 
        #             puts("file not found! (HTTP 404)")
        #         end

        #         new_info_for_user = true
        #     end

        # end

        # Record the time after the potential downloads are finished
        end_time = Time.now 

        # Take the end_time from the start_time which will return the total seconds it tooke to complete
        # rounded to 3 decimal places to make it a little neater when outputting
        total_seconds = (end_time - start_time).round(3) 

        if (new_info_for_user)
            puts("")

            if (directories_created > 0)
                puts("Created #{directories_created} director#{'y' if directories_created == 1}#{'ies' if directories_created > 1}")
            end

            puts("Downloaded #{files_downloaded} file#{'s' if files_downloaded != 1} in #{total_seconds} seconds")
            print("Press enter to continue...")
            gets()
        end

        # Remove the LEVEL DATA string out of the @available_calcs array of strings, like mentioned it's utilised in other functions
        @available_calcs.delete(LEVEL_DATA)

        gets()
    end

    def self.get_available_calcs()
        return @available_calcs
    end
    
    # Parse in hiscore data and the skill name as a string as arguments
    def self.load_calculator(player_data, skill_name_as_string) 
        # Set variable to argument of player data passed through from the Main class
        @player_data = player_data

        # Pull the skill's level out of of the hash @player_data variable
        skill_level = @player_data[skill_name_as_string]["level"].to_i 

        # Pull the skill's experience out of of the hash @player_data
        skill_experience = @player_data[skill_name_as_string]["experience"].to_i

        # Edge case: If a player hasn't trained a skill it will return or it is to low to be on hiscores it will return
        # "-1", so we'll check for that and set the skill experience to 0
        if (skill_experience < 0)
            skill_experience = 0
        end

        # Load the contents of the specific skills calculator CSV
        skill_calc_data = File.open(CALC_DATA_DIRECTORY + skill_name_as_string + ".csv")

        # parse our skill calc into a variable with the headers flag/arguement set to true
        skill_calc_data = CSV.parse(skill_calc_data, :headers => true) 

        # Empty hash for storing our player data to pull data from
        skill_calc_item_array = []
        # Run through each row of CSV data we've read into a variable
        
        skill_calc_data.each_with_index do |row, index|
            # Create a new variable and set it to the value of the row variable when coerced into a hash
            row_data = row.to_hash
            
            # Create a new key in our hash
            skill_calc_item_array << row_data
        end

        print(`clear`)
        puts("~~~~~ #{Prettifier::capitalize_string(skill_name_as_string)} Calculator ~~~~~")
        puts("")
        puts("     Level:\t#{skill_level}")
        puts("Experience:\t#{Prettifier::add_commas(skill_experience)}")

        # If the player already has the skill level 99 then we can't calculate the next level
        if (skill_level == 99)
            puts("")
            puts("   % to 99:\t#{Prettifier.progress_bar(100)}")
            puts("")
            puts("Very nice level 99 #{Prettifier::capitalize_string(skill_name_as_string)}")
            puts("But unfortunately we can't calculate a maxed skill")
            puts("")
            print("Press enter to return...")
            gets()
            return nil
        else
            puts("")
            puts("   % to #{skill_level + 1}:\t#{Prettifier.progress_bar(((skill_experience * 100).to_f / self.calculate_experience_gap(skill_experience, skill_level + 1)).to_i)}") # 13034431 is level 99
            puts("   % to 99:\t#{Prettifier.progress_bar(((skill_experience * 100).to_f / 13034431).to_i)}") # 13034431 is level 99
        end

        puts("")
        # Ask the user for input regarding their desired level
        print("Please enter your desired level (#{skill_level + 1}-99): ")
        desired_level = gets().strip

        # If the user's input is invalid
        while (desired_level.to_i <= skill_level.to_i || desired_level.to_i > 99)
            print("Please enter a CORRECT desired level (#{skill_level + 1}-99): ")
            desired_level = gets().strip
        end

        # Calculates and stores in a variable the XP required of their desired level
        xp_of_desired_level = self.calculate_experience_gap(skill_experience, desired_level.to_i)

        # Calculates and stores in a variable the difference between their current XP  and desired level XP
        xp_to_desired_level = xp_of_desired_level - skill_experience

        # Call's what action they'll be doing depending on their skill: 'chop' wood, 'catch' fish, 'burn' logs
        action_type = self.get_skill_info(skill_name_as_string)

        print(`clear`)
        puts("To get from level #{skill_level} #{Prettifier::capitalize_string(skill_name_as_string)} (#{Prettifier::add_commas(skill_experience)} xp) to #{desired_level} (#{Prettifier::add_commas(xp_of_desired_level)} xp) you will need to #{action_type[0]}")
        puts("")

        
        array_of_item_ids = []

        skill_calc_item_array.each do |item|
            array_of_item_ids << item["item_id"]
        end

        item_cost = Async_Web_Responses::get_item_ge_data(array_of_item_ids)
        
        item_array = []
        item_cost.each_with_index do |hash, index|

            if (hash["status"] == 200)
                item_price = hash["body"]["item"]["current"]["price"]

                if (hash["body"]["item"]["current"]["price"].class != Integer)
                    item_price.gsub!(",", "")
                end

                # gets()
                # item_price = hash["body"]["item"]["current"]["price"].gsub(",", "")
                # puts("#{hash["body"]["item"]["name"]}")
                item_array << {"item_name": hash["body"]["item"]["name"], "item_price": item_price.to_i}
            end
        end
        
        rows = []
        only_show_available_items = true

        if (only_show_available_items)
            puts("Showing items you have the level requirement for")
        end

        item_array.each do |item_array_item|
            skill_calc_item_array.each do |skill_calc_item|

                if (only_show_available_items)
                    if (item_array_item[:item_name].downcase == skill_calc_item["item"].downcase)
                        item_cost = item_array_item[:item_price]
                        amount_of_actions = xp_to_desired_level / skill_calc_item["experience"].to_i

                        if (skill_calc_item["level"].to_i <= skill_level.to_i)
                            rows << [Prettifier::add_commas(amount_of_actions), skill_calc_item["item"], Prettifier::add_commas(item_cost * amount_of_actions) + " GP"]
                        end
                    end
                end
            end
        end

        prof_cost = get_skill_info(skill_name_as_string)

        table = Terminal::Table.new :headings => ['Actions', 'Item', "Estimated #{prof_cost[1]}"], :rows => rows

        puts table

        puts("")
        print("Press enter to continue...")
        gets()
    end

    # Method takes a skill name as a string as an argument and returns a strong of the type of action associated with it
    def self.get_skill_info(skill_name)
        case skill_name.downcase
        when "woodcutting" # With the Woodcutting skill you chop logs
            return ["chop", "profit"]  # E.g You need to 'chop' 10,000 x Willow Logs to get to level x
        when "cooking"
            return ["cook", "cost"]
        when "fishing"
            return ["catch", "profit"]
        when "firemaking"
            return ["burn", "cost"]
        else
            return "do" # Do fish, do cakes, do ores.
        end
    end

    # simple function to get the total XP of a level 
    def self.calculate_experience_gap(starting_experience, desired_level)
        # Using the IO class to read a specific line from our csv file
        line_data = IO.readlines(CALC_DATA_DIRECTORY + LEVEL_DATA + ".csv")[desired_level - 1]

        # It has two columns, first one being level, second one being total xp
        column_data = line_data.split(",")
        return column_data[1].to_i
    end
end