BitBayR
================

Overview
========

`BitBayR` is a simple R public API client to the BitBay crypto-currency exhange.

It consists of 6 functions: `bitbay_orderbook`, `bitbay_profit`, `bitbay_trades` `bitbay_trades_from_date`, `bitbay_aggregate` and `bitbay_ticker`

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

Installation
============

``` r
devtools::install_github("majkamichal/BitBayR")
```

Usage
=====

bitbay\_orderbook
-----------------

The function `bitbay_orderbook` downloads the actual order book. Its output consists of a list with two dataframes `bids` and `asks`. Each one contains three columns `Bid` or `Ask`, `Volume` and `Price`. The price is just `Bid` or `Ask` times the `Volume`.

``` r
library(BitBayR)

order_book <- bitbay_orderbook(coin = "BTC", currency = "EUR")
head(order_book$bids)
```

    ##       Bid     Volume       Price
    ## 1 6318.01 0.00789331    49.87001
    ## 2 6318.00 0.02236467   141.29999
    ## 3 6316.02 0.09272590   585.65864
    ## 4 6313.17 0.01343541    84.82003
    ## 5 6313.00 0.00165690    10.46001
    ## 6 6306.89 3.59057961 22645.39064

``` r
head(order_book$asks)
```

    ##       Ask     Volume     Price
    ## 1 6329.99 0.01320573 83.592139
    ## 2 6383.02 0.00065933  4.208517
    ## 3 6463.49 0.00369769 23.899982
    ## 4 6488.57 0.00894650 58.049992
    ## 5 6495.01 0.00402001 26.110005
    ## 6 6496.65 0.00275958 17.928025

bitbay\_profit
--------------

The function `bitbay_profit` performs a theoretical/virtual market order. That is, it theoretically sells some specific volume of a specific crypto currency for a specific currency. In the example below one Bitcoin is sold for EUR assuming a prior investment of 5000€ and transaction fees 0.3%.

``` r
bitbay_profit(coin = "BTC", amount = 1, currency = "EUR", investment = 5000, fee = 0.003)
```

    ## $transactions
    ##       bid     amount      price         fee
    ## 1 6318.01 0.00789331   49.87001  0.14961003
    ## 2 6318.00 0.02236467  141.29999  0.42389996
    ## 3 6316.02 0.09272590  585.65864  1.75697592
    ## 4 6313.17 0.01343541   84.82003  0.25446008
    ## 5 6313.00 0.00165690   10.46001  0.03138003
    ## 6 6306.89 0.86192381 5436.05866 16.30817597
    ## 
    ## $summary
    ##                        Value
    ## Amount               1.00000
    ## Amount sold          1.00000
    ## Money (with fees) 6289.24283
    ## Investment        5000.00000
    ## Fee (in %)           0.00300
    ## Profit (in %)       25.78486
    ## 
    ## attr(,"pair")
    ## [1] "BTC/EUR"
    ## attr(,"download_time")
    ## [1] "2017-11-05 21:05:10 CET"

bitbay\_trades and bitbay\_trades\_from\_date
---------------------------------------------

The function `bitbay_trades` can be used to download last `n` transactions by specifying the parameter `last_trades`. In order to download all historic transactions the parameter `last_trades` can be set to `"all"`.

``` r
last_50_trades <- bitbay_trades(coin = "BTC", currency = "EUR", last_trades = 50)
tail(last_50_trades)
```

    ##                   Date   Price Order     Volume   TID
    ## 45 2017-11-05 20:53:51 6380.00  sell 0.00400934 51045
    ## 46 2017-11-05 20:53:54 6350.00  sell 0.00236220 51046
    ## 47 2017-11-05 20:53:55 6330.00  sell 0.00759568 51047
    ## 48 2017-11-05 20:53:56 6330.00  sell 0.02399990 51048
    ## 49 2017-11-05 20:54:00 6316.02  sell 0.00271577 51049
    ## 50 2017-11-05 20:57:11 6316.02  sell 0.00455833 51050

The function `bitbay_trades_from_date` does the same task, however, it downloads all transactions occurred after a specific date. In the example below, all trades within last 3 hours.

``` r
last_trades_3h <- bitbay_trades_from_date(coin = "BTC", currency = "EUR", 
                                           date = Sys.time() - 60 * 60 * 3)
```

``` r
tail(last_trades_3h)
```

    ##                   Date   Price Order     Volume   TID
    ## 80 2017-11-05 20:53:51 6380.00  sell 0.00400934 51045
    ## 81 2017-11-05 20:53:54 6350.00  sell 0.00236220 51046
    ## 82 2017-11-05 20:53:55 6330.00  sell 0.00759568 51047
    ## 83 2017-11-05 20:53:56 6330.00  sell 0.02399990 51048
    ## 84 2017-11-05 20:54:00 6316.02  sell 0.00271577 51049
    ## 85 2017-11-05 20:57:11 6316.02  sell 0.00455833 51050

bitbay\_aggregate
-----------------

The function `bitbay_aggregate` takes downloaded transactions as input as well as the time interval length (in seconds) and returns a time-series object of class `xts` with aggregated transactions.

``` r
aggr_data_15min <- bitbay_aggregate(last_50_trades, aggr_time = 15 * 60)
tail(aggr_data_15min)
```

    ##                     BTC_EUR.Open BTC_EUR.High BTC_EUR.Low BTC_EUR.Close
    ## 2017-11-05 19:30:00      6521.30       6521.3     6521.30       6521.30
    ## 2017-11-05 19:45:00      6521.30       6521.3     6521.30       6521.30
    ## 2017-11-05 20:00:00      6521.30       6521.3     6521.30       6521.30
    ## 2017-11-05 20:15:00      6521.30       6521.3     6521.30       6521.30
    ## 2017-11-05 20:30:00      6521.30       6521.3     6521.30       6521.30
    ## 2017-11-05 20:45:00      6383.02       6386.0     6316.02       6316.02
    ##                     BTC_EUR.Mean BTC_EUR.Median BTC_EUR.Volume_total
    ## 2017-11-05 19:30:00     6521.300        6521.30           0.00214068
    ## 2017-11-05 19:45:00     6521.300        6521.30           0.00000000
    ## 2017-11-05 20:00:00     6521.300        6521.30           0.00000000
    ## 2017-11-05 20:15:00     6521.300        6521.30           0.00000000
    ## 2017-11-05 20:30:00     6521.300        6521.30           0.00000000
    ## 2017-11-05 20:45:00     6376.679        6383.02           0.32928077
    ##                     BTC_EUR.Volume_buy BTC_EUR.Volume_sell BTC_EUR.Count
    ## 2017-11-05 19:30:00                  0          0.00214068             1
    ## 2017-11-05 19:45:00                  0          0.00000000             0
    ## 2017-11-05 20:00:00                  0          0.00000000             0
    ## 2017-11-05 20:15:00                  0          0.00000000             0
    ## 2017-11-05 20:30:00                  0          0.00000000             0
    ## 2017-11-05 20:45:00                  0          0.32928077            44

bitbay\_ticker
--------------

The function `bitbay_ticker` can be used to download a ticker for a specific pair.

``` r
ticker_BTC_USD <- bitbay_ticker(coin = "BTC", currency = "USD")
ticker_BTC_USD
```

    ##   Statistic      Value
    ## 1       max 7418.99000
    ## 2       min 7150.01000
    ## 3      last 7418.98000
    ## 4       bid 7315.01000
    ## 5       ask 7418.98000
    ## 6      vwap 7418.98000
    ## 7   average 7418.98000
    ## 8    volume   19.19197
