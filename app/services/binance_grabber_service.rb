require "net/http"
require "uri"
require "date"
require "openssl"
require "base64"

class BinanceGrabberService
    
    def initialize(params)
        @api_endpoint = params[:api_endpoint]
    end

    def fetch_data
        @api_key = ENV["API_KEY"]
        @signature_key = ENV["SIGNATURE_KEY"]

        
        timestamp = DateTime.now.strftime('%Q')
        uri = URI(@api_endpoint)
        query_string = "timestamp=#{timestamp}"

        hmac = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @signature_key, query_string)        

        req = Net::HTTP::Get.new(uri+"?#{query_string}&signature=#{hmac}")
        req['X-MBX-APIKEY'] = @api_key

        res = Net::HTTP.start(uri.hostname, use_ssl: true) { |http| http.request(req) }
        
        raw_data = res.body
        parsed_response = JSON.parse(raw_data)  
        
        if RequestResult.any? 
            
            # Decode Binance data
            prev_timestamp = RequestResult.select("raw_data").last.as_json
            prev_timestamp_decoded = prev_timestamp["raw_data"]
            prev_timestamp_json = JSON.parse(prev_timestamp_decoded)
            last_timestamp = prev_timestamp_json["updateTime"]

            if parsed_response["updateTime"].to_i>last_timestamp.to_i
                puts "New entry, updated at: #{parsed_response["updateTime"]}" 
                saveEntry(raw_data)
            else
                puts "No changes in portfolio"
            end
        else
            saveEntry(raw_data)
        end 

    end
    
    private
     
    def saveEntry(raw_data)
        RequestResult.create!(raw_data: raw_data)
    end
end

