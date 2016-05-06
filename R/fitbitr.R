#' fitbitr
#'
#' Provides an API Access to fitbit API via R
#'
#' @name fitbitr
#' @docType package
#' @import stringr lubridate dplyr tidyr httr jsonlite data.table
url_base <- "https://api.fitbit.com/1/"
url_api  <- paste0(url_base, "user/-/")
