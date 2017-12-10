BitBay
================

Overview
========

`BitBayR` is a simple R public API client to the BitBay crypto-currency exhange.

It consists of 6 functions: `bitbay_orderbook`, `bitbay_profit`, `bitbay_trades` `bitbay_trades_from_date`, `bitbay_aggregate` and `bitbay_ticker`.

Available pairs: all combinations of

-   `BTC` (Bitcoin)

-   `ETC` (Ethereum)

-   `LSK` (Lisk)

-   `LTC` (Litecoin)

-   `GAME` (Game)

-   `DASH` (Dash)

-   `BCC` (Bitcoin cash)

and

-   `PLN`

-   `USD`

-   `EUR`

-   `BTC`

They have to be separated by `/`.

Usage
=====

bitbay\_orderbook
-----------------

The function `bitbay_orderbook` downloads the actual order book. Its output consists of a list with two dataframes `bids` and `asks`. Each one contains three columns `Bid` or `Ask`, `Volume` and `Price`. The price is just `Bid` or `Ask` times the `Volume`.

``` r
library(BitBayR)

order_book <- bitbay_orderbook(pair = "BTC/EUR")
head(order_book$bids)
```

    ##        Bid     Volume     Price
    ## 1 12262.28 0.00163102  20.00002
    ## 2 12250.02 0.01993459 244.19913
    ## 3 12001.04 0.04166306 500.00005
    ## 4 12001.03 0.01241560 148.99999
    ## 5 12000.01 0.00833400 100.00808
    ## 6 12000.00 0.03333333 399.99996

``` r
head(order_book$asks)
```

    ##        Ask     Volume     Price
    ## 1 12520.03 0.05000000 626.00150
    ## 2 12520.04 0.01877710 235.09004
    ## 3 13125.99 0.05842028 766.82401
    ## 4 13132.76 0.00235502  30.92791
    ## 5 13160.28 0.00143310  18.86000
    ## 6 13200.00 0.00300000  39.60000

bitbay\_profit
--------------

The function `bitbay_profit` performs a theoretical/virtual market order. That is, it theoretically sells some specific volume of a specific crypto currency for a specific currency. In the example below one Bitcoin is sold for EUR assuming a prior investment of 5000€ and transaction fees 0.3%.

``` r
bitbay_profit(pair = "BTC/EUR", amount = 1, investment = 5000, fee = 0.003)
```

    ## $transactions
    ##         bid     amount      price         fee
    ## 1  12262.28 0.00163102   20.00002  0.06000007
    ## 2  12250.02 0.01993459  244.19913  0.73259738
    ## 3  12001.04 0.04166306  500.00005  1.50000015
    ## 4  12001.03 0.01241560  148.99999  0.44699996
    ## 5  12000.01 0.00833400  100.00808  0.30002425
    ## 6  12000.00 0.03333333  399.99996  1.19999988
    ## 7  11999.99 0.03339753  400.77003  1.20231008
    ## 8  11800.00 0.25303051 2985.76002  8.95728005
    ## 9  11600.00 0.01206897  140.00005  0.42000016
    ## 10 11580.00 0.00286097   33.13003  0.09939010
    ## 11 11500.00 0.08217304  944.98996  2.83496988
    ## 12 11201.00 0.30000000 3360.30000 10.08090000
    ## 13 11200.00 0.15383214 1722.91997  5.16875990
    ## 14 11131.00 0.04532524  504.51525  1.51354574
    ## 
    ## $summary
    ##            Amount       Amount sold Money (with fees)        Investment 
    ##            1.0000            1.0000        11471.0758         5000.0000 
    ##        Fee (in %)     Profit (in %) 
    ##            0.0030          129.4215 
    ## 
    ## attr(,"pair")
    ## [1] "BTC/EUR"
    ## attr(,"download_time")
    ## [1] "2017-12-10 23:20:20 CET"

bitbay\_trades and bitbay\_trades\_from\_date
---------------------------------------------

The function `bitbay_trades` can be used to download last `n` transactions by specifying the parameter `last_trades`. In order to download all historic transactions the parameter `last_trades` can be set to `"all"`.

``` r
last_50_trades <- bitbay_trades(pair = "BTC/EUR", last_trades = 50)
tail(last_50_trades)
```

    ##                   Date Price Order     Volume   TID
    ## 45 2017-12-10 23:06:16 12520   buy 0.01877710 71100
    ## 46 2017-12-10 23:06:19 12520   buy 0.00081149 71101
    ## 47 2017-12-10 23:06:20 12520   buy 0.00043210 71102
    ## 48 2017-12-10 23:06:30 12520   buy 0.00039616 71103
    ## 49 2017-12-10 23:06:42 12520   buy 0.00039936 71104
    ## 50 2017-12-10 23:11:16 12301  sell 0.00317172 71105

The function `bitbay_trades_from_date` does the same task, however, it downloads all transactions occurred after a specific date. In the example below, all trades within last 3 hours.

``` r
last_trades_3h <- bitbay_trades_from_date(pair = "BTC/EUR", date = Sys.time() - 60 * 60 * 3)
```

``` r
tail(last_trades_3h)
```

    ##                    Date Price Order     Volume   TID
    ## 127 2017-12-10 23:06:16 12520   buy 0.01877710 71100
    ## 128 2017-12-10 23:06:19 12520   buy 0.00081149 71101
    ## 129 2017-12-10 23:06:20 12520   buy 0.00043210 71102
    ## 130 2017-12-10 23:06:30 12520   buy 0.00039616 71103
    ## 131 2017-12-10 23:06:42 12520   buy 0.00039936 71104
    ## 132 2017-12-10 23:11:16 12301  sell 0.00317172 71105

bitbay\_aggregate
-----------------

The function `bitbay_aggregate` takes downloaded transactions as input as well as the time interval length (in seconds) and returns a time-series object of class `xts` with aggregated transactions.

``` r
aggr_data_15min <- bitbay_aggregate(last_50_trades, aggr_time = 15 * 60)
tail(aggr_data_15min)
```

    ##                     BTC_EUR.Open BTC_EUR.High BTC_EUR.Low BTC_EUR.Close
    ## 2017-12-10 22:15:00     12668.20     12668.20    12500.00      12500.00
    ## 2017-12-10 22:30:00     12750.00     12750.00    12750.00      12750.00
    ## 2017-12-10 22:45:00     12750.00     12750.00    12520.03      12520.03
    ## 2017-12-10 23:00:00     12520.03     12520.04    12250.02      12301.00
    ##                     BTC_EUR.Mean BTC_EUR.Median BTC_EUR.Volume_total
    ## 2017-12-10 22:15:00     12614.79       12668.20           0.08632498
    ## 2017-12-10 22:30:00     12750.00       12750.00           0.02038485
    ## 2017-12-10 22:45:00     12566.02       12520.03           0.01678881
    ## 2017-12-10 23:00:00     12442.51       12500.00           0.18674926
    ##                     BTC_EUR.Volume_buy BTC_EUR.Volume_sell BTC_EUR.Count
    ## 2017-12-10 22:15:00         0.00007276          0.08625222            15
    ## 2017-12-10 22:30:00         0.02038485          0.00000000             4
    ## 2017-12-10 22:45:00         0.01678881          0.00000000             5
    ## 2017-12-10 23:00:00         0.05764444          0.12910482            26

bitbay\_ticker
--------------

The function `bitbay_ticker` can be used to download a ticker for a specific pair.

``` r
ticker_BTC_USD <- bitbay_ticker(pair = "BTC/EUR")
ticker_BTC_USD
```

    ##         max         min        last         bid         ask        vwap 
    ## 13129.00000 11011.03000 12301.00000 12262.28000 12520.04000 12301.00000 
    ##     average      volume 
    ## 12301.00000    10.69074 
    ## attr(,"pair")
    ## [1] "BTC/EUR"
    ## attr(,"download_time")
    ## [1] "2017-12-10 23:20:23 CET"
