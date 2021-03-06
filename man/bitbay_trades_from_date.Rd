% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bitbay_trades_from_date.R
\name{bitbay_trades_from_date}
\alias{bitbay_trades_from_date}
\title{Download transactions from the BitBay crypto-currency exhange}
\usage{
bitbay_trades_from_date(pair = "BTC/USD", date = Sys.time() - 60 * 60 * 24)
}
\arguments{
\item{pair}{a character string with a pair.
Available pairs: combinations of "BTC", "ETC", "LSK", "LTC", "GAME" "DASH" "BCC" and "PLN", "EUR", "USD", "BTC". They have to be separated by "/".}

\item{date}{a character string or date-time object that can be converted to POSIXct date-time object.
By default set to Sys.time() - 1 day.}
}
\value{
A data frame with following four columns:

  \code{Date} date of transaction in POSIXct format (GMT time zone)

  \code{Price} rate

  \code{Order} type of the order (sell/buy)

  \code{Volume} amount of cryptocurrency in that transaction

  \code{TID} unique transaction id
}
\description{
This function can be used to download all transactions occurring
after a specified date from BitBay market through the public API.
}
\examples{
\dontrun{

  # All transactions occurred within last '24 hours'
  data_last24h <- bitbay_trades_from_date(pair = "BTC/EUR", date = Sys.time() - 60 * 60 * 24)
  # 1 day = 60 seconds * 60 minutes * 24 hours

  head(data_last24h)
  tail(data_last24h)

  # Additional attributes (pair and download time)
  attributes(data_last24h)$pair
  attributes(data_last24h)$download_time


  # Transactions occurred after a specific date
  date <- substring(as.character((Sys.time()) - 86400), 1, 10)
  date
  data_specific_day <- bitbay_trades_from_date(pair = "BTC/EUR", date = date)
  head(data_specific_day)
  tail(data_specific_day)


  # Transactions occurred after even more specific date
  date2 <- as.character((Sys.time()) - 86400)
  date2
  more_specific_date <- bitbay_trades_from_date(pair = "BTC/EUR", date = date2)
  head(more_specific_date)
  tail(more_specific_date)
}

}
\references{
BitBay:
\url{https://bitbay.net/en/home}

BitBay Public API:
\url{https://bitbay.net/en/api-publiczne}
}
\seealso{
\code{\link{bitbay_orderbook}}, \code{\link{bitbay_ticker}},
         \code{\link{bitbay_trades}}, \code{\link{bitbay_profit}}
}
\author{
Michal Majka
}
