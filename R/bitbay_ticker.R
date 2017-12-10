#' Download ticker from the BitBay crypto-currency exhange
#'
#' This function can be used to download the ticker from BitBay market
#' through the public API.
#'
#' @param pair a character string with a pair.
#' Available pairs: combinations of "BTC", "ETC", "LSK", "LTC", "GAME" "DASH" "BCC" and "PLN", "EUR", "USD", "BTC". They have to be separated by "/".
#'
#' @return A data frame with two columns \code{Statistic} and \code{Value},
#' in which rows correspond to the following statistics:
#'
#'   \code{max} is the rate of transaction, which had highest value
#'
#'   \code{min} is the rate of transaction, which had lowest value
#'
#'   \code{bid} is the most profitable rate of active purchase orders
#'
#'   \code{ask} is the most profitable rate of active sell orders
#'
#'   \code{vwap} is the weighted average from last 24 hours
#'
#'   \code{average} is the average rate of 3 best sell orders
#'
#'   \code{volume} is the number of shares traded during last 24 hours
#'
#' @author Michal Majka
#'
#' @seealso \code{\link{bitbay_orderbook}}, \code{\link{bitbay_trades}},
#'          \code{\link{bitbay_trades_from_date}}, \code{\link{bitbay_profit}},
#' @references BitBay:
#' \url{https://bitbay.net/en/home}
#'
#' @references BitBay Public API:
#' \url{https://bitbay.net/en/api-publiczne}
#'
#' @examples
#' ticker_BTC_USD <- bitbay_ticker(pair = "BTC/USD")
#' ticker_BTC_USD
#' attr(ticker_BTC_USD, "pair")
#' attr(ticker_BTC_USD, "download_time")
#'
#'
#' ticker_BTC_EUR <- bitbay_ticker(pair = "BTC/EUR")
#' ticker_BTC_EUR
#' attributes(ticker_BTC_EUR)[c("pair", "download_time")]
#'
#'
#' ticker_LSK_PLN <- bitbay_ticker(pair = "LSK/PLN")
#' ticker_LSK_PLN
#' attributes(ticker_LSK_PLN)[4:5]
#'
#' @export bitbay_ticker

bitbay_ticker <- function(pair = "BTC/EUR") {

    bitbay_check(pair)

    split_pair <- strsplit(pair,split = "/")[[1]]
    coin <- split_pair[1]
    currency <- split_pair[2]

    url <- paste0("https://bitbay.net/API/Public/", coin, currency, "/",
                  "ticker", ".json")

    data <- jsonlite::fromJSON(url)

    data <- as.data.frame(do.call(rbind, data))
    data$type <- rownames(data)
    data <- data[2:1]
    rownames(data) <- NULL
    colnames(data) <- c("Statistic", "Value")
    attr(data, "pair") <- pair
    attr(data, "download_time") <- Sys.time()
    data
}
