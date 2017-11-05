#' Download transactions from the BitBay crypto-currency exhange
#'
#' This function can be used to download last N or all historic transactions
#' from BitBay market through the public API.
#'
#' @param coin a character string with a name of the coin.
#' Available coins: "BTC", "ETC", "LSK", "LTC", "GAME" "DASH" "BCC"
#'
#' @param currency a character string with a name of the currency.
#' Available currencies: "USD", "EUR", "PLN"
#'
#' @param last_trades a positive integer N or a character string "all". If an integer is specified then the last N transactions are going to be downloaded. If "all" then all historic transactions are going to be downloaded.
#'
#' @return A data frame with following four columns:
#'
#'   \code{Date} date of transaction in POSIXct format (GMT time zone)
#'
#'   \code{Price} rate
#'
#'   \code{Order} type of the order (sell/buy)
#'
#'   \code{Volume} amount of cryptocurrency in that transaction
#'
#'   \code{TID} unique transaction id
#'
#' @author Michal Majka
#'
#' @seealso \code{\link{bitbay_orderbook}}, \code{\link{bitbay_ticker}},
#'          \code{\link{bitbay_trades_from_date}}, \code{\link{bitbay_profit}}
#'
#' @references BitBay:
#' \url{https://bitbay.net/en/home}
#'
#' @references BitBay Public API:
#' \url{https://bitbay.net/en/api-publiczne}
#'
#' @examples
#'
#' \dontrun{
#'
#' # Download last 50 trades
#' last_50_trades <- bitbay_trades()
#' head(last_50_trades)
#' tail(last_50_trades)
#'
#'
#' # Additional attributes (pair and download time)
#' attributes(last_50_trades)$pair
#' attributes(last_50_trades)$download_time
#'
#'
#' trades_LSK_EUR <- bitbay_trades(coin = "LSK", currency = "EUR", last_trades = 100)
#' head(trades_LSK_EUR)
#' tail(trades_LSK_EUR)
#' attributes(trades_LSK_EUR)[c("pair", "download_time")]
#'
#'
#'
#' all_trades <- bitbay_trades(coin = "BTC", currency = "USD", last_trades = "all")
#' head(all_trades)
#' tail(all_trades)
#' }
#'
#' @export bitbay_trades

bitbay_trades <-  function(coin = "BTC", currency = "USD", last_trades = 50) {

    bitbay_check(coin, currency)

    url <- paste0("https://bitbay.net/API/Public/", coin, currency, "/",
                  "trades", ".json", "?sort=desc")

    most_current_id <- as.numeric(jsonlite::fromJSON(url)[1,"tid"])

    if (last_trades == "all")
        last_trades <- most_current_id + 1

    thr <- 500

    if (last_trades > thr)
        pb <- utils::txtProgressBar(min = -most_current_id,
                                    max = -most_current_id + last_trades,
                                    style = 3)

    id <- most_current_id + 1
    data <- NULL

    while (TRUE) {

        url <- paste0("https://bitbay.net/API/Public/", coin, currency, "/",
                      "trades", ".json", "?sort=desc&since=", id)
        data <- rbind(data, jsonlite::fromJSON(url))
        id <- id - 50

        if (any(data$tid == "0")) {
            data <- data[-nrow(data), ]
            break
        }

        if (nrow(data) > last_trades) {
            data <- data[seq_len(last_trades), ]
            break
        }
        if (last_trades > thr) {
            utils::setTxtProgressBar(pb, -id)
        }
    }

    if (last_trades > thr)
        close(pb)

    data$date <- as.POSIXct(data$date, origin = "1970-01-01")
    names(data) <- c("Date", "Price", "Order", "Volume", "TID")
    attr(data, "pair") <- paste0(coin, "/", currency)
    attr(data, "download_time") <- Sys.time()
    attr(data, "class") <- c("data.frame", "bitbay_transactions")
    data <- data[nrow(data):1, ]
    rownames(data) <- NULL
    data
}

