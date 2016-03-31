# fitbitr [![CRAN Version](http://www.r-pkg.org/badges/version/fitbitr)](http://cran.rstudio.com/web/packages/fitbitr) ![](http://cranlogs.r-pkg.org/badges/grand-total/fitbitr)

fitbit

## Installation

fitbitr isn't available from CRAN yet, but you can get it from github with:

```R
# install.packages("devtools")
devtools::install_github("teramonagi/fitbitr")
```


## Example

### Activity
- https://dev.fitbit.com/docs/activity/

### Body & Weight
- https://dev.fitbit.com/docs/body/

### Devices 
- https://dev.fitbit.com/docs/devices/

### Food Logging
- https://dev.fitbit.com/docs/food-logging/

### Friends
- https://dev.fitbit.com/docs/friends/

### Heart Rate
- https://dev.fitbit.com/docs/heart-rate/
```R
#Load library
library("fitbitr")
```

### Sleep
- https://dev.fitbit.com/docs/sleep/

```R
#Load library
library("fitbitr")

#Get token
token <- oauth_token()

# Get Sleep Logs(date is character or Date)
x <- get_sleep_logs(token, "2016-03-30")
x <- get_sleep_logs(token, Sys.Date()-2)
x$sleep
x$summary

#Get the current sleep goal.
get_sleep_goal(token)
#Update sleep goal
update_sleep_goal(token, 377)

#Get Sleep Time Series
get_sleep_time_series(token, "timeInBed", date="2016-03-30", period="7d")
```

### Subscriptions
- https://dev.fitbit.com/docs/subscriptions/

### User
- https://dev.fitbit.com/docs/user/

## Contributing
- Fork it ( https://github.com/teramonagi/RODBCDBI/fork )
- Create your feature branch (git checkout -b my-new-feature)
- Commit your changes (git commit -am 'Add some feature')
- Push to the branch (git push origin my-new-feature)
- Create a new Pull Request

## Acknowledgements

Many thanks to Mi.dichika since This package is based on the extension of [myFitbit package](https://github.com/dichika/myFitbit).
