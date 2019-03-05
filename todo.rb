
class Todolist
  attr_accessor :todo_list

  def initialize
    @todo_list = []
    @choice = ""
  end

  def todo_app
    until @choice == 4
      puts `clear`
      puts "------- Just another boring Todo list ---------"
      puts "Would you like to-do?"
      puts "enter '1': to add todo"
      puts "enter '2': delete todo"
      puts "enter '3': print todos"
      puts "enter '4': to exit"
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
    end
  end

  def add_todo
    puts `clear`
    puts "----------- add todo -------------"
    input = gets.chomp
    @todo_list << input
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
    puts `clear`
    puts "-------- TODO LIST ---------"
    todo_list.each do |x|
      p "#{i}: #{x}"
      i += 1
    end
    puts "press enter to exit"
    gets
  end
end

class TodoItem
  def initialize(todo)
    @todo = todo
  end
end
