#' @export bitbay_check
bitbay_check <- function(pair) {

    split_pair <- strsplit(pair,split = "/")[[1]]
    coin <- split_pair[1]
    currency <- split_pair[2]

    all_coins <- c("Bitcoin" =  "BTC", "Ethereum" = "ETH", "Lisk" = "LSK",
                   "Litecoin" = "LTC", "Game" = "GAME", "Dash" = "DASH",
                   "Bitcoin cash" = "BCC")
    all_currencies <- c("US Dollar" = "USD", "Zloty" = "PLN", "Euro" = "EUR",
                        "Bitcoin" = "BTC")

    coin <- toupper(coin)
    currency <- toupper(currency)


    if (!(coin %in% all_coins) & !(currency %in% all_currencies))
        stop(paste0("\n  Coin '", coin, "'", " is not available.", "\n",
                    "        Available coins: ", paste0(all_coins, collapse = ", "),
                    "\n  Currency '", currency, "'", " is not available.\n",
                    "        Available currencies: ", paste0(all_currencies, collapse = ", "), "\n"))
    if (coin == "BTC" & currency == "BTC")
        stop("BTC/BTC cannot be traded")

    if (!(currency %in% all_currencies))
        stop(paste0("\n  Currency '", currency, "'", " is not available.", "\n",
                    "        Available currencies: ",
                    paste0(all_currencies, collapse = ", "), "\n"))


    if (!(coin %in% all_coins))
        stop(paste0("\n  Coin '", currency, "'", " is not available.", "\n",
                    "        Available coins: ",
                    paste0(all_coins, collapse = ", "), "\n"))
}
