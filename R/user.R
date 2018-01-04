#' @title Get Profile
#'
#' @description
#'   \code{get_profile()} returns a user's profile.
#'
#' @inheritParams inheritparams_token
#' @inheritParams inheritparams_simplify
#'
#' @details
#' See \url{https://dev.fitbit.com/reference/web-api/user/#get-profile} for more details.
#'
#' @export
get_profile <- make_get_function(paste0(url_api, "profile.json"))
