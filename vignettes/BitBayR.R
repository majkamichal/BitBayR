## ------------------------------------------------------------------------
library(BitBayR)

order_book <- bitbay_orderbook(coin = "BTC", currency = "EUR")
head(order_book$bids)
head(order_book$asks)


## ------------------------------------------------------------------------
bitbay_profit(coin = "BTC", amount = 1, currency = "EUR", investment = 5000, fee = 0.003)

## ------------------------------------------------------------------------
last_50_trades <- bitbay_trades(coin = "BTC", currency = "EUR", last_trades = 50)
tail(last_50_trades)


## ------------------------------------------------------------------------
last_trades_3h <- bitbay_trades_from_date(coin = "BTC", currency = "EUR", 
                                           date = Sys.time() - 60 * 60 * 3)
tail(last_trades_3h)


## ------------------------------------------------------------------------
aggr_data_15min <- bitbay_aggregate(last_50_trades, aggr_time = 15 * 60)
tail(aggr_data_15min)

## ------------------------------------------------------------------------
ticker_BTC_USD <- bitbay_ticker(coin = "BTC", currency = "USD")
ticker_BTC_USD

