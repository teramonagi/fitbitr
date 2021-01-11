#' @title Generate an oauth token for fitbit
#'
#' @description
#'   Generate an oauth token for fitbit.
#'   To get key and secret, You have to register your own information on https://dev.fitbit.com/jp.
#'
#' @param key Client key
#' @param secret Secret key
#' @param callback Callback URL configured by your own
#' @param locale Locales which is suitable for displaying a translated response if available.
#'   Possible values: c(en_AU | fr_FR | de_DE | ja_JP | en_NZ | es_ES | en_GB | en_US)
#' @param language The unit systems of values.
#'   Possible values: c(en_US | en_GB | other )
#' @param use_basic_auth Fitbit currently uses HTTR's basic_auth setting (so set to TRUE)
#' @param auth_page_query_params Additional URI Paramters, e.g.
#'   expires_in: c(86400, 604800, 2592000, 31536000)
#'   prompt: c("none", "consent", "login", "login consent")
#'   see https://dev.fitbit.com/build/reference/web-api/oauth2/ for full list
#' @details
#'   See \url{https://dev.fitbit.com/reference/web-api/basics/#language} for more details.
#'
#' @export
oauth_token <- function(key=NULL, secret=NULL, callback=NULL, locale=NULL, language=NULL, use_basic_auth=TRUE, auth_page_query_params=list(prompt="none"))
{
  #Load key automatically from global or environmnt variable
  keys <- tidy_key_and_secret(key, secret)

  #Load redirect URI from global or environment variable
  callback <- tidy_callback(callback)

  # We need to create header, see the following links in details.
  # https://community.fitbit.com/t5/Web-API-Development/Invalid-authorization-header-format/td-p/1363901
  # https://community.fitbit.com/t5/Web-API-Development/Trouble-with-OAuth-2-0-Tutorial/m-p/1617571#M6583
  header <- httr::add_headers(Authorization=paste0("Basic ", RCurl::base64Encode(charToRaw(paste0(keys$key, ":", keys$secret)))))
  content_type <- httr::content_type("application/x-www-form-urlencoded")

  # What types of data do we allow to access -> as possible as we can
  scope <- c("sleep", "activity", "heartrate", "location", "nutrition", "profile", "settings", "social", "weight")

  endpoint <- create_endpoint()
  myapp <- httr::oauth_app("r-package", key=keys$key, secret=keys$secret, redirect_uri=callback)
  list(
    token=httr::oauth2.0_token(endpoint, myapp, scope=scope, use_basic_auth=use_basic_auth, config_init=c(header, content_type), cache=FALSE, query_authorize_extra=auth_page_query_params),
    locale=locale,
    language=language
  )
}

create_endpoint <- function()
{
  request <- "https://api.fitbit.com/oauth2/token"
  authorize <- "https://www.fitbit.com/oauth2/authorize"
  access <- "https://api.fitbit.com/oauth2/token"
  httr::oauth_endpoint(request, authorize, access)
}

tidy_key_and_secret <- function(key, secret)
{
  if((is.null(key) && !is.null(secret)) || (!is.null(key) && is.null(secret))){
    stop("Both of key and secret must be given.")
  }

  if(is.null(key) && is.null(secret)){
    if(Sys.getenv("FITBIT_KEY") != "" && Sys.getenv("FITBIT_SECRET") != ""){
      # Found in environment variables
      key <- Sys.getenv("FITBIT_KEY")
      secret <- Sys.getenv("FITBIT_SECRET")
    } else if (exists("FITBIT_KEY") && exists("FITBIT_SECRET")){
      # Found in global variables
      key    <- FITBIT_KEY
      secret <- FITBIT_SECRET
    } else{
      stop("You must specify your key and secret.")
    }
  }
  list(key=key, secret=secret)
}

tidy_callback <- function(callback)
{
  if(is.null(callback)){
    if(Sys.getenv("FITBIT_CALLBACK") != ""){
      Sys.getenv("FITBIT_CALLBACK")
    } else if(exists("FITBIT_CALLBACK")){
      FITBIT_CALLBACK
    } else{
      "http://localhost:1410/"
    }
  } else{
    callback
  }
}
