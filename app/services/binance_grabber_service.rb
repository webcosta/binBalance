class BinanceGrabberService
    

    def initialize(params)
        @api_endpoint = params[:api_endpoint]
    end

    def fetch_data
        test_message
    end

    private
    def test_message
        puts "Grabber is OK:------------------------------------------------+"
        puts "requested endpoint: #{@api_endpoint}"
    end
end