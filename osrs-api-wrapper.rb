require 'net/http'
require 'csv'

class OSRS_Api_Wrapper
    # Downloads, evaluates then returns API data (Grand Exchange/High-score)

    def initialize()
        # @ign = nil
        @osrs_base_url = "https://secure.runescape.com/m=hiscore_oldschool/index_lite.ws?player="
    end

    def download_hiscore_data()
        print("Username: ")
        ign = gets().strip()

        raw_hiscore_order = ["overall", "attack", "defence", "strength", "hitpoints", "ranged", "prayer", "magic", "cooking", "woodcutting", "fletching", "fishing", "firemaking", "crafting", "smithing", "mining", "herblore", "agility", "thieving", "slayer", "farming", "runecrafting", "hunter", "construction", "bounty_hunter", "bounty_hunter_rogues", "clue_scrolls_all", "clue_scrolls_easy", "clue_scrolls_medium", "clue_scrolls_hard", "clue_scrolls_elite", "clue_scrolls_master", "lms"]
        raw_hiscore_data = "rank,level,experience\n"
        raw_hiscore_data += Net::HTTP.get(URI(@osrs_base_url + ign)) # => String
        hashed_hiscore_data = CSV.parse(raw_hiscore_data, :headers => true)
        hash_test = {}
        puts("========== HISCORE DATA RESPONSE ==========")

        hashed_hiscore_data.each_with_index do |row, index|
            row_data = row.to_hash

            hash_test[raw_hiscore_order[index]] = row_data
        end

        hash_test.each do |key, value|
            puts("#{key}:\t\t#{value}")
        end

        puts("========== HISCORE DATA RESPONSE ==========")
    end
end

my_runescape_account = OSRS_Api_Wrapper.new()
my_runescape_account.download_hiscore_data()