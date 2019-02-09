class BinanceParserWorker
  include Sidekiq::Worker

  def perform
    # Do something
    BinanceParserService.new().parse_data
  end
end
