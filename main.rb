class Main
  def initialize()
    @ign = nil
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
    ign = gets.strip.downcase
  end

  def menu
    puts "--------- Old School RuneScape skill calculator ----------"
    puts "----------------------- Options ------------------------"
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
      puts "enter to exit"
      input = gets.strip
      if ""
        app
      end
    when 2
      skill_calculator
      puts "enter to exit"
      input = gets.strip
      if ""
        app
      end
    when 3
      puts "test 3"
      app
    end
  end

  def display_skills
  end

  def skill_calculator
  end
end

osrs_app = Main.new()
