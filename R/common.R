has_error <- function(response)
{

}

get <- function(url, token)
{
  httr::GET(url=url, httr::config(token = token))
}

post <- function(url, token, body)
{
  httr::GET(url=url, body=body, httr::config(token = token))
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
