#' @include fitbitr.R
# Constants
url_activity <- paste0(url_api, "activities/")

#' @title Get Daily Activity Summary
#'
#' @description
#'   \code{get_activity_summary()} retrieves a summary and list of a user's activities and activity log entries for a given day.
#'
#' @inheritParams inheritparams_token
#' @inheritParams inheritparams_date
#'
#' @return A list
#'
#' @details
#' See \url{https://dev.fitbit.com/reference/web-api/activity/#get-daily-activity-summary} for more details.
#'
#' @export
get_activity_summary <- function(token, date)
{
  url <- paste0(url_activity, sprintf("date/%s.json", format_date(date)))
  response <- get(url, token)
  convert_content_to_r_object(response)
}

#' @title Get Activity Time Series
#'
#' @description
#'   \code{get_activity_time_series()} returns time series data in the specified range for a given resource.
#'
#' @inheritParams inheritparams_token
#' @param resource_path The resource path. see details below.
#' @param base_date The range start date. A Date class object or a string in the format yyyy-MM-dd or today.
#' @param end_date The end date of the range. A Date class object or a string in the format yyyy-MM-dd.
#' @param date The end date of the period specified. A Date class object or a string in the format yyyy-MM-dd.
#' @param period The range for which data will be returned. Options are "1d", "7d", "30d", "1w", "1m", "3m", "6m", "1y", or "max".
#' @param simplify coerce a list into a data.frame
#'
#' @details
#'  Available resource_path are
#'  \itemize{
#'    \item calories
#'    \item caloriesBMR
#'    \item steps
#'    \item distance
#'    \item floors
#'    \item elevation
#'    \item minutesSedentary
#'    \item minutesLightlyActive
#'    \item minutesFairlyActive
#'    \item minutesVeryActive
#'    \item activityCalories
#'  }
#'
#'  See \url{https://dev.fitbit.com/reference/web-api/activity/#get-activity-time-series} for more details.
#'
#' @export
get_activity_time_series <- function(token, resource_path, date="", period="", base_date="", end_date="", simplify=TRUE)
{
  url <- if(date != "" && period != ""){
    paste0(url_activity, sprintf("%s/date/%s/%s.json", resource_path, format_date(date), period))
  } else if(base_date != "" & end_date != ""){
    paste0(url_activity, sprintf("%s/date/%s/%s.json", resource_path, format_date(base_date), format_date(end_date)))
  }
  tidy_output(get(url, token), simplify)
}

tidy_output <- function(response, simplify)
{
  content <- convert_content_to_r_object(response)
  if(!simplify){return(content)}
  if(is.data.frame(content)){return(content)}
  if(length(content) == 0){return(content)}

  #Stop redundant warnings
  old <- options(warn = -1)
  result <- Reduce(cbind, lapply(content, as.data.frame))
  options(old)
  names(result) <- stringr::str_replace_all(names(result), "\\.", "_")
  result
}

#' @title Get Activity Intraday Time Series
#'
#' @description
#'   \code{get_activity_intraday_time_series()} returns intraday time series data in the specified range for a given resource.
#'   Access to the Intraday Time Series for personal use (accessing your own data) is available through the "Personal" App Type.
#'
#' @inheritParams inheritparams_token
#' @param resource_path The resource path of the desired data
#' @inheritParams inheritparams_date
#' @param detail_level Number of data points to include. Either 1min or 15min. Optional.
#' @param start_time The start of the period, in the format HH:mm. Optional.
#' @param end_time The end of the period, in the format HH:mm. Optional.
#'
#' @details
#'  Available resource_path are
#'  \itemize{
#'    \item calories
#'    \item steps
#'    \item distance
#'    \item floors
#'    \item elevation
#'  }
#'
#'  See \url{https://dev.fitbit.com/reference/web-api/activity/#get-activity-intraday-time-series} for more details.
#'
#' @export
get_activity_intraday_time_series <- function(token, resource_path, date, detail_level="15min", start_time=NULL, end_time=NULL, simplify=TRUE)
{
  date <- format_date(date)
  url <- if(!is.null(start_time) && !is.null(end_time)){
    date2 <- if(start_time < end_time){
      "1d"
    } else{
      date2 <- as.Date(date) + 1
    }
    paste0(url_activity, sprintf("%s/date/%s/%s/%s/time/%s/%s.json", resource_path, date, date2, detail_level, start_time, end_time))
  } else{
    paste0(url_activity, sprintf("%s/date/%s/1d/%s.json", resource_path, date, detail_level))
  }
  tidy_output(get(url, token), simplify)
}


#' @title Get Activity Logs List
#'
#' @descriptions
#'   \code{get_activity_logs_list()} retrieves a list of a user's activity log entries before or after a given day with offset and limit
#'
#' @inheritParams inheritparams_token
#' @param before_date The date in the format yyyy-MM-ddTHH:mm:ss. Only yyyy-MM-dd is required.
#'   Either beforeDate or afterDate should be specified.
#' @param after_date The date in the format yyyy-MM-ddTHH:mm:ss.
#' @param sort The sort order of entries by date asc (ascending) or desc (descending).
#' @param offset The offset number of entries.
#' @param limit The max of the number of entries returned (maximum: 100)
#'
#' @details
#'   See \url{https://dev.fitbit.com/reference/web-api/activity/#get-activity-logs-list} for more details.
#'
#' @export
get_activity_logs_list <- function(token, before_date, after_date, sort, offset, limit)
{
  stop("Sorry, under construction")
  #url <- paste0(url_activity, "list.json")
  #convert_content_to_r_object(get(url, token))
}

#' @title Get Activity Types
#'
#' @description
#'   Get a tree of all valid Fitbit public activities from the activities catalog as well as private custom activities the user created
#'
#' @inheritParams inheritparams_token
#'
#' @export
get_activity_types <- function(token)
{
  url <- paste0(url_base, "activities.json")
  tidy_output(get(url, token), simplify=FALSE)
}


#' Get Activity Type
#'
#' Returns the details of a specific activity in the Fitbit activities database in the format requested.
#' If activity has levels, also returns a list of activity level details.
#'
#' @inheritParams inheritparams_token
#' @param activity_id The activity ID.
#'
#' @export
get_activity_type <- function(token, activity_id)
{
  #GET https://api.fitbit.com/1/activities/[activity-id].json
  url <- paste0(url_base, sprintf("activities/%s.json", activity_id))
  response <- get(url, token)
  convert_content_to_r_object(response)
}

#' @title Get Frequent Activities
#'
#' @descriptions
#'   \code{get_frequent_activities()} retrieves a list of a user's frequent activities.
#'
#' @inheritParams inheritparams_token
#' @inheritParams inheritparams_simplify
#'
#' @details
#'   See \url{https://dev.fitbit.com/reference/web-api/activity/#get-frequent-activities}  for more details.
#'
#' @export
get_frequent_activities <- function(token)
{
  url <- paste0(url_activity, "frequent.json")
  tidy_output(get(url, token), TRUE)
}

#' Get Recent Activity Types
#'
#' Retrieves a list of a user's recent activities types logged with some details of the last activity log of that type.
#'
#' @inheritParams inheritparams_token
#' @inheritParams inheritparams_simplify
#'
#' @export
get_recent_activity_types <- function(token)
{
  url <- paste0(url_activity, "recent.json")
  tidy_output(get(url, token), TRUE)
}

#' Get Favorite Activities
#'
#' Returns a list of a user's favorite activities.
#'
#' @inheritParams inheritparams_token
#'
#' @export
get_favorite_activities <- function(token)
{
  url <- paste0(url_activity, "favorite.json")
  tidy_output(get(url, token), TRUE)
}

#' Add Favorite Activity
#'
#' The Add Favorite Activity endpoint adds the activity with the given ID to user's list of favorite activities.
#' Note: A successful request returns a 201 response code with an empty body.
#'
#' @param token An OAuth 2.0 token generated by oauth_token()
#' @param activity_id	The ID of the activity to add to user's favorites.
#' @export
add_favorite_activity <- function(token, activity_id)
{
  #POST https://api.fitbit.com/1/user/-/activities/favorite/[activity-id].json
  url <- paste0(url_activity, sprintf("favorite/%s.json", activity_id))
  response <- post(url, token, list())
  convert_content_to_r_object(response)
}

#' Delete Favorite Activity
#'
#' The Delete Favorite Activity removes the activity with the given ID (activity_id) from a user's list of favorite activities.
#'
#' @param token An OAuth 2.0 token generated by oauth_token()
#' @param activity_id	The ID of the activity to be removed.
#' @export
delete_favorite_activity <- function(token, activity_id)
{
  url <- paste0(url_activity, sprintf("favorite/%s.json", activity_id))
  response <- delete(url, token)
  convert_content_to_r_object(response)
}

#' Get Activity Goals
#'
#' The Get Activity Goals retrieves a user's current daily or weekly activity goals using measurement units as defined in the unit system, which corresponds to the Accept-Language header provided.
#' Considerations
#' Only the current goals are returned.
#' Floors goal only returned for users who currently or have previously paired a Fitbit device with an altimeter.
#' Calories out goal represents either dynamic daily target from the Premium trainer plan or manual calorie burn goal.
#' The default daily goal values are:
#' 10 floors
#' 30 active minutes
#' Calories out is user specific, which accounts for BMR
#'
#' @param token An OAuth 2.0 token generated by oauth_token()
#' @param period daily or weekly
#' @export
get_activity_goals <- function(token, period)
{
  url <- paste0(url_activity, sprintf("goals/%s.json", period))
  response <- get(url, token)
  convert_content_to_r_object(response)
}

#' Update Activity Goals
#'
#' The Update Activity Goals endpoint creates or updates a user's daily activity goals and returns a response using units in the unit system which corresponds to the Accept-Language header provided.
#'
#' @inheritParams inheritparams_token
#' @param period daily or weekly
#' @param calories_out optional	Goal value; integer.
#' @param active_minutes optional	Goal value; integer.
#' @param floors optional	Goal value; integer.
#' @param distance optional	Goal value; in the format X.XX or integer.
#' @param steps optional	Goal value; integer.
#'
#' @export
update_activity_goals <- function(token, period, calories_out, active_minutes, floors, distance, steps)
{
  #POST https://api.fitbit.com/1/user/[user-id]/activities/goals/[period].json
  url <- paste0(url_activity, sprintf("goals/%s.json", period))
  response <- post(url, token)
  convert_content_to_r_object(response)
}

#' Get Lifetime Stats
#'
#' Retrieves the user's activity statistics in the format requested using units in the unit system which corresponds to the Accept-Language header provided. Activity statistics includes Lifetime and Best achievement values from the My Achievements tile on the website dashboard. Response contains both statistics from the tracker device and total numbers including tracker data and manual activity log entries as seen on the Fitbit website dashboard.
#'
#' Privacy Setting
#' The My Achievements (Friends or Anyone) privacy permission grants access to user's resource.
#'
#' @inheritParams inheritparams_token
#'
#' @export
get_lifetime_stats <- function(token)
{
  #GET https://api.fitbit.com/1/user/[user-id]/activities.json
  url <- paste0(url_api, "activities.json")
  response <- get(url, token)
  convert_content_to_r_object(response)
}
