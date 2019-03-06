
class Todolist
  attr_accessor :todo_list

  def initialize(name)
    @username = name
    @todo_list = []
    @choice = ""
  end

  def todo_app
    until @choice == 5
      puts `clear`
      puts "------- A Todo List For #{@username} ---------"
      puts "Would you like to-do?"
      puts "enter '1': to add todo"
      puts "enter '2': delete todo"
      puts "enter '3': print todos"
      puts "enter '4': clear todos"
      puts "enter '5': to exit"
      loop_logic(gets.strip.to_i)
    end
  end

  def loop_logic(choice)
    case choice
    when 1
      add_todo
    when 2
      delete_todo
    when 3
      print_todos
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
    input = nil
    puts "----------- add todo -------------"
    puts "!exit to quit"
    until input == "!exit"
      input = gets.chomp
      @todo_list << input
    end
  end

  def delete_todo
    puts `clear`
    puts "------- enter todo number --------"
    input = gets.chomp
    @todo_list.delete_at(input.to_i - 1)
    puts "press enter to exit"
  end

  def print_todos
    i = 1
    write_file
    puts `clear`
    puts "-------- TODO LIST for #{@username} ---------"
    File.open("todo_list.txt", "r") do |f|
      f.each_line do |line|
        puts "#{i}: #{line}"
        i += 1
      end
    end
    puts "----------------------------------------> #{File.atime("todo_list.txt")}"
    puts "press enter to exit"
    gets
  end

  def write_file
    open("todo_list.txt", "a") { |f|
      f.puts @todo_list
    }
  end

  def clear_todos
    File.open("todo_list.txt", "w") { }
  end
end
