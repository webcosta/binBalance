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
        @Apikey = ""
        @SignatureKey = ""
        
        timestamp = DateTime.now.strftime('%Q')
        uri = URI(@api_endpoint)
        queryString = "timestamp=#{timestamp}"

        hmac = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @SignatureKey, queryString)        

        req = Net::HTTP::Get.new(uri+"?#{queryString}&signature=#{hmac}")
        req['X-MBX-APIKEY'] = "#{@Apikey}"

        res = Net::HTTP.start(uri.hostname, use_ssl: true) { |http| http.request(req) }
        
        raw_data = res.body
        parsed_response = JSON.parse(raw_data)  
        
        if RequestResult.any? 
            prev_timestamp = RequestResult.order("created_at").last["created_at"]
            last_timestamp = (prev_timestamp.to_f * 1000).to_i

            if parsed_response["updateTime"].to_i>last_timestamp.to_i
                puts "New entry, updated at: #{parsed_response["updateTime"]}" 
                newEntry = saveEntry(raw_data)

            else
                puts "No changes in portfolio"
            end
        else
            saveEntry(raw_data)
        end 

    end
    
    private
     
    def saveEntry(raw_data)
        return RequestResult.create(raw_data: raw_data)
    end
end

