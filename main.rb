require "./osrs-api-wrapper"
require "awesome_print"

class Main
  def initialize()
    @username = nil
    @choice = nil
    @player_data = false
    @osrs_api = OSRS_Api_Wrapper.new()
    login
  end

  def login
    while true
      while @player_data == false
        puts `clear`
        puts "Welcome to Runescape"
        puts "Please enter existing username"
        @username = gets.strip.downcase
        @player_data = @osrs_api.username_exists?(@username)
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
      puts "Enter a new username - Press 3"
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

  def display_skills
    puts "Skills:   ~~~~~~~~~~~~~#{@username}~~~~~~~~~~~~~"
    @player_data.each do |skill_data|
      ap skill_data, :indent => -2, :multiline => false
    end
    puts "Enter enter to return to the menu"
    gets.strip.downcase
  end

  def skill_calculator
    # calculate skills
    gets.strip.downcase
  end
end

osrs_app = Main.new()
