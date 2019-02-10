class RequestResult < ApplicationRecord

    after_commit :launchParserWorker, on: :create

    def launchParserWorker
        puts "Entry saved with id:#{id}"
        puts "updating balances..."
        BinanceParserWorker.perform_async(id)
    end
end
