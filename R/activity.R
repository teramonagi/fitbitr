#' @include fitbitr.R
#' @include common.R
# Constants
url_activity <- paste0(url_api, "activities/")

#' @title Get Daily Activity Summary
#'
#' @description
#'   \code{get_activity_summary()} retrieves a summary and list of a user's activities for a given day.
#'
#' @inheritParams inheritparams_token
#' @inheritParams inheritparams_date
#' @inheritParams inheritparams_simplify
#'
#' @details
#' See \url{https://dev.fitbit.com/reference/web-api/activity/#get-daily-activity-summary} for more details.
#'
#' @export
get_activity_summary <- function(token, date, simplify=TRUE)
{
  url <- paste0(url_activity, sprintf("date/%s.json", format_date(date)))
  # We can not simplify this output because it is so complicated nested list
  tidy_output(get(url, token), simplify=FALSE)
}

#' @title Get Activity Log
#'
#' @description
#'   \code{get_activity_log()} retrieves a data.frame of a user's activity log entries for a given day.
#'
#' @inheritParams inheritparams_token
#' @inheritParams inheritparams_date
#' @inheritParams inheritparams_simplify
#'
#' @details
#' See \url{https://dev.fitbit.com/build/reference/web-api/activity/#get-activity-logs-list} for more details.
#'
#' @export
get_activity_log <- function(token, date = Sys.Date(), simplify=TRUE)
{
  url <- paste0(
    url_activity, "list.json?beforeDate=",
    sprintf(format_date(as.Date(format_date(date)) + 1)),
    "&sort=desc&offset=0&limit=20")
  re <- tidy_output(get(url, token), simplify=FALSE)$activities
  if(is.data.frame(re)){
    re[re$originalStartTime == as.Date(date),]
  } else {
    print("No logging for this date")
  }
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
#' @inheritParams inheritparams_simplify
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
  } else{
    stop("Error: Need to enter combination of date/period or base_date/end_date")
  }
  tidy_output(get(url, token), simplify)
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
#' @inheritParams inheritparams_simplify
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

#' @title Get Activity Types
#'
#' @description
#'   Get a tree of all valid Fitbit public activities from the activities catalog as well as private custom activities the user created
#'
#' @inheritParams inheritparams_token
#' @inheritParams inheritparams_simplify
#'
#' @export
get_activity_types <- function(token, simplify=TRUE)
{
  url <- paste0(url_activity, "activities.json")
  # We can not simplify this output because it is so complicated nested list
  tidy_output(get(url, token), simplify=FALSE)
}

#' @title Get Activity Type
#'
#' @description
#'   \code{get_activity_type()} returns the details of a specific activity in the Fitbit activities database.
#'
#' @inheritParams inheritparams_token
#' @param activity_id The activity ID.
#' @inheritParams inheritparams_simplify
#'
#' @export
get_activity_type <- function(token, activity_id, simplify=TRUE)
{
  url <- paste0(url_base, sprintf("activities/%s.json", activity_id))
  tidy_output(get(url, token), simplify)
}

#' @title Get Frequent Activities
#'
#' @description
#'   \code{get_frequent_activities()} retrieves a list of a user's frequent activities.
#'
#' @inheritParams inheritparams_token
#' @inheritParams inheritparams_simplify
#'
#' @details
#'   See \url{https://dev.fitbit.com/reference/web-api/activity/#get-frequent-activities}  for more details.
#'
#' @export
get_frequent_activities <- make_get_function(paste0(url_activity, "frequent.json"))

#' @title Get Recent Activity Types
#'
#' @description
#'   \code{get_recent_activity_types()} retrieves a list of a user's recent activities types logged with some details of the last activity log of that type.
#'
#' @inheritParams inheritparams_token
#' @inheritParams inheritparams_simplify
#'
#' @details
#'   See \url{https://dev.fitbit.com/reference/web-api/activity/#get-recent-activity-types} for more details.
#'
#' @export
get_recent_activity_types <- make_get_function(paste0(url_activity, "recent.json"))

#' @title Get Favorite Activities
#'
#' @description
#'   \code{get_favorite_activities()} returns a list of a user's favorite activities.
#'
#' @inheritParams inheritparams_token
#' @inheritParams inheritparams_simplify
#'
#' @details
#'   See \url{https://dev.fitbit.com/reference/web-api/activity/#get-favorite-activities} for more details.
#'
#' @export
get_favorite_activities <- make_get_function(paste0(url_activity, "favorite.json"))

#' @title Add Favorite Activity
#'
#' @description
#'   \code{add_favorite_activity()} adds the activity with the given ID to user's list of favorite activities.
#'
#' @param token An OAuth 2.0 token generated by oauth_token()
#' @param activity_id	The ID of the activity to add to user's favorites.
#'
#' @details
#'   See \url{https://dev.fitbit.com/reference/web-api/activity/#add-favorite-activity} for more details.
#'
#' @export
add_favorite_activity <- function(token, activity_id)
{
  #POST https://api.fitbit.com/1/user/-/activities/favorite/[activity-id].json
  url <- paste0(url_activity, sprintf("favorite/%s.json", activity_id))
  invisible(post(url, token, body=NULL))
}

#' @title Delete Favorite Activity
#'
#' @description
#'   \code{delete_favorite_activity()} removes the activity with the given ID (activity_id) from a user's list of favorite activities.
#'
#' @inheritParams inheritparams_token
#' @param activity_id The ID of the activity to be removed.
#'
#' @details
#'   See \url{https://dev.fitbit.com/reference/web-api/activity/#delete-favorite-activity} for more details.
#'
#' @export
delete_favorite_activity <- function(token, activity_id)
{
  url <- paste0(url_activity, sprintf("favorite/%s.json", activity_id))
  invisible(delete(url, token))
}

#' @title Get Activity Goals
#'
#' @description
#'   \code{get_activity_goals()} retrieves a user's current daily or weekly activity goals
#'
#' @inheritParams inheritparams_token
#' @param period "daily" or "weekly"
#' @inheritParams inheritparams_simplify
#'
#' @details
#' See \url{https://dev.fitbit.com/reference/web-api/activity/#get-activity-goals} for more details.
#'
#' @export
get_activity_goals <- function(token, period, simplify=TRUE)
{
  stop_if_x_is_not_in(period, c("daily", "weekly"))

  url <- paste0(url_activity, sprintf("goals/%s.json", period))
  tidy_output(get(url, token), simplify)
}

#' @title Update Activity Goals
#'
#' @description
#'   \code{update_activity_goals()} creates or updates a user's daily activity goals.
#'
#' @inheritParams inheritparams_token
#' @param period daily or weekly
#' @param calories_out optional	Goal value; integer.
#' @param active_minutes optional	Goal value; integer.
#' @param floors optional	Goal value; integer.
#' @param distance optional	Goal value; in the format X.XX or integer.
#' @param steps optional	Goal value; integer.
#'
#' @details
#'   See \url{https://dev.fitbit.com/reference/web-api/activity/#update-activity-goals} for more details.
#'
#' @export
update_activity_goals <- function(token, period, calories_out=NULL, active_minutes=NULL, floors=NULL, distance=NULL, steps=NULL)
{
  #POST https://api.fitbit.com/1/user/[user-id]/activities/goals/[period].json
  url <- paste0(url_activity, sprintf("goals/%s.json", period))
  post_arguments <- c("calories_out", "active_minutes", "floors", "distance", "steps")
  body <- purrr::map(rlang::set_names(post_arguments), ~ rlang::eval_tidy(rlang::sym(.x)))
  names(body) <- stringr::str_replace_all(names(body), "(_)([a-z])", function(x){stringr::str_to_upper(stringr::str_sub(x, 2))})
  tidy_output(post(url, token, body), simplify=TRUE)
}

#' @title Get Lifetime Stats
#'
#' @description
#'   \code{get_lifetime_stats()} retrieves the user's activity statistics.
#'   Activity statistics includes Lifetime and Best achievement values from the My Achievements tile on the website dashboard.
#'   Response contains both statistics from the tracker device and total numbers including tracker data and manual activity log entries as seen on the Fitbit website dashboard.
#'
#' @inheritParams inheritparams_token
#' @inheritParams inheritparams_simplify
#'
#' @details
#' See \url{https://dev.fitbit.com/reference/web-api/activity/#get-lifetime-stats} for more details.
#'
#' @export
get_lifetime_stats <- make_get_function(paste0(url_api, "activities.json"))
