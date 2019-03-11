# frozen_string_literal: true

# Editing the default String class
class String
  # Ooft, https://cbabhusal.wordpress.com/2015/10/02/ruby-printing-colored-formatted-character-in-ruby-colorize/
  def default
    "\e[30m#{self}\e[0m"
  end

  def black
    "\e[30m#{self}\e[0m"
  end

  def red
    "\e[31m#{self}\e[0m"
  end

  def green
    "\e[32m#{self}\e[0m"
  end

  def yellow
    "\e[33m#{self}\e[0m"
  end

  def blue
    "\e[34m#{self}\e[0m"
  end

  def magenta
    "\e[35m#{self}\e[0m"
  end

  def cyan
    "\e[36m#{self}\e[0m"
  end

  def gray
    "\e[37m#{self}\e[0m"
  end

  def bg_black
    "\e[40m#{self}\e[0m"
  end

  def bg_red
    "\e[41m#{self}\e[0m"
  end

  def bg_green
    "\e[42m#{self}\e[0m"
  end

  def bg_yellow
    "\e[43m#{self}\e[0m"
  end

  def bg_blue
    "\e[44m#{self}\e[0m"
  end

  def bg_magenta
    "\e[45m#{self}\e[0m"
  end

  def bg_cyan
    "\e[46m#{self}\e[0m"
  end

  def bg_gray
    "\e[47m#{self}\e[0m"
  end

  def bold
    "\e[1m#{self}\e[22m"
  end

  def italic
    "\e[3m#{self}\e[23m"
  end

  def underline
    "\e[4m#{self}\e[24m"
  end

  def blink
    "\e[5m#{self}\e[25m"
  end

  def reverse_color
    "\e[7m#{self}\e[27m"
  end
end

# Module used for displaying pretty progress bars
module Prettifier
  def self.progress_bar(percentage_of_completion)
    perc_string = percentage_of_completion.to_s
    number_of_characters = (percentage_of_completion * 2) / 10
    # puts("#{number_of_characters}")
    # percents = "[".bg_green.black
    test_string = '|'

    for index in 0...number_of_characters do
      test_string += '='.bg_green.black
    end

    for index in number_of_characters...20 do
      test_string += '='.bg_red.black
    end

    test_string += '|'

    while perc_string.length < 2
      perc_string = pad_string(perc_string)
    end

    return test_string.insert(test_string.length / 2, "[#{perc_string}%]")
  end

  def self.pad_string(string)
    return " " + string
  end

  # Simple function to convert a string to have a capital letter, E.G: "cooking"->"Cooking"
  def self.capitalize_string(string)
    return string[0].upcase + string[1...string.length]
  end

  # Function to take a string of numbers make it neat/readable: 10000000 -> 10,000,000
  def self.add_commas(add_commas_to_string) 
    comma_string = add_commas_to_string.to_s
    return comma_string.reverse.scan(/\d{3}|.+/).join(',').reverse
  end


end

# for index in 0..100 do
#   print("Test #{index}: \t")
#   test_colors = Prettifier.progress_bar(index)
#   puts(test_colors.to_s)
# end
