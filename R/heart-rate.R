#Constants
url_heart <- "https://api.fitbit.com/1/user/-/activities/heart/"

#' Get Heart Rate Time Series
#'
#' Returns time series data in the specified range for a given resource in the format requested
#' If you specify earlier dates in the request, the response will retrieve only data since the user's join date or the first log entry date for the requested collection.
#'
#' @param token An OAuth 2.0 token
#' @param date	The end date of the period specified in the format "yyyy-MM-dd" or "today" as a string or Date object.
#' @param period	The range for which data will be returned. Options are 1d, 7d, 30d, 1w, 1m.
#' @param base_date	The range start date in the format "yyyy-MM-dd" or "today" as a string or Date object.
#' @param end_date	The end date of the range in the format "yyyy-MM-dd" or "today" as a string or Date object.
#' @export
get_heart_rate_time_series <- function(token, date="", period="", base_date="", end_date="")
{
  url <- if(date != "" && period != ""){
    paste0(url_heart, sprintf("date/%s/%s.json", format_date(date), period))
  } else if(base_date != "" & end_date != ""){
    paste0(url_heart, sprintf("date/%s/%s.json", format_date(base_date), format_date(end_date)))
  }
  response <- get(url, token)
  data <- convert_content_to_r_object(response)$'activities-heart'
  date <- as.Date(data$dateTime)

  custom_heart_rate_zones <- lapply(data$value$customHeartRateZones, function(x) ifelse(length(x)==0, NA, x))

  heart_rate_zones <- lapply(data$value$heartRateZones, function(x){
    if(ncol(x)!=5){
      data.frame(caloriesOut=NA, dplyr::select(x, max, min), minutes=0, name=x$name)
    } else{x}
  })
  df <- as.data.frame(data.table::rbindlist(heart_rate_zones))
  df$name <- str_replace_all(tolower(df$name), " ", "_")
  df <- dplyr::data_frame(
    date  = rep(rep(date, each=4), 2),
    name  = c(paste0(df$name, "_max"), paste0(df$name, "_min")),
    value = c(df$max, df$min)
  )
  tidyr::spread(df, name, value)
}

#' Get Heart Rate Intraday Time Series
#'
#' Returns the intraday time series for a given resource in the format requested. If your application has the appropriate access, your calls to a time series endpoint for a specific day (by using start and end dates on the same day or a period of 1d), the response will include extended intraday values with a one-minute detail level for that day. Unlike other time series calls that allow fetching data of other users, intraday data is available only for and to the authorized user.
#'
#' Access to the Intraday Time Series for personal use (accessing your own data) is available through the "Personal" App Type.
#' Access to the Intraday Time Series for all other uses is currently granted on a case-by-case basis.
#' Applications must demonstrate necessity to create a great user experience.
#' Fitbit is very supportive of non-profit research and personal projects.
#' Commercial applications require thorough review and are subject to additional requirements.
#' Only select applications are granted access and Fitbit reserves the right to limit this access.
#' To request access, email api@fitbit.com.
#'
#' @param date	The date, in the format yyyy-MM-dd or today.
#' @param detail_level	Number of data points to include. Either 1sec or 1min. Optional.
#' @param start_time	The start of the period, in the format HH:mm. Optional.
#' @param end_time	The end of the period, in the format HH:mm. Optional.
#' @export
get_heart_rate_intraday_time_series <- function(token, date, detail_level, start_time, end_time)
{
  url <- paste0(url_heart, sprintf("date/%s/1d/%s.json", format_date(date), detail_level))
  response <- get(url, token)
  data <- convert_content_to_r_object(response)
  df <- data$'activities-heart-intraday'$dataset
  df$time <- format_time_string(date, df$time)
  df
}
