#' Download transactions from the BitBay crypto-currency exhange
#'
#' This function can be used to download all transactions occurring
#' after a specified date from BitBay market through the public API.
#'
#' @param pair a character string with a pair.
#' Available pairs: combinations of "BTC", "ETC", "LSK", "LTC", "GAME" "DASH" "BCC" and "PLN", "EUR", "USD", "BTC". They have to be separated by "/".
#'
#' @param date a character string or date-time object that can be converted to POSIXct date-time object.
#' By default set to Sys.time() - 1 day.
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
#'          \code{\link{bitbay_trades}}, \code{\link{bitbay_profit}}
#'
#' @references BitBay:
#' \url{https://bitbay.net/en/home}
#'
#' @references BitBay Public API:
#' \url{https://bitbay.net/en/api-publiczne}
#'
#' @examples
#' \dontrun{
#'
#'   # All transactions occurred within last '24 hours'
#'   data_last24h <- bitbay_trades_from_date(pair = "BTC/EUR", date = Sys.time() - 60 * 60 * 24)
#'   # 1 day = 60 seconds * 60 minutes * 24 hours
#'
#'   head(data_last24h)
#'   tail(data_last24h)
#'
#'   # Additional attributes (pair and download time)
#'   attributes(data_last24h)$pair
#'   attributes(data_last24h)$download_time
#'
#'
#'   # Transactions occurred after a specific date
#'   date <- substring(as.character((Sys.time()) - 86400), 1, 10)
#'   date
#'   data_specific_day <- bitbay_trades_from_date(pair = "BTC/EUR", date = date)
#'   head(data_specific_day)
#'   tail(data_specific_day)
#'
#'
#'   # Transactions occurred after even more specific date
#'   date2 <- as.character((Sys.time()) - 86400)
#'   date2
#'   more_specific_date <- bitbay_trades_from_date(pair = "BTC/EUR", date = date2)
#'   head(more_specific_date)
#'   tail(more_specific_date)
#' }
#'
#' @export bitbay_trades_from_date

bitbay_trades_from_date <- function(pair = "BTC/USD", date = Sys.time() - 60 * 60 * 24) {

    bitbay_check(pair)

    split_pair <- strsplit(pair,split = "/")[[1]]
    coin <- split_pair[1]
    currency <- split_pair[2]

    date <- as.POSIXct(date, origin = "1970-01-01")
    date_minus_one_sec <- date - 1

    if (date < as.POSIXct("2015-01-01", origin = "1970-01-01")) {
        stop("Data available from 2015-01-01")
    }

    url <- paste0("https://bitbay.net/API/Public/", coin, currency, "/",
                  "trades", ".json", "?sort=desc")

    most_current_id <- as.numeric(jsonlite::fromJSON(url)[1,"tid"])
    id <- most_current_id + 1
    data <- NULL

    ind <-  "Downloading..."
    ind2 <- "              "

    {
        count <- 1
        letter <- 11
        while (TRUE) {

            url <- paste0("https://bitbay.net/API/Public/", coin, currency, "/",
                          "trades", ".json", "?sort=desc&since=", id)
            ith_data <- jsonlite::fromJSON(url)
            ith_data$date <- as.POSIXct(ith_data$date, origin = "1970-01-01")
            data <- rbind(data, ith_data)

            id <- id - 50
            count <- count + 1

            if (count %% 10 == 0) {
                letter <- letter + 1
                if (letter == 15) {
                    cat("\r", strtrim(ind2, 14))
                    letter <- 12
                }
                cat("\r", strtrim(ind, letter))
            }

            if (date_minus_one_sec > utils::tail(data$date,1)) {
                data <- data[data$date > date, ]
                break
            }
        }
        cat("\r", strtrim(ind2, 14))
    }
    names(data) <- c("Date", "Price", "Order", "Volume", "TID")
    attr(data, "pair") <- pair
    attr(data, "download_time") <- Sys.time()
    attr(data, "class") <- c("data.frame", "bitbay_transactions")
    data <- data[nrow(data):1, ]
    rownames(data) <- NULL
    data
}



