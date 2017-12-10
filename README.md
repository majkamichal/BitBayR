BitBay
================

Overview
========

`BitBayR` is a simple R public API client to the BitBay crypto-currency exhange.

It consists of 6 functions: `bitbay_orderbook`, `bitbay_profit`, `bitbay_trades` `bitbay_trades_from_date`, `bitbay_aggregate` and `bitbay_ticker`.

Available crypto currencies:

-   `BTC` (Bitcoin)

-   `ETC` (Ethereum)

-   `LSK` (Lisk)

-   `LTC` (Litecoin)

-   `GAME` (Game)

-   `DASH` (Dash)

-   `BCC` (Bitcoin cash)

Available currencies:

-   `PLN`

-   `USD`

-   `EUR`

Usage
=====

- bitbay\_orderbook
-------------------

The function `bitbay_orderbook` downloads the actual order book. Its output consists of a list with two dataframes `bids` and `asks`. Each one contains three columns `Bid` or `Ask`, `Volume` and `Price`. The price is just `Bid` or `Ask` times the `Volume`.

``` r
library(BitBayR)

order_book <- bitbay_orderbook(coin = "BTC", currency = "EUR")
head(order_book$bids)
```

    ##        Bid     Volume       Price
    ## 1 12001.53 0.16000000 1920.244800
    ## 2 12001.52 0.01000000  120.015200
    ## 3 12001.02 0.04166313  500.000056
    ## 4 12001.00 0.00040247    4.830042
    ## 5 12000.00 0.02000000  240.000000
    ## 6 11999.01 0.41670104 4999.999946

``` r
head(order_book$asks)
```

    ##        Ask     Volume      Price
    ## 1 12988.92 0.05000000  649.44600
    ## 2 12989.99 0.00329245   42.76889
    ## 3 12995.99 0.00229410   29.81410
    ## 4 12999.98 0.10000000 1299.99800
    ## 5 13000.00 0.34560125 4492.81625
    ## 6 13051.34 0.00316511   41.30893

- bitbay\_profit
----------------

The function `bitbay_profit` performs a theoretical/virtual market order. That is, it theoretically sells some specific volume of a specific crypto currency for a specific currency. In the example below one Bitcoin is sold for EUR assuming a prior investment of 5000€ and transaction fees 0.3%.

``` r
bitbay_profit(coin = "BTC", amount = 1, currency = "EUR", investment = 5000, fee = 0.003)
```

    ## $transactions
    ##         bid     amount       price         fee
    ## 1  12001.53 0.16000000 1920.244800  5.76073440
    ## 2  12001.52 0.01000000  120.015200  0.36004560
    ## 3  12001.02 0.04166313  500.000056  1.50000017
    ## 4  12001.00 0.00040247    4.830042  0.01449013
    ## 5  12000.00 0.02000000  240.000000  0.72000000
    ## 6  11999.01 0.41670104 4999.999946 14.99999984
    ## 7  11800.00 0.21109746 2490.950028  7.47285008
    ## 8  11600.00 0.01206897  140.000052  0.42000016
    ## 9  11500.00 0.03484957  400.770055  1.20231017
    ## 10 11400.00 0.04340439  494.810046  1.48443014
    ## 11 11131.00 0.00637319   70.939978  0.21281993
    ## 12 11129.00 0.04343978  483.441312  1.45032393
    ## 
    ## $summary
    ##            Amount       Amount sold Money (with fees)        Investment 
    ##            1.0000            1.0000        11830.4035         5000.0000 
    ##        Fee (in %)     Profit (in %) 
    ##            0.0030          136.6081 
    ## 
    ## attr(,"pair")
    ## [1] "BTC/EUR"
    ## attr(,"download_time")
    ## [1] "2017-12-10 16:09:41 CET"

- bitbay\_trades and bitbay\_trades\_from\_date
-----------------------------------------------

The function `bitbay_trades` can be used to download last `n` transactions by specifying the parameter `last_trades`. In order to download all historic transactions the parameter `last_trades` can be set to `"all"`.

``` r
last_50_trades <- bitbay_trades(coin = "BTC", currency = "EUR", last_trades = 50)
tail(last_50_trades)
```

    ##                   Date    Price Order     Volume   TID
    ## 45 2017-12-10 16:02:19 12980.00   buy 0.00003082 70885
    ## 46 2017-12-10 16:04:09 12985.88   buy 0.01708006 70886
    ## 47 2017-12-10 16:04:09 12980.00   buy 0.00140232 70887
    ## 48 2017-12-10 16:07:20 12985.95   buy 0.00316512 70888
    ## 49 2017-12-10 16:07:20 12980.00   buy 0.00003073 70889
    ## 50 2017-12-10 16:07:20 12986.00   buy 0.05358533 70890

The function `bitbay_trades_from_date` does the same task, however, it downloads all transactions occurred after a specific date. In the example below, all trades within last 3 hours.

``` r
last_trades_3h <- bitbay_trades_from_date(coin = "BTC", currency = "EUR", 
                                           date = Sys.time() - 60 * 60 * 3)
```

``` r
tail(last_trades_3h)
```

    ##                    Date    Price Order     Volume   TID
    ## 108 2017-12-10 16:02:19 12980.00   buy 0.00003082 70885
    ## 109 2017-12-10 16:04:09 12985.88   buy 0.01708006 70886
    ## 110 2017-12-10 16:04:09 12980.00   buy 0.00140232 70887
    ## 111 2017-12-10 16:07:20 12985.95   buy 0.00316512 70888
    ## 112 2017-12-10 16:07:20 12980.00   buy 0.00003073 70889
    ## 113 2017-12-10 16:07:20 12986.00   buy 0.05358533 70890

- bitbay\_aggregate
-------------------

The function `bitbay_aggregate` takes downloaded transactions as input as well as the time interval length (in seconds) and returns a time-series object of class `xts` with aggregated transactions.

``` r
aggr_data_15min <- bitbay_aggregate(last_50_trades, aggr_time = 15 * 60)
tail(aggr_data_15min)
```

    ##                     BTC_EUR.Open BTC_EUR.High BTC_EUR.Low BTC_EUR.Close
    ## 2017-12-10 15:00:00     12400.00     12510.05    12400.00      12510.05
    ## 2017-12-10 15:15:00     12511.04     12990.00    12511.04      12720.10
    ## 2017-12-10 15:30:00     12752.09     12990.00    12750.04      12750.04
    ## 2017-12-10 15:45:00     12750.04     12750.04    12750.04      12750.04
    ## 2017-12-10 16:00:00     12309.01     12986.00    12309.01      12986.00
    ##                     BTC_EUR.Mean BTC_EUR.Median BTC_EUR.Volume_total
    ## 2017-12-10 15:00:00     12496.86       12502.01           0.57941789
    ## 2017-12-10 15:15:00     12814.01       12861.53           0.43259673
    ## 2017-12-10 15:30:00     12854.42       12859.51           1.02659126
    ## 2017-12-10 15:45:00     12854.42       12859.51           0.00000000
    ## 2017-12-10 16:00:00     12886.69       12980.00           0.07789004
    ##                     BTC_EUR.Volume_buy BTC_EUR.Volume_sell BTC_EUR.Count
    ## 2017-12-10 15:00:00         0.11041206          0.46900583            15
    ## 2017-12-10 15:15:00         0.43025645          0.00234028            14
    ## 2017-12-10 15:30:00         0.23000000          0.79659126            14
    ## 2017-12-10 15:45:00         0.00000000          0.00000000             0
    ## 2017-12-10 16:00:00         0.07789004          0.00000000             7

- bitbay\_ticker
----------------

The function `bitbay_ticker` can be used to download a ticker for a specific pair.

``` r
ticker_BTC_USD <- bitbay_ticker(coin = "BTC", currency = "USD")
ticker_BTC_USD
```

    ##   Statistic       Value
    ## 1       max 15777.00000
    ## 2       min 13005.00000
    ## 3      last 14803.00000
    ## 4       bid 14802.01000
    ## 5       ask 15090.00000
    ## 6      vwap 14803.00000
    ## 7   average 14803.00000
    ## 8    volume    14.20859
