class BinanceParserWorker
  include Sidekiq::Worker

  def perform(entry_id)
    if entry_id
      @entry_id = entry_id
      BinanceParserService.new(@entry_id).parse_data
    end

  end
end
