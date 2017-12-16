has_error <- function(response)
{

}

check_response <- function(response)
{
  if(httr::http_error(response)){
    message <- paste0(httr::http_condition(response, "message"), httr::content(response, as="text"))
    stop(message)
  }
  response
}

get <- function(url, token)
{
  check_response(httr::GET(url=url, httr::config(token = token)))
}

post <- function(url, token, body)
{
  check_response(httr::POST(url=url, body=body, httr::config(token = token)))
}

delete <- function(url, token)
{
  check_response(httr::DELETE(url=url, httr::config(token = token)))
}

convert_content_to_r_object <- function(response)
{
  jsonlite::fromJSON(httr::content(response, as = "text"))
}

format_date <- function(date){
  if(lubridate::is.Date(date)){
    format(date, "%Y-%m-%d")
  }else{
    date
  }
}

to_posixct <- function(...)
{
  args <- list(...)
  if(length(args)==1){
    #regard as date_time
    as.POSIXct(strptime(stringr::str_replace(args[[1]], "\\.\\d+", ""), "%Y-%m-%dT%H:%M:%S"))
  } else if(length(args)==2){
    date <- as.Date(args[[1]])
    time <- args[[2]]
    diff_hour <- diff(as.numeric(stringr::str_sub(time, 1, 2)))
    date <- date + Reduce(function(x, y){(y < 0) + x}, diff_hour, 0, accumulate=TRUE)
    #regars as date, time
    as.POSIXct(strptime(paste0(date, " ", time), "%Y-%m-%d %H:%M:%S"))
  } else{
    stop("Error")
  }
}
