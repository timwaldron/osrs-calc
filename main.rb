require './osrs_api_wrapper'
require_relative './skill_calcs'
require 'awesome_print'
require 'tty-spinner'

class Main
    include SkillCalcs

  def initialize()
    @username = nil
    @choice = nil
    @player_data = false
    # @osrs_api = OSRS_Api_Wrapper.new()
    login
  end

  def login
    while true
        pls_or_sorry_pls_string = "Please" # If they enter a username not on the OSRS hiscores
      while @player_data == false
        puts `clear`
        puts "       Welcome to the" # Below looks mangled, but because it uses the escape sequence I had to replace every '\' with '\\'
        puts " ____                   ____                         "     
        puts "|  _ \\ _   _ _ __   ___/ ___|  ___ __ _ _ __   ___   "      
        puts "| |_) | | | | '_ \\ / _ \\___ \\ / __/ _` | '_ \\ / _ \\  "      
        puts "|  _ <| |_| | | | |  __/___) | (_| (_| | |_) |  __/  "      
        puts "|_| \\_\\\\__,_|_| |_|\\___|____/ \\___\\__,_| .__/ \\___|  "     
        puts "                                       |_|           "    
        puts ""  
        puts "   S  K  I  L  L      C  A  L  C  U  L  A  T  O  R"
        puts ""
        print "#{pls_or_sorry_pls_string} enter a valid username (or '!exit' to quit): "

        @username = gets.strip.downcase

        if (@username == "!exit")
            exit!
        end

        spinner = TTY::Spinner.new("[:spinner] Checking if #{@username} exists... ", format: :classic)
        spinner.auto_spin # Automatic animation with default interval
        @player_data = OSRS_Api_Wrapper::get_hiscore_data(@username)
        spinner.stop('Done!') # Stop animation

        if (@player_data == false) # If it player data returns false it wasn't sucessful.
            pls_or_sorry_pls_string = "Sorry,"
        end
      end
      menu
    end
  end

  def menu
    while @player_data != false
      puts `clear`
      puts "--------- Old School RuneScape skill calculator ----------"
      puts "----------------------- Options ------------------------"
      puts "Welcome ~~~#{@username}~~~"
      puts "View your Skills - Press 1"
      puts "Skill Calculator - Press 2"
      puts "Return to login screen - Press 3"
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
      @player_data = false
    end
  end

  #   def display_skills
  #     puts "Skills:   ~~~~~~~~~~~~~#{@username}~~~~~~~~~~~~~"
  #     @player_data.each do |skill_data|
  #       ap skill_data, :indent => -2, :multiline => false
  #     end
  #     puts "Enter enter to return to the menu"
  #     gets.strip.downcase
  #   end

  def display_skills
    puts "Skills:   ~~~~~~~~~~~~~#{@username}~~~~~~~~~~~~~"
    puts "-----------"
    @player_data.each do |key, value|
      puts value
      print key
    end
    puts "--------------------------------------------------"
    puts "Enter enter to return to the menu"
    gets.strip.downcase
  end

  def capitalize_string(string)
    return string[0].upcase + string[1...string.length]
  end

  def skill_calculator
    SkillCalcs::check_calc_data_files()
    puts `clear`
    puts "Calculators: ~~~#{@username}~~~"
    puts ""
    
    calcs_available = SkillCalcs::get_available_calcs()

    calcs_available.each_with_index do |skill_name, index|
        puts("#{index + 1}: #{capitalize_string(skill_name)}")
    end

    puts ""
    print "Please select an option (or '!exit' to quit): "
    skill_option = gets().strip

    if (skill_option == "!exit")
        return nil
    end

    SkillCalcs::load_calculator(@player_data, calcs_available[skill_option.to_i - 1])
  end
end

osrs_app = Main.new()