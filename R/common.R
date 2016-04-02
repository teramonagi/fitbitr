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

format_date_time <- function(date_time)
{
  as.POSIXct(strptime(str_replace(date_time, "\\.\\d+", ""), "%Y-%m-%dT%H:%M:%S"))
}
format_time_string <- function(date, time)
{
  as.POSIXct(strptime(paste0(date, " ", time), "%Y-%m-%d %H:%M:%S"))
}
