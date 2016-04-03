has_error <- function(response)
{

}

get <- function(url, token)
{
  httr::GET(url=url, httr::config(token = token))
}

post <- function(url, token, body)
{
  httr::POST(url=url, body=body, httr::config(token = token))
}

convert_content_to_r_object <- function(response)
{
  jsonlite::fromJSON(httr::content(response, as = "text"))
}

format_date <- function(date){
  if(is.Date(date)){
    format(date, "%Y-%m-%d")
  }else{
    date
  }
}

to_posixct <- function(...)
{
  args <- unlist(list(...))
  if(length(args)==1){
    #regard as date_time
    as.POSIXct(strptime(str_replace(args[1], "\\.\\d+", ""), "%Y-%m-%dT%H:%M:%S"))
  } else if(length(args)==2){
    #regars as date, time
    as.POSIXct(strptime(paste0(args[1], " ", args[2]), "%Y-%m-%d %H:%M:%S"))
  } else{
    stop("Error")
  }
}
