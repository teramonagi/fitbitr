#Constants
url_sleep <- paste0(url_api, "sleep/")

#' Get Sleep Logs
#' Returns a summary and list of a user's sleep log entries as well as minute by minute sleep entry data for a given day in the format requested.
#' The response includes summary for all sleep log entries for the given day (including naps.)
#' If you need to fetch data only for the user's main sleep event, you can send the request with isMainSleep=true or use a Time Series call.
#'
#' The relationship between sleep log entry properties is expressed with the following equation:
#' timeInBed = minutesToFallAsleep + minutesAsleep + minutesAwake + minutesAfterWakeup
#'
#' Also, values for minuteData can be 1 ("asleep"), 2 ("awake"), or 3 ("really awake").
#'
#' @param token An OAuth 2.0 token
#' @param date	The date of records to be returned. In the format yyyy-MM-dd(character) or Date object.
#' @return a list of "sleep" and "summary" data.frame. "sleep" data.frame contains time series information of sleep. "summary" data.frame contains the summary of each "sleep" information.
#' @export
get_sleep_logs <- function(token, date)
{
  url <- paste0(url_sleep, sprintf("date/%s.json", format_date(date)))
  response <- get(url, token)
  data <- convert_content_to_r_object(response)

  if(length(data$sleep) == 0){
    NULL
  } else{
    result <- suppressWarnings(list(
      sleep=data.frame(
        dplyr::select(data$sleep, -minuteData),
        data$sleep$minuteData
      ),
      summary=as.data.frame(data$summary)
    ))
    result
  }
}

#' Get Sleep Goal
#'
#' Returns a user's current sleep goal
#'
#' @param token An OAuth 2.0 token
#' @examples
#' \dontrun{
#' #Get the current sleep goal.
#' get_sleep_goal(token)
#' }
#' @export
get_sleep_goal <- function(token){sleep_goal(token)}

#' Update Sleep Goal
#'
#' The Update Sleep Goal endpoint creates or updates a user's sleep goal and get a response in the in the format requested
#'
#' @param token An OAuth 2.0 token
#' @param minDuration	The target sleep duration is in minutes.
#' @examples
#' \dontrun{
#' #Set a new sleep goal(377)
#' update_sleep_goal(token, 377)
#' }
#' @export
update_sleep_goal <- function(token, minDuration){sleep_goal(token, minDuration)}

sleep_goal <- function(token, minDuration=NULL)
{
  url <- paste0(url_sleep, "goal.json")
  response <- if(is.null(minDuration)){
    get(url, token)
  }else{
    post(url, token, body=list(minDuration=minDuration))
  }

  as.data.frame(data.table::rbindlist(convert_content_to_r_object(response)))
}

#' Get Sleep Time Series
#'
#' Returns time series data in the specified range for a given resource in the format requested.
#' Note: Even if you provide earlier dates in the request, the response retrieves only data since the user's join date or the first log entry date for the requested collection.
#'
#' @param token An OAuth 2.0 token
#' @param resource_path	The resource path; see the Resource Path Options below for a list of options.
#' @param date	The end date of the period specified in the format yyyy-MM-dd or today.
#' @param period	The range for which data will be returned. Options are 1d, 7d, 30d, 1w, 1m, 3m, 6m, 1y, or max.
#' @param base_date	The range start date, in the format yyyy-MM-dd or today.
#' @param end_date	The end date of the range.
#' @details Resource Path Options in more detail.
#' \itemize{
#'   \item{startTime}
#'   \item{timeInBed}
#'   \item{minutesAsleep}
#'   \item{awakeningsCount}
#'   \item{minutesAwake}
#'   \item{minutesToFallAsleep}
#'   \item{minutesAfterWakeup}
#'   \item{efficiency}
#' }
#'
#' @export
get_sleep_time_series <- function(token, resource_path, date="", period="", base_date="", end_date="")
{
  url <- paste0(url_sleep, sprintf("%s/date/%s/%s.json", resource_path, format_date(date), period))
  response <- get(url, token)
  data <- convert_content_to_r_object(response)
  data[[1]]
}

#' Log Sleep
#'
#' Creates a log entry for a sleep event and returns a response in the format requested.
#' Keep in mind that it is NOT possible to create overlapping log entries or entries for time periods that DO NOT originate from a tracker.
#' Sleep log entries appear on website's sleep tracker interface according to the date on which the sleep event ends.
#'
#' @param token An OAuth 2.0 token
#' @param startTime	required	Start time; hours and minutes in the format HH:mm.
#' @param duration	required	Duration in minutes.
#' @param date	required	Log entry date in the format yyyy-MM-dd.
#' @export
log_sleep <- function(token, startTime, duration, date)
{
  url <- paste0(url_api, "sleep.json")
  body <- list(startTime=startTime, duration=10^3*60*duration, date=format_date("2010-01-05"))
  response <- post(url, token, body=body)
  as.data.frame(data.table::rbindlist(convert_content_to_r_object(response)))
}

#' Delete Sleep Log
#'
#' Deletes a user's sleep log entry with the given ID.
#' A successful request will return a 204 status code with an empty response body.
#'
#' @param token An OAuth 2.0 token
#' @param log_id	ID of the sleep log to be deleted.
#' @export
delete_sleep_log <- function(token, log_id)
{
  url <- paste0(url_sleep, sprintf("%s.json", log_id))
  httr::DELETE(url=url, httr::config(token = token))
}
