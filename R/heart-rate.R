#Constants
url_heart <- "https://api.fitbit.com/1/user/-/activities/heart/"

#' @title Get Heart Rate Time Series
#'
#' @description
#'  \code{get_heart_rate_time_series()} returns time series data in the specified range
#'   If you specify earlier dates in the request, the response will retrieve only data since the user's join date or the first log entry date for the requested collection.
#'
#' @inheritParams inheritparams_token
#' @param date The end date of the period specified in the format "yyyy-MM-dd" or "today" as a string or Date object.
#' @param period The range for which data will be returned. Options are "1d", "7d", "30d", "1w", "1m".
#' @param base_date The range start date in the format "yyyy-MM-dd" or "today" as a string or Date object.
#' @param end_date The end date of the range in the format "yyyy-MM-dd" or "today" as a string or Date object.
#' @inheritParams inheritparams_simplify
#'
#' @details
#' See \url{https://dev.fitbit.com/reference/web-api/heart-rate/#get-heart-rate-time-series} for more details.
#'
#' @export
get_heart_rate_time_series <- function(token, date="", period="", base_date="", end_date="", simplify=TRUE)
{
  url <- if(date != "" && period != ""){
    paste0(url_heart, sprintf("date/%s/%s.json", format_date(date), period))
  } else if(base_date != "" & end_date != ""){
    paste0(url_heart, sprintf("date/%s/%s.json", format_date(base_date), format_date(end_date)))
  } else{
    stop("You have to specify (date and period) or (base_date and end_date)")
  }
  tidy_output(get(url, token), simplify)
}

#' @title Get Heart Rate Intraday Time Series
#'
#' @description
#'   \code{get_heart_rate_intraday_time_series()} returns the intraday time series.
#'   If your application has the appropriate access, your calls to a time series endpoint for a specific day (by using start and end dates on the same day or a period of 1d),
#'   the response will include extended intraday values with a one-minute detail level for that day.
#'   Access to the Intraday Time Series for personal use (accessing your own data) is available through the "Personal" App Type.
#'
#' @inheritParams inheritparams_token
#' @param date The end date of the period specified in the format "yyyy-MM-dd" or "today" as a string or Date object.
#' @param detail_level Number of data points to include. Either "1sec" or "1min".
#' @param start_time The start of the period, in the format "HH:mm".
#' @param end_time The end of the period, in the format "HH:mm"
#' @inheritParams inheritparams_simplify
#'
#' @details
#' See \url{'https://dev.fitbit.com/reference/web-api/heart-rate/#get-heart-rate-intraday-time-series} for more details.
#
#' @export
get_heart_rate_intraday_time_series <- function(token, date="", detail_level="1min", start_time=NULL, end_time=NULL, simplify=TRUE)
{
  date <- format_date(date)
  url <- if(!is.null(start_time) && !is.null(end_time)){
    date2 <- as.Date(date) + 1
    paste0(url_heart, sprintf("date/%s/%s/%s/time/%s/%s.json", date, date2, detail_level, start_time, end_time))
  } else{
    paste0(url_heart, sprintf("date/%s/1d/%s.json", date, detail_level))
  }

  content <- get(url, token)
  if(simplify){
    content$`activities-heart-intraday`$dataset
  } else{
    content
  }
}
