# README
App to extract account balances from Binance API every 1 hour

1. Boot redis on standard port (6379)
```
redis-server
```
2. Boot sidekiq to handle cron queue 
```
bundle exec sidekiq
```