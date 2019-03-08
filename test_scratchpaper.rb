# 100 - 5 * (2 - 1) + 9 % 3
# 100 - 5 * 1 + 9 % 3
# 100 - 5 * 1 + 0
# 100 - 5 + 0
# 100 - 5
# Answer = 95

# my_empty_string = ""

# my_number = 7
# my_number_as_string = my_number.to_s

# def celsius_to_fahrenheit temperature_in_celsius
#     # fahrenheit = temperature_in_celsius * (9 / 5) + 32 \ INCORRECT FORMULA
#     fahrenheit = (temperature_in_celsius * 9 / 5) + 32
#     return fahrenheit
# end

# celsius = 30
# fahrenheit = celsius_to_fahrenheit(celsius)

# puts("#{celsius} degrees celsius is #{celsius_to_fahrenheit(celsius)} fahrenheit")

# def make_purchase item_price, cash_amount
#     if cash_amount < item_price
#         puts "You don't have enough to purchase this"
#         return cash_amount
#     else
#         change = cash_amount - item_price
#         return change
#     end
# end

# arr = [1, 2, 3, 4, 5, 6, 7]

# def print_array array_to_print
#   array_to_print.each_with_index do |item, index|
#     puts "Item #{index + 1}: #{item}"
#   end
# end

# print_array arr

# my_age = 10
# puts my_age < 18 ? "You are not allowed to vote" : "You are allowed to vote"
# my_age = 15
# puts my_age < 18 ? "You are not allowed to vote" : "You are allowed to vote"
# my_age = 20
# puts my_age < 18 ? "You are not allowed to vote" : "You are allowed to vote"

# arr = [12, 4, 14, 6, 7, 9, 11, 23, 33]

# def find_position array_to_search, item_to_find
#   array_to_search.each_with_index do |item, index|
#     if (item == item_to_find)
#       return index
#     end
#   end

#   return nil
# end

# find_position(arr, 9)

# You have access to two variables: raining (Boolean) and temperature (Integer). Write some code to check these values. If it's raining and less than 20 degrees warn the user "It's wet and cold". Otherwise tell them "It’s warm and it’s not raining" 

# raining = false
# temperature = 0

# def get_forecast is_raining, temperature
#   it_feels_like = "warm"
#   moist_or_dry = "dry"

#   if temperature < 20
#     it_feels_like = "cold"
#   end
#   if is_raining
#     moist_or_dry = "wet"
#   end

#   puts "It's #{it_feels_like} and it's #{moist_or_dry}"
# end

# get_forecast true, 10
# get_forecast false, 10
# get_forecast true, 15
# get_forecast false, 15
# get_forecast true, 20
# get_forecast false, 20
# get_forecast true, 25
# get_forecast false, 25


# Write a program to Implement a simple function (i.e. method) that takes a single String parameter and prints out the String in reverse

# def print_reverse_string string_to_reverse
#   print string_to_reverse.reverse
# end

# print_reverse_string "The quick brown dog jumped over the lazy dog"

# require 'colorize'

# puts "This string is in blue!".colorize(:color => :blue)
# puts "This string is in red!".colorize(:color => :red)
# puts "This string is in yellow!".colorize(:color => :yellow)
# puts "The background color of this string is green!".colorize(:color => :black, :background => :green)
# puts "The background color of this string is magenta!".colorize(:color => :black, :background => :magenta)
# puts "The background color of this string is cyan!".colorize(:color => :black, :background => :cyan)



# Once upon a time there was a series of 5* books about a very English hero called Harry. Children all over the world thought he was fantastic, and, of course, so did the publisher. So in a gesture of immense generosity to mankind, (and to increase sales) they set up the following pricing model to take advantage of Harry’s magical powers.

#     One copy of any of the five books costs 8 EUR.
#     If, however, you buy two different books from the series, you get a 5% discount on those two books.
#     If you buy 3 different books, you get a 10% discount.
#     With 4 different books, you get a 20% discount.
#     If you go the whole hog, and buy all 5, you get a huge 25% discount.

# Note that if you buy, say, four books, of which 3 are different titles, you get a 10% discount on the 3 that form part of a set, but the fourth book still costs 8 EUR.

# Potter mania is sweeping the country and parents of teenagers everywhere are queueing up with shopping baskets overflowing with Potter books.

# Your mission is to write a piece of code to calculate the price of any conceivable shopping basket, giving as big a discount as possible.

# An example case,

# For example, how much does this basket of books cost?
# • 2 copies of the first book
# • 2 copies of the second book
# • 2 copies of the third book
# • 1 copy of the fourth book
# • 1 copy of the fifth book

# Answer:
# (4 * 8) - 20% discount [1st book, 2nd book, 3rd book, 4th book] + (4 * 8) - 20% discount [1st book, 2nd book, 3rd book, 5th book]
# = 25.60 + 25.60
# = 51.20

# Note *: Yes we know there are more than 5 books :)


# book_cost = 8.00
# books = ["potter 1", "potter 2", "potter 3", "potter 4", "potter 5"]

# def purchase_books(array_of_books)
#   unique_books = []

#   array_of_books.each do |book|
#     if (!unique_books.includ?(book)) 


# end