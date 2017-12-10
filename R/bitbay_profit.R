#' Perform a theoretical/virtual market order on the BitBay crypto-currency exhange
#'
#' \code{bitbay_profit} function performs a theoretical/virtual market order, where
#'  a specified amount of crypto-currency is sold at the current market price.
#'
#' @param pair a character string with a pair.
#' Available pairs: combinations of "BTC", "ETC", "LSK", "LTC", "GAME" "DASH" "BCC" and "PLN", "EUR", "USD", "BTC". They have to be separated by "/".
#'
#' @param amount a numeric vector of length 1 with the amount of the
#' crypto currency to be sold
#'
#' @param fee a numeric vector of length 1 with transaction fee. By default, fee = 0.003 (0.3\%)
#'
#' @param investment (optional) a numeric vector of length 1 with the amount of investment
#'
#' @return A list with two data frames - \code{transactions} and \code{summary}.
#' The former contains transactions and the latter summary (amount sold, profit, etc)
#'
#' @author Michal Majka
#'
#' @seealso \code{\link{bitbay_orderbook}}, \code{\link{bitbay_trades}},
#'          \code{\link{bitbay_trades_from_date}}
#'
#' @references BitBay:
#' \url{https://bitbay.net/en/home}
#'
#' @references BitBay Public API:
#' \url{https://bitbay.net/en/api-publiczne}
#'
#' @examples
#' # Sell 1 BTC for USD with fee 0.3% and compute profit (investment = 5000 USD)
#' bitbay_profit(pair = "BTC/EUR", amount = 1, investment = 5000, fee = 0.003)
#'
#' @export bitbay_profit

bitbay_profit <- function(pair = "BTC/EUR", amount = 1, fee = 0.003, investment = NULL) {

    bitbay_check(pair)
    names(amount) <- NULL
    initial_amount <- amount

    actual_bids <- bitbay_orderbook(pair)$bids
    n_bids <- nrow(actual_bids)
    money <- 0
    i <- 1

    if (amount > sum(actual_bids$Volume))
        warning(paste0("Specified amount is bigger than the actual supply. \n",
                       "Selling ", round(sum(actual_bids$Volume), 3), " out of ",
                       round(amount, 3), " coins"))

    df <- NULL
    while (amount != 0) {

        if (i > n_bids) {
            break
        }

        ith_bid <- actual_bids[i, ]

        if (ith_bid$Volume < amount) {
            amount <- amount - ith_bid$Volume
            money <- money + ith_bid$Price * (1 - fee)

            df <- rbind(df, data.frame(bid = ith_bid$Bid,
                                       amount = ith_bid$Volume,
                                       price = ith_bid$Price,
                                       fee = ith_bid$Price * fee))
            i <- i + 1

        } else {
            money <- money + (amount * ith_bid$Bid) * (1 - fee)
            df <- rbind(df, data.frame(bid = ith_bid$Bid,
                                       amount = amount,
                                       price = amount * ith_bid$Bid,
                                       fee = amount * ith_bid$Bid * fee))
            amount <- 0
        }
    }

    amount_sold <- initial_amount - amount
    profit <- ifelse(!is.null(investment), (money / investment - 1) * 100, NA)

    data <- c(`Amount` = initial_amount,
              `Amount sold` = amount_sold,
              `Money (with fees)` = money,
              `Investment` = ifelse(!is.null(investment), investment, NA),
              `Fee (in %)` = fee,
              `Profit (in %)` = profit)

    res <- list(transactions = df, summary = data)
    attr(res, "pair") <- pair
    attr(res, "download_time") <- Sys.time()
    res
}
