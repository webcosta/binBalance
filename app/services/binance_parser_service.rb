class BinanceParserService
    

    def initialize(entry_id)
        @entry_id =  entry_id
    end

    def parse_data

        raw_data = RequestResult.where(id:@entry_id).select("raw_data").as_json
        raw_data_decoded = raw_data[0]["raw_data"]
        json_balances = JSON.parse(raw_data_decoded)
        balances = []
        balancesArr = json_balances["balances"] 
        balancesArr.each {|asset| 
            if asset["free"].to_f > 0
                balances.push({asset: asset["asset"], free: asset["free"]})
            end
        }
        
        updateEntry(balances, @entry_id) unless balances.empty?
        
    end

    private
    def updateEntry(parsed_data, entry_id)
        entry = RequestResult.find(entry_id)
        if entry.parsed_data.present?
        else
            entry.update(parsed_data: parsed_data)
            puts "Balances updated:"
            puts "#{parsed_data}"
        end
    end
end