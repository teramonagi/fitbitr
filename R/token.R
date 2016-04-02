#' Generate an oauth token for fitbit.
#'
#' @export
oauth_token <- function(key=NULL, secret=NULL){
  key    <- "227PR5"
  secret <- "1fd7531d9f583a222b9653997f437319"
  request <- "https://api.fitbit.com/oauth2/token"
  authorize <- "https://www.fitbit.com/oauth2/authorize"
  access <- "https://api.fitbit.com/oauth2/token"
  endpoint <- httr::oauth_endpoint(request, authorize, access)
  myapp <- httr::oauth_app("r-package", key, secret)
  scope <- c("sleep", "activity", "heartrate", "location", "nutrition", "profile", "settings", "social", "weight")
  httr::oauth2.0_token(endpoint, myapp, scope=scope, use_basic_auth=TRUE, cache=FALSE)
}
