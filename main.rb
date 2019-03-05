class Main
  def initialize()
    @username = nil
    @choice = nil
    app
  end

  def app
    login
    menu
  end

  def login
    puts `clear`
    puts "Welcome to Runescape"
    puts "Please enter existing username"
    @username = gets.strip.downcase
  end

  def menu
    puts `clear`
    puts "--------- Old School RuneScape skill calculator ----------"
    puts "----------------------- Options ------------------------"
    puts "Welcome ~~~#{@username}~~~"
    puts "View your Skills - Press 1"
    puts "Skill Calculator - Press 2"
    puts "Enter a new username - Press 3"
    # choice = gets.strip
    loop_logic(gets.strip.to_i)
  end

  def loop_logic(choice)
    case choice
    when 1
      display_skills
    when 2
      skill_calculator
    when 3
      puts "test 3"
      app
    end
  end

  def display_skills
    puts "Skills: ~~~#{@username}~~~"
    menu
  end

  def skill_calculator
    # calculate skills
    menu
  end
end

osrs_app = Main.new()
