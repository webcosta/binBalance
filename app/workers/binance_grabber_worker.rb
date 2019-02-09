class BinanceGrabberWorker
  include Sidekiq::Worker

  def perform(*args)
    # Do something
    @API_ENDPOINT = 'https://api.binance.com/api/v3/account'
    BinanceGrabberService.new({api_endpoint: @API_ENDPOINT}).fetch_data
    BinanceParserWorker.perform_async
  end
end
