require_relative "./skill_calcs"
require "./osrs_api_wrapper"
require "./todo"
require "tty-spinner"
require "awesome_print"

class Main
  include SkillCalcs

  def initialize()
    @username = nil
    @choice = nil
    @player_data = false
    # @osrs_api = OSRS_Api_Wrapper.new()
    login
  end

  def ascii_splash
    puts " ____                   ____                         "
    puts "|  _ \\ _   _ _ __   ___/ ___|  ___ __ _ _ __   ___   "
    puts "| |_) | | | | '_ \\ / _ \\___ \\ / __/ _` | '_ \\ / _ \\  "
    puts "|  _ <| |_| | | | |  __/___) | (_| (_| | |_) |  __/  "
    puts "|_| \\_\\\\__,_|_| |_|\\___|____/ \\___\\__,_| .__/ \\___|  "
    puts "                                       |_|           "
    puts ""
    puts "  B  U  D  D  Y  "
    puts ""
  end

  def login
    while true
      pls_or_sorry_pls_string = "Please" # If they enter a username not on the OSRS hiscores
      while @player_data == false
        print `clear`
        ascii_splash
        print "#{pls_or_sorry_pls_string} enter a valid username (or '!exit' to quit): "

        @username = gets.strip.downcase

        if (@username == "!exit")
          exit!
        end

        spinner = TTY::Spinner.new("[:spinner] Checking if #{@username} exists... ", format: :classic)
        spinner.auto_spin # Automatic animation with default interval
        @player_data = OSRS_Api_Wrapper::get_hiscore_data(@username)
        spinner.stop("Done!") # Stop animation

        if (@player_data == false) # If it player data returns false it wasn't sucessful.
          pls_or_sorry_pls_string = "Sorry,"
        end
      end
      menu
    end
  end

  def menu
    while @player_data != false
      print `clear`
      ascii_splash
      puts "------ Welcome #{@username} ------------"
      puts ""
      puts "1: View your skills"
      puts "2: Skill Calculator"
      puts "3: Notebook"
      puts "4: Log out of #{@username}"
      puts ""
      print "Option: "
      loop_logic(gets.strip.to_i)
    end
  end

  def loop_logic(choice)
    case choice
    when 1
      display_skills
    when 2
      skill_calculator
    when 3
      list = Todolist.new(@username)
      list.todo_app
    when 4
      @player_data = false
    end
  end

  def display_skills
    print `clear`
    puts "Skills: #{@username} -----------------------------"
    puts
    overall_maxed = []
    calculated_overall = false
    iterations = 0

    @player_data.each do |hiscore_entry, entry_hash| # hiscore_entry is the name, e.g Woodcutting, entry_hash a hash of Rank, Level and Experience
        puts "    #{Prettifier::capitalize_string(hiscore_entry)}"

        if (entry_hash["experience"].to_i < 0)
            entry_hash["experience"] = "0"
        end
        
        if (iterations < 24)
            puts "\tLevel:\t\t#{entry_hash["level"]}"
            puts "\tExp:\t\t#{Prettifier::add_commas(entry_hash["experience"])}"
            puts "\tRank:\t\t#{Prettifier::add_commas(entry_hash["rank"])}"

            percentage_to_99 = 0

            if (iterations == 0)
                skip_overall = false
                @player_data.each do |temp_hiscore_entry, temp_entry_hash|
                    if (!skip_overall)
                        skip_overall = true
                        next
                    end

                    if (temp_entry_hash["level"].to_i == 99)
                        skill_percentage = 100
                    else
                        skill_percentage = ((temp_entry_hash["experience"].to_i * 100).to_f / 13034431).to_i
                    end

                    overall_maxed << skill_percentage
                end

                player_percentage = 0
                overall_maxed.each do |item|
                    player_percentage += item
                end

                # percentage_to_max = ((player_percentage * 100).to_f / 2300).to_i
                percentage_to_max = ((player_percentage * 100).to_f / 2300).to_i
                puts "\t% to max:\t#{Prettifier.progress_bar(percentage_to_max)}" # 13034431 is level 99
            elsif (entry_hash["level"].to_i != 99)
                percentage_to_99 = ((entry_hash["experience"].to_i * 100).to_f / 13034431).to_i
                puts "\t% to 99:\t#{Prettifier.progress_bar(percentage_to_99)}" # 13034431 is level 99
            else
                puts "\t% to 99:\t#{Prettifier.progress_bar(100)}" # 13034431 is level 99
            end

        else
            puts "\tRank:\t\t#{Prettifier::add_commas(entry_hash["rank"])}"
            puts "\tAmount:\t\t#{Prettifier::add_commas(entry_hash["level"])}"
        end

        puts("")
        iterations += 1
    end

    puts "--------------------------------------------------"
    print "Press enter to return to the menu"
    gets.strip.downcase
  end

  def skill_calculator
    SkillCalcs::check_calc_data_files()
    skill_option = nil
    
    while skill_option != "!exit"
        print `clear`
        puts "Calculators: ~~~#{@username}~~~"
        puts ""
        
        calcs_available = SkillCalcs::get_available_calcs()
        calcs_available.each_with_index do |skill_name, index|

            puts("#{index + 1}: #{Prettifier::capitalize_string(skill_name)}")
        end

        puts ""

        print "Please select an option (or '!exit' to quit): "
        skill_option = gets().strip

        if (skill_option == "!exit")
            break
        end

        SkillCalcs::load_calculator(@player_data, calcs_available[skill_option.to_i - 1])
    end
  end
end

osrs_app = Main.new()