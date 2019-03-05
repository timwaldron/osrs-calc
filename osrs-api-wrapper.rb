require 'net/http'

class OSRS_Api_Wrapper
    # Downloads, evaluates then returns API data (Grand Exchange/High-score)

    def initialize()
        @osrs_base_url = "https://secure.runescape.com/m=hiscore_oldschool/index_lite.ws?player="
    end

    def download_hiscore_data()
        print("Username: ")
        ign = gets().strip()

        hiscore_data = Net::HTTP.get(URI(@osrs_base_url + ign)) # => String

        puts("========== HISCORE DATA RESPONSE ==========")
        puts("#{hiscore_data}")
        puts("========== HISCORE DATA RESPONSE ==========")
    end
end

my_runescape_account = OSRS_Api_Wrapper.new()
my_runescape_account.download_hiscore_data()