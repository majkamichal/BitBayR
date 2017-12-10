#' Perform a theoretical/virtual market order on the BitBay crypto-currency exhange
#'
#' \code{bitbay_profit} function performs a theoretical/virtual market order, where
#'  a specified amount of crypto-currency is sold at the current market price.
#'
#' @param coin a character string with a name of the coin.
#' Available coins: "BTC", "ETC", "LSK", "LTC", "GAME" "DASH" "BCC"
#'
#' @param amount a numeric vector of length 1 with the amount of the
#' crypto currency to be sold
#'
#' @param currency a character string with a name of the currency.
#' Available currencies: "USD", "EUR", "PLN"
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
#' bitbay_profit(coin = "BTC", amount = 1, currency = "USD",
#'               investment = 5000, fee = 0.003)
#'
#' @export bitbay_profit

bitbay_profit <- function(coin = "BTC", amount = 1, currency = "USD", fee = 0.003, investment = NULL) {

    bitbay_check(coin, currency)
    names(amount) <- NULL
    initial_amount <- amount

    actual_bids <- bitbay_orderbook(coin, currency)$bids
    money <- 0
    i <- 1

    if (amount > sum(actual_bids$Volume))
        warning(paste0("Specified amount is bigger than the actual supply. \n",
                       "Selling ", sum(actual_bids$Volume), " out of ",
                       amount, " coins"))

    df <- NULL
    while (amount != 0) {
        ith_bid <- actual_bids[i, ]
        if (ith_bid$Volume < amount) {
            amount <- amount - ith_bid$Volume
            money <- money + ith_bid$Price * (1 - fee)
            df <- rbind(df,
                        data.frame(bid = ith_bid$Bid,
                                   amount = ith_bid$Volume,
                                   price = ith_bid$Price,
                                   fee = ith_bid$Price * fee))
            i <- i + 1
        } else {
            money <- money + (amount * ith_bid$Bid) * (1 - fee)
            df <- rbind(df,
                        data.frame(bid = ith_bid$Bid,
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
    attr(res, "pair") <- paste0(coin, "/", currency)
    attr(res, "download_time") <- Sys.time()
    res
}
