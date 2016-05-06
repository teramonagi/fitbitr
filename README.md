# fitbitr [![CRAN Version](http://www.r-pkg.org/badges/version/fitbitr)](http://cran.rstudio.com/web/packages/fitbitr) ![](http://cranlogs.r-pkg.org/badges/grand-total/fitbitr) ![](https://travis-ci.org/teramonagi/fitbitr.svg?branch=master)

fitbitr package allows users to interact with Fitbit data in R using Fitbit API.
This package allows for most of the read and write methods that you might want to use. 

## Installation
fitbitr isn't available from CRAN yet, but you can get it from github with:
```R
# install.packages("devtools")
devtools::install_github("teramonagi/fitbitr")
```

## API key
If you set the following variables as a global variable, this package use these values for API key.
```R
# As a global variable
FITBIT_KEY    <- "XXXX"
FITBIT_SECRET <- "XXXXXXXXXXXXXXXXXX"
```

The priority of these keys to 
## Example

### Activity
- https://dev.fitbit.com/docs/activity/

### Body & Weight
- https://dev.fitbit.com/docs/body/

```R
#Load library
library("fitbitr")

#Get token
token <- oauth_token()

# Set a date for example
date1 <- "2016-04-01"
date2 <- "2016-04-02"

# Log body fat
log_body_fat(token, 20.2, date1)
log_body_fat(token, 18.2, date2)

# Get body fat logs
get_body_fat_logs(token, date=date2, period="7d")
get_body_fat_logs(token, base_date=date1, end_date="today")

```

### Devices 
- https://dev.fitbit.com/docs/devices/

```R
#Load library
library("fitbitr")

#Get token
token <- oauth_token()

#Get deice information you registerd
get_devices(token)

#Add alarms
tracker_id <- get_devices(token)$id[1]
add_alarm(token, tracker_id, "07:15-08:00", "MONDAY")
alarm <- get_alarms(token, tracker_id)

#Update the content alarm
alarm_id <- tail(alarm, 1)$alarmId
update_alarm(token, tracker_id, alarm_id, "02:15-03:00", "FRIDAY")
get_alarms(token, tracker_id)

#Delete alarm you registered here
delete_alarm(token, tracker_id, alarm_id)
get_alarms(token, tracker_id)
```

### Food Logging
- https://dev.fitbit.com/docs/food-logging/

### Friends
- https://dev.fitbit.com/docs/friends/

### Heart Rate
- https://dev.fitbit.com/docs/heart-rate/
```R
#Load library
library("ggplot2")
library("fitbitr")
#Get token
token <- oauth_token()

# Set a date for example
date <- "2016-04-01"

# Get heart rate time series
get_heart_rate_time_series(token, date=date, period="7d")
get_heart_rate_time_series(token, base_date=date, end_date="today")
  
# Get intraday heart rate time series
df <- get_heart_rate_intraday_time_series(token, date="2016-05-05", detail_level="1min")
df <- get_heart_rate_intraday_time_series(token, date="2016-05-05", detail_level="1sec")
ggplot(df, aes(x=time, y=value)) + geom_line()
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
update_sleep_goal(token, 380)

#Get Sleep Time Series
get_sleep_time_series(token, "timeInBed", date="2016-04-02", period="7d")
get_sleep_time_series(token, "efficiency", base_date="2016-03-30", end_date="today")

#Log sleep
log_sleep(token, "22:00", 180, date="2010-02-17")

#Delete sleep log
delete_sleep_log(token, log_id)
```

### Subscriptions
- https://dev.fitbit.com/docs/subscriptions/

### User
- https://dev.fitbit.com/docs/user/

## Contributing
- Fork it ( https://github.com/teramonagi/fitbitr/fork )
- Create your feature branch (git checkout -b my-new-feature)
- Commit your changes (git commit -am 'Add some feature')
- Push to the branch (git push origin my-new-feature)
- Create a new Pull Request

## Acknowledgements

Many thanks to Mr.dichika since This package is based on the extension of [myFitbit package](https://github.com/dichika/myFitbit).
