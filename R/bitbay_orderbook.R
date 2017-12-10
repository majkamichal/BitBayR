#' Download orderbook from the BitBay crypto-currency exhange
#'
#' This function can be used to download the orderbook from BitBay market
#' through the public API.
#'
#' @param pair a character string with a pair.
#' Available pairs: combinations of "BTC", "ETC", "LSK", "LTC", "GAME" "DASH" "BCC" and "PLN", "EUR", "USD", "BTC". They have to be separated by "/".
#'
#' @return A list with two data frames containing \code{bids} and \code{asks},
#'
#' @author Michal Majka
#'
#' @seealso \code{\link{bitbay_orderbook}}, \code{\link{bitbay_trades}},
#'          \code{\link{bitbay_trades_from_date}}, \code{\link{bitbay_profit}},
#'
#' @references BitBay:
#' \url{https://bitbay.net/en/home}
#'
#' @references BitBay Public API:
#' \url{https://bitbay.net/en/api-publiczne}
#'
#' @examples
#' orderbook_BTC_USD <- bitbay_orderbook(pair = "BTC/EUR")
#' head(orderbook_BTC_USD$bids)
#' head(orderbook_BTC_USD$asks)
#'
#' @export bitbay_orderbook

bitbay_orderbook <- function(pair = "BTC/EUR") {

    bitbay_check(pair)

    split_pair <- strsplit(pair,split = "/")[[1]]
    coin <- split_pair[1]
    currency <- split_pair[2]

    url <- paste0("https://bitbay.net/API/Public/", coin, currency, "/",
                  "orderbook", ".json")

    data <- jsonlite::fromJSON(url)

    data$bids <- as.data.frame(cbind(data$bids, data$bids[ ,1] * data$bids[ ,2]))
    data$asks <- as.data.frame(cbind(data$asks, data$asks[ ,1] * data$asks[ ,2]))

    colnames(data$bids) <- c("Bid", "Volume", "Price")
    colnames(data$asks) <- c("Ask", "Volume", "Price")

    attr(data, "pair") <- pair
    attr(data, "download_time") <- Sys.time()
    data
}
