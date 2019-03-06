require './osrs_api_wrapper'
require 'net/http'
require 'tty-spinner'
require 'csv'

module SkillCalcs
    CALC_DATA_DIRECTORY = "calc_data/"
    CALC_DATA_RAW_URL = "https://raw.githubusercontent.com/timwaldron/osrs-calc/master/"
    LEVEL_DATA = "levels" # Unshifted onto the front of '@available_calcs' variable.

    @available_calcs = ["cooking", "firemaking", "fishing", "woodcutting"]
    @player_data = nil


    def self.capitalize_string(string)
        return string[0].upcase + string[1...string.length]
    end

    def self.check_calc_data_files()
        puts(`clear`)
        puts("Checking local data files...")
        puts("")
        new_info_for_user = false # Set this to true if there's new information for the user to view (new files, folders created, etc)

        directories_created = 0
        if (!Dir.exist?(CALC_DATA_DIRECTORY))
            puts("Unable to find directory '#{CALC_DATA_DIRECTORY}', creating...")
            Dir.mkdir(CALC_DATA_DIRECTORY)
            puts("Created directory #{CALC_DATA_DIRECTORY}")
            directories_created += 1
        end

        files_downloaded = 0
        start_time = Time.now

        @available_calcs.unshift(LEVEL_DATA) # Even though it's not a calc it's a file we need to have
        @available_calcs.each do |skill_data_file_name|
            if (!File.exist?("#{CALC_DATA_DIRECTORY}/#{skill_data_file_name}.csv"))
                print("Pulling '#{CALC_DATA_DIRECTORY}#{skill_data_file_name}.csv' from master branch... ")

                if (OSRS_Api_Wrapper::is_http_response_valid?(CALC_DATA_RAW_URL + CALC_DATA_DIRECTORY + skill_data_file_name + ".csv"))
                    repo_response = Net::HTTP.get(URI(CALC_DATA_RAW_URL + CALC_DATA_DIRECTORY + skill_data_file_name + ".csv"))
                    File.open(CALC_DATA_DIRECTORY + skill_data_file_name + ".csv", "a") {|f| f.write(repo_response)}
                    puts("done!")
                    files_downloaded += 1
                else
                    puts(" not found! (HTTP 404)")
                    @available_calcs.delete(skill_data_file_name)
                end

                new_info_for_user = true
            end

        end

        end_time = Time.now
        total_seconds = (end_time - start_time).round(3)

        if (new_info_for_user)
            puts("")

            if (directories_created > 0)
                puts("Created #{directories_created} directories")
            end

            puts("Downloaded #{files_downloaded} files in #{total_seconds} seconds")
            print("Press enter to continue...")

            gets()
        end
        @available_calcs.delete(LEVEL_DATA)
    end

    def self.get_available_calcs()
        return @available_calcs
    end

    def self.load_calculator(player_data, skill_name_as_string)
        @player_data = player_data # Set variable to argument of player data passed through from main.rb
        skill_level = player_data[skill_name_as_string]["level"].to_i
        skill_experience = player_data[skill_name_as_string]["experience"].to_i

        if (skill_experience < 0)
            skill_experience = 0
        end

        skill_calc_data = File.open(CALC_DATA_DIRECTORY + skill_name_as_string + ".csv")
        skill_calc_data  = CSV.parse(skill_calc_data, :headers => true) # parse our raw data into a variable with the headers flag/arguement set to true
        
        skill_calc_item_hash = {} # Empty hash for storing our player data to return
        
        skill_calc_data.each_with_index do |row, index| # Run through each line of the hiscore data we parsed as CSV
            row_data = row.to_hash
            skill_calc_item_hash[skill_calc_data[index]] = row_data # Create a new key in our hash
        end

        print(`clear`)
        puts("~~~~~ #{skill_name_as_string} calculator ~~~~~")
        puts("")
        puts("     Level: #{skill_level}")
        puts("Experience: #{self.add_commas(skill_experience)}")
        puts("")

        print("Please enter your desired level (#{skill_level + 1}-99): ")
        desired_level = gets().strip

        while (desired_level.to_i <= skill_level.to_i || desired_level.to_i > 99)
            print("Please enter your desired level (#{skill_level + 1}-99): ")
            desired_level = gets().strip
        end

        xp_of_desired_level = self.calculate_experience_gap(skill_experience, desired_level.to_i)
        xp_to_desired_level = xp_of_desired_level - skill_experience
        action_type = self.get_action_type(skill_name_as_string)
        # self.display_actions_til_level(xp_to_desired_level, skill_calc_item_hash, self.get_action_type(skill_name_as_string))

        print(`clear`)
        puts("To level #{self.capitalize_string(skill_name_as_string)} from #{skill_level} (#{self.add_commas(skill_experience)} xp) to #{desired_level} (#{self.add_commas(xp_of_desired_level)} xp) you will need to #{action_type}")
        puts("")

        skill_calc_item_hash.each do |key, item_data|
            if (item_data["level"].to_i <= skill_level)
                puts("#{self.add_commas(xp_to_desired_level / item_data["experience"].to_i)} x #{item_data["item"]}")
            end
        end

        puts("")
        print("Press enter to continue...")
        gets()
    end

    def self.add_commas(add_commas_to_string) # Simple string to
        comma_string = add_commas_to_string.to_s # make sure it's a string
        comma_string.reverse.scan(/\d{3}|.+/).join(',').reverse
    end

    def self.get_action_type(skill_name)
        case skill_name
        when "woodcutting"
            return "chop"
        when "cooking"
            return "cook"
        when "fishing"
            return "catch"
        when "firemaking"
            return "burn"
        else
            return "do"
        end
    end

    def self.calculate_experience_gap(starting_experience, desired_level)
        line_data = IO.readlines(CALC_DATA_DIRECTORY + LEVEL_DATA + ".csv")[desired_level - 1]
        level_data = line_data.split(",")
        return level_data[1].to_i
    end
end