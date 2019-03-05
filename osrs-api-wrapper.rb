require "net/http"
require "csv"

class OSRS_Api_Wrapper
  # Downloads, evaluates then returns API data (Grand Exchange/High-score)

  def initialize()
    @osrs_hs_url = "https://secure.runescape.com/m=hiscore_oldschool/index_lite.ws?player="
  end

  def username_exists?(in_game_name)
    my_response = Net::HTTP.get_response(URI(@osrs_hs_url + in_game_name))

    case my_response.code.to_i
    when 200..299 # Range of HTTP OK reponses!
      download_hiscore_data(@osrs_hs_url + in_game_name)
    else
      return false
    end
  end

  def download_hiscore_data(hiscore_url)
    raw_hiscore_order = ["overall", "attack", "defence", "strength", "hitpoints", "ranged", "prayer", "magic", "cooking", "woodcutting", "fletching", "fishing", "firemaking", "crafting", "smithing", "mining", "herblore", "agility", "thieving", "slayer", "farming", "runecrafting", "hunter", "construction", "bounty_hunter", "bounty_hunter_rogues", "clue_scrolls_all", "clue_scrolls_easy", "clue_scrolls_medium", "clue_scrolls_hard", "clue_scrolls_elite", "clue_scrolls_master", "lms"]
    raw_hiscore_data = "rank,level,experience\n"
    raw_hiscore_data += Net::HTTP.get(URI(hiscore_url)) # => String
    hashed_hiscore_data = CSV.parse(raw_hiscore_data, :headers => true)
    player_data = {}

    # puts("========== HISCORE DATA RESPONSE ==========")

    hashed_hiscore_data.each_with_index do |row, index|
      row_data = row.to_hash

      player_data[raw_hiscore_order[index]] = row_data
    end

    return player_data

    # player_data.each do |key, value|
    #     puts("-> #{key}\n  -> #{value}\n")
    # end

    # puts("========== HISCORE DATA RESPONSE ==========")

    # puts("========== REFERENCING DATA ==========")
    # wc_level = player_data['woodcutting']['level']
    # dickbutt = player_data['mining']['experience']

    # puts("#{ign}'s Woodcutting level is: #{wc_level}")
    # puts("#{ign}'s Mining experience is: #{mining_xp}")

    # puts("========== REFERENCING DATA ==========")
  end
end

# usage:
#   osrs_calc = OSRS_Api_Wrapper.new()
#   brad_level_data = osrs_calc.username_exists?("revolvers")
#   user_doesn't_exist = osrs_calc.username_exists?("dkfhnsrlkngesklrgmelkrg")
#   puts("Skill data for Brad: #{brad_level_data}")
#   puts("This should be false: #{no_level_data}")
