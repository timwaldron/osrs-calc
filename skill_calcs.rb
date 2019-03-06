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

        skill_level = player_data[skill_name_as_string]["level"]
        skill_experience = player_data[skill_name_as_string]["experience"]

        puts("Skill to calculate #{skill_name_as_string} using the data from #{skill_name_as_string}.csv")

        skill_calc_data = File.open(CALC_DATA_DIRECTORY + skill_name_as_string + ".csv")
        skill_calc_data  = CSV.parse(skill_calc_data, :headers => true) # parse our raw data into a variable with the headers flag/arguement set to true
        
        player_data = {} # Empty hash for storing our player data to return
        
        skill_calc_data.each_with_index do |row, index| # Run through each line of the hiscore data we parsed as CSV
            row_data = row.to_hash # Convert the row data to a hash
            puts("#{index + 1}: #{row_data}") 
        end

        gets()
        return nil

        case skill_name_as_string
        when "cooking"
            # self.cooking_calculator()
        when "firemaking"
            # self.firemaking_calculator()
        when "fishing"
            # self.fishing_calculator()
        when "woodcutting"
            self.woodcutting_calculator(skill_level, skill_experience)
        when "!exit"
            return nil
        end
    end

    def self.woodcutting_calculator(level, experience)
        in_skill = true

        while in_skill == true
            puts(`clear`)
            puts("~~~~~ Woodcutting Calculator ~~~~~")
            puts("")
            puts("     Level: #{level}")
            puts("Experience: #{experience}")
            puts("")
            gets()
        end
    end
end