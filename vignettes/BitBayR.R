## ------------------------------------------------------------------------
library(BitBayR)

order_book <- bitbay_orderbook(pair = "BTC/EUR")
head(order_book$bids)
head(order_book$asks)


## ------------------------------------------------------------------------
bitbay_profit(pair = "BTC/EUR", amount = 1, investment = 5000, fee = 0.003)

## ------------------------------------------------------------------------
last_50_trades <- bitbay_trades(pair = "BTC/EUR", last_trades = 50)
tail(last_50_trades)


## ------------------------------------------------------------------------
last_trades_3h <- bitbay_trades_from_date(pair = "BTC/EUR", date = Sys.time() - 60 * 60 * 3)
tail(last_trades_3h)


## ------------------------------------------------------------------------
aggr_data_15min <- bitbay_aggregate(last_50_trades, aggr_time = 15 * 60)
tail(aggr_data_15min)

## ------------------------------------------------------------------------
ticker_BTC_USD <- bitbay_ticker(pair = "BTC/EUR")
ticker_BTC_USD

