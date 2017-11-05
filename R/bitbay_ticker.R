#' Download ticker from the BitBay crypto-currency exhange
#'
#' This function can be used to download the ticker from BitBay market
#' through the public API.
#'
#' @param coin a character string with a name of the coin.
#' Available coins: "BTC", "ETC", "LSK", "LTC", "GAME" "DASH" "BCC"
#'
#' @param currency a character string with a name of the currency.
#' Available currencies: "USD", "EUR", "PLN"
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
#' ticker_BTC_USD <- bitbay_ticker(coin = "BTC", currency = "USD")
#' ticker_BTC_USD
#' attr(ticker_BTC_USD, "pair")
#' attr(ticker_BTC_USD, "download_time")
#'
#'
#' ticker_BTC_EUR <- bitbay_ticker(coin = "BTC", currency = "EUR")
#' ticker_BTC_EUR
#' attributes(ticker_BTC_EUR)[c("pair", "download_time")]
#'
#'
#' ticker_LSK_PLN <- bitbay_ticker(coin = "LSK", currency = "PLN")
#' ticker_LSK_PLN
#' attributes(ticker_LSK_PLN)[4:5]
#'
#' @export bitbay_ticker

bitbay_ticker <- function(coin = "BTC", currency = "USD") {
    
    bitbay_check(coin, currency)
    
    url <- paste0("https://bitbay.net/API/Public/", coin, currency, "/",
                  "ticker", ".json")
    
    data <- jsonlite::fromJSON(url)
    
    data <- as.data.frame(do.call(rbind, data))
    data$type <- rownames(data)
    data <- data[2:1]
    rownames(data) <- NULL
    colnames(data) <- c("Statistic", "Value")
    attr(data, "pair") <- paste0(coin, "/", currency)
    attr(data, "download_time") <- Sys.time()
    data
}
