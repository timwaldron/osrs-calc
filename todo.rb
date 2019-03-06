
class Todolist
  attr_accessor :notebook

  def initialize(name)
    @username = name # @username is passed as todolist is initialized for specific user
    @notebook = []
    @choice = ""
  end

  def todo_app
    until @choice == 5 # until loop is used to avoid using !=
      puts `clear`
      puts "------- A Notebook For #{@username} ---------"
      puts "---- Options ----"
      puts
      puts "enter '1': add note"
      puts "enter '2': print notes"
      puts "enter '3': delete note"
      puts "enter '4': clear notes"
      puts "enter '5': to quit"
      puts
      print "Option: "
      loop_logic(gets.strip.to_i) # converting to integar for use in loop_logic
    end
  end

  def loop_logic(choice) # same loop as main using case statements was implemented
    case choice
    when 1
      add_todo
    when 2
      print_todos
    when 3
      delete_todo
    when 4
      clear_todos
    when 5
      write_file
      @choice = 5
      return nil
    end
  end

  def add_todo
    puts `clear`
    puts "----------- add note -------------"
    puts "!exit to quit"
    puts ""
    print "Note: "
    user_note = gets.chomp
    while user_note != "!exit"
      @notebook << user_note # pushing the user note into the notebook

      print "Note: "
      user_note = gets.chomp
    end
    write_file
  end

  def delete_todo
    puts `clear`
    puts "------- enter note number --------"
    input = gets.chomp # .chomp is used because i like the way it sounds
    @notebook.delete_at(input.to_i - 1) # -1 is used due to index being off by 1
    puts "press enter to exit"
    write_file
  end

  def print_todos
    i = 1 # counter intiated for counter
    puts `clear`
    puts "Last entry on: #{File.atime("notebook.txt")}"
    puts "-------- Notes for #{@username} ---------"
    File.open("notebook.txt", "r") do |f|
      f.each_line do |line| # prints out each line of the file with index
        puts "#{i}: #{line}"
        i += 1
      end
    end
    print "Press enter to return"
    gets
  end

  def write_file
    open("notebook.txt", "w") { |f|
      f.puts @notebook
    }
  end

  def clear_todos
    @notebook = []
    write_file
  end
end
