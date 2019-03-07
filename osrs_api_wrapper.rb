# frozen_string_literal: true

require 'net/http'
require 'csv'
require 'json'

module OSRS_Api_Wrapper
  # Downloads, evaluates then returns API data (Grand Exchange/Hiscores)

  @hiscore_base_url = 'https://secure.runescape.com/m=hiscore_oldschool/index_lite.ws?player='
  @grandexchange_base_url = 'http://services.runescape.com/m=itemdb_oldschool/api/catalogue/detail.json?item='

  # Check the HTTP Response of an URL (2xx OK, anything else probably not ok)
  def self.is_http_response_valid?(url_to_check)
    url_response = Net::HTTP.get_response(URI(url_to_check)) # Request HTTP response from web page (Parsing URL through the URI class)
    if url_response.code[0] == '2' # Any HTTP Response that's 2xx is classed as HTTPOK/SUCCESS
      return true # Return 'true', because getting a valid response from that page was a success!
    else
      return false # Otherwise return 'false' because we can't be certain the request was a success
    end
  end

  def self.get_item_data(item_id) # Gets all API data associated with an item on the Grand Exchange
    item_id = item_id.to_s # Conversion from Integer to string as RuneScape's item id convention has always been integers.
    if is_http_response_valid?(@grandexchange_base_url + item_id) # If we get a successful response from this URL
      return download_item_data(@grandexchange_base_url + item_id) # Download and return the item data
    else
      return false # Otherwise return 'false' because we can't be certain the request was a success
    end
  end

  def self.get_item_price(item_id) # Gets the current price of an item from the Grand Exchange
    item_id = item_id.to_s # Conversion from Integer to string as RuneScape's item id convention has always been integers.
    if is_http_response_valid?(@grandexchange_base_url + item_id) # If we get a successful response from this URL
      item_data_hash = download_item_data(@grandexchange_base_url + item_id) # Download and return the item data into a hash
      item_price = item_data_hash['item']['current']['price'].to_s

      # Manipulating the item_price string so we can easily parse it as an Integer when we're done
      item_price.delete!(',') # ',' is used between numbers 1,000 and 9,999 it will generally be displayed

      if !item_price.include?('.') # If item_price doesn't include '.'
        item_price.gsub!('k', '000') # 'k' represents 1000's (42k = 42000), needs an extra 0 as it's a clean (42k, not 42.1k)
      else
        item_price.delete!('.') # '.' only returned in the number if it's above 10k and not clean (55.7k, not 55k)
        item_price.gsub!('k', '00') # 'k' represents 1000's (10.5k = 10500, 72.1k = 72100)
      end

      return item_price.to_i # Return the manipulated item_price string as an Integer
    else
      return false
    end
  end

  def self.get_hiscore_data(in_game_name) # Gets hiscore data associated with a player
    if is_http_response_valid?(@hiscore_base_url + in_game_name) # If we get a successful response from this URL
      download_hiscore_data(@hiscore_base_url + in_game_name) # Download and return the players data
    else
      false # otherwise return false
    end
  end

  def self.download_item_data(grand_exchange_item_url) # Downloads items Grand Exchange data
    json_item_data = Net::HTTP.get(URI(grand_exchange_item_url)) # Grab the data from the grand exchange based on item id
    item_data_hash = JSON.parse(json_item_data) # Parse the json data received from our request as a hash into our new variable

    item_data_hash # returns the hash
  end

  def self.download_hiscore_data(hiscore_url) # Download players hiscore data
    # Due to the dirty way you receive data from the hiscore API, I've manually had to map out the order of hiscore skill/minigame that the URL gives you and stored it in 'raw_hiscore_order', so then we can line those elements up as hash names
    raw_hiscore_order = %w[overall attack defence strength hitpoints ranged prayer magic cooking woodcutting fletching fishing firemaking crafting smithing mining herblore agility thieving slayer farming runecrafting hunter construction bounty_hunter bounty_hunter_rogues clue_scrolls_all clue_scrolls_easy clue_scrolls_medium clue_scrolls_hard clue_scrolls_elite clue_scrolls_master lms]
    raw_hiscore_data = "rank,level,experience\n" # Sets the 'raw_hiscore_data' up with pre-definied headers
    raw_hiscore_data += Net::HTTP.get(URI(hiscore_url)) # Grab the data from the hiscore_url
    hashed_hiscore_data = CSV.parse(raw_hiscore_data, headers: true) # parse our raw data into a variable with the headers flag/arguement set to true
    player_data = {} # Empty hash for storing our player data to return

    hashed_hiscore_data.each_with_index do |row, index| # Run through each line of the hiscore data we parsed as CSV
      row_data = row.to_hash # Convert the row data to a hash

      player_data[raw_hiscore_order[index]] = row_data # Create a new key in our hash
    end

    player_data # Return our hash of player_data
  end
end
