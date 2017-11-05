#' Download orderbook from the BitBay crypto-currency exhange
#'
#' This function can be used to download the orderbook from BitBay market
#' through the public API.
#'
#' @param coin a character string with a name of the coin.
#' Available coins: "BTC", "ETC", "LSK", "LTC", "GAME" "DASH" "BCC"
#'
#' @param currency a character string with a name of the currency.
#' Available currencies: "USD", "EUR", "PLN"
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
#' orderbook_BTC_USD <- bitbay_orderbook(coin = "BTC", currency = "USD")
#' head(orderbook_BTC_USD$bids)
#' head(orderbook_BTC_USD$asks)
#'
#' @export bitbay_orderbook

bitbay_orderbook <- function(coin = "BTC", currency = "USD") {
    
    bitbay_check(coin, currency)
    
    url <- paste0("https://bitbay.net/API/Public/", coin, currency, "/",
                  "orderbook", ".json")
    
    data <- jsonlite::fromJSON(url)
    
    data$bids <- as.data.frame(cbind(data$bids, data$bids[ ,1] * data$bids[ ,2]))
    data$asks <- as.data.frame(cbind(data$asks, data$asks[ ,1] * data$asks[ ,2]))
    
    colnames(data$bids) <- c("Bid", "Volume", "Price")
    colnames(data$asks) <- c("Ask", "Volume", "Price")
    
    attr(data, "pair") <- paste0(coin, "/", currency)
    attr(data, "download_time") <- Sys.time()
    data
}
