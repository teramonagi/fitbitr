#' @title Generate an oauth token for fitbit
#'
#' @description
#'   Generate an oauth token for fitbit.
#'   To get key and secret, You have to register your own information on https://dev.fitbit.com/jp.
#'
#' @param key client key
#' @param secret secret key
#' @param callback callback URL configured by your own
#'
#' @export
oauth_token <- function(key=NULL, secret=NULL, callback=NULL)
{
  if((is.null(key) && !is.null(secret)) || (!is.null(key) && is.null(secret))){
    stop("Both of key and secret must be given.")
  }

  #Load key automatically from global or environmnt variable
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

  #Load redirect URI from global or environment variable
  if(is.null(callback)){
    if(exists("FITBIT_CALLBACK")){
      callback <- FITBIT_CALLBACK
    } else{
      callback <- "http://localhost:1410/"
    }
  }

  # We need to create header, see the following links in details.
  # https://community.fitbit.com/t5/Web-API-Development/Invalid-authorization-header-format/td-p/1363901
  # https://community.fitbit.com/t5/Web-API-Development/Trouble-with-OAuth-2-0-Tutorial/m-p/1617571#M6583
  header <- httr::add_headers(Authorization=paste0("Basic ", RCurl::base64Encode(charToRaw(paste0(key, ":", secret)))))
  content_type <- httr::content_type("application/x-www-form-urlencoded")

  # What types of data do we allow to access -> as possible as we can
  scope <- c("sleep", "activity", "heartrate", "location", "nutrition", "profile", "settings", "social", "weight")

  endpoint <- create_endpoint()
  myapp <- httr::oauth_app("r-package", key=key, secret=secret, redirect_uri=callback)
  httr::oauth2.0_token(endpoint, myapp, scope=scope, config_init=c(header, content_type), cache=FALSE)
}

create_endpoint <- function()
{
  request <- "https://api.fitbit.com/oauth2/token"
  authorize <- "https://www.fitbit.com/oauth2/authorize"
  access <- "https://api.fitbit.com/oauth2/token"
  httr::oauth_endpoint(request, authorize, access)
}
