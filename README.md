
<!-- README.md is generated from README.Rmd. Please edit that file -->
fitbitr
=======

![](https://travis-ci.org/teramonagi/fitbitr.svg?branch=master) [![CRAN Version](http://www.r-pkg.org/badges/version/fitbitr)](http://cran.rstudio.com/web/packages/fitbitr) ![](http://cranlogs.r-pkg.org/badges/grand-total/fitbitr)

`fitbitr` package allows users to interact with Fitbit data in R using Fitbit API.

This package allows for most of the read and write methods that you might want to use.

Installation
------------

fitbitr isn't available from CRAN yet, but you can get it from github with:

``` r
# install.packages("devtools")
devtools::install_github("teramonagi/fitbitr")
```

Preparation
-----------

### API key

To get your own token (API key), you have to register your own application in [here](https://dev.fitbit.com/apps/new). For your reference, we share our setting:

![](man/figures/register_app.png)

After registration, you can get your own `FITBIT_KEY` and `FITBIT_SECRET` (referred to as **OAuth 2.0 Client ID** and **Client Secret** in the next figure).

![](man/figures/manage_my_apps.png)

If you set the following variables as a global variable, this package use these values for API key.

``` r
# As a global variable
FITBIT_KEY    <- "<your-fitbit-key>"
FITBIT_SECRET <- "<your-firbit-secret>"
# If you want, Default: "http://localhost:1410/"
# FITBIT_CALLBACK <- "<your-fitbit-callback>" 
```

### Load libraries

``` r
library("ggplot2") # for visualization in this document
library("fitbitr")
```

### Get Fitbit API token

You can get your Fitbit toekn using `fitbitr::oauth_token()`:

``` r
# Get token
token <- fitbitr::oauth_token()
```

This function open a web browser autmatically and return Fitbit token.

How to use
----------

### Activity

``` r
# Example date
date <- "2016-06-01"

# Get activity intraday time series
# You have to use a **personal** key and secret.
df <- get_activity_intraday_time_series(token, "steps", date, detail_level="15min")
ggplot(df, aes(x=time, y=value)) + geom_line()
```

![](man/figures/README-unnamed-chunk-7-1.png)

You can find more details in [here](https://dev.fitbit.com/docs/activity/)

### Heart Rate

``` r
# Set a date for example
date <- "2016-04-01"

# Get heart rate time series
df <- get_heart_rate_time_series(token, date=date, period="7d")
#> Warning in bind_rows_(x, .id): binding factor and character vector,
#> coercing into character vector
#> Warning in bind_rows_(x, .id): binding character and factor vector,
#> coercing into character vector
ggplot(df, aes(x=date, y=peak_max)) + geom_line()
```

![](man/figures/README-unnamed-chunk-8-1.png)

``` r

# Get intraday heart rate time series
df <- get_heart_rate_intraday_time_series(token, date="2016-05-05", detail_level="15min")
ggplot(df, aes(x=time, y=value)) + geom_line()
```

![](man/figures/README-unnamed-chunk-8-2.png)

You can find more details [here](https://dev.fitbit.com/docs/heart-rate/).

### Sleep

``` r
# Get Sleep Logs(date is character or Date)
x <- get_sleep_logs(token, "2016-03-30")
print(head(x$sleep))
#>   awakeCount awakeDuration awakeningsCount dateOfSleep duration efficiency
#> 1          0             0              14  2016-03-30 21420000         55
#> 2          0             0              14  2016-03-30 21420000         55
#> 3          0             0              14  2016-03-30 21420000         55
#> 4          0             0              14  2016-03-30 21420000         55
#> 5          0             0              14  2016-03-30 21420000         55
#> 6          0             0              14  2016-03-30 21420000         55
#>                   endTime isMainSleep       logId minutesAfterWakeup
#> 1 2016-03-30T04:06:30.000        TRUE 11255066551                  0
#> 2 2016-03-30T04:06:30.000        TRUE 11255066551                  0
#> 3 2016-03-30T04:06:30.000        TRUE 11255066551                  0
#> 4 2016-03-30T04:06:30.000        TRUE 11255066551                  0
#> 5 2016-03-30T04:06:30.000        TRUE 11255066551                  0
#> 6 2016-03-30T04:06:30.000        TRUE 11255066551                  0
#>   minutesAsleep minutesAwake minutesToFallAsleep restlessCount
#> 1           197          160                   0            14
#> 2           197          160                   0            14
#> 3           197          160                   0            14
#> 4           197          160                   0            14
#> 5           197          160                   0            14
#> 6           197          160                   0            14
#>   restlessDuration           startTime timeInBed            dateTime value
#> 1              160 2016-03-29 22:09:30       357 2016-03-30 22:09:30     1
#> 2              160 2016-03-29 22:09:30       357 2016-03-30 22:10:30     2
#> 3              160 2016-03-29 22:09:30       357 2016-03-30 22:11:30     1
#> 4              160 2016-03-29 22:09:30       357 2016-03-30 22:12:30     1
#> 5              160 2016-03-29 22:09:30       357 2016-03-30 22:13:30     1
#> 6              160 2016-03-29 22:09:30       357 2016-03-30 22:14:30     2
x$summary
#>   totalMinutesAsleep totalSleepRecords totalTimeInBed
#> 1                197                 1            357

#Get the current sleep goal.
get_sleep_goal(token)
#>   awakeRestlessPercentage flowId recommendedSleepGoal typicalDuration
#> 1               0.5431424      0                  420             397
#>   typicalWakeupTime minDuration           updatedOn
#> 1             07:12         380 2017-12-16 09:38:03
#Update sleep goal
update_sleep_goal(token, 380)
#>   minDuration           updatedOn
#> 1         380 2017-12-16 10:50:32

#Get Sleep Time Series
get_sleep_time_series(token, "timeInBed", date="2016-04-02", period="7d")
#>     dateTime value
#> 1 2016-03-27     0
#> 2 2016-03-28     0
#> 3 2016-03-29   714
#> 4 2016-03-30   357
#> 5 2016-03-31   552
#> 6 2016-04-01   326
#> 7 2016-04-02   434
get_sleep_time_series(token, "efficiency", base_date="2016-03-30", end_date="2016-03-30")
#>     dateTime value
#> 1 2016-03-30    55

#Log sleep
log <- log_sleep(token, "22:00", 180, date="2010-04-18")
print(head(log))
#>   awakeCount awakeDuration awakeningsCount dateOfSleep duration efficiency
#> 1          0             0               0  2010-04-19 10800000        100
#> 2          0             0               0  2010-04-19 10800000        100
#> 3          0             0               0  2010-04-19 10800000        100
#> 4          0             0               0  2010-04-19 10800000        100
#> 5          0             0               0  2010-04-19 10800000        100
#> 6          0             0               0  2010-04-19 10800000        100
#>                   endTime isMainSleep       logId minuteData.dateTime
#> 1 2010-04-19T01:00:00.000       FALSE 16592604789            22:00:00
#> 2 2010-04-19T01:00:00.000       FALSE 16592604789            22:01:00
#> 3 2010-04-19T01:00:00.000       FALSE 16592604789            22:02:00
#> 4 2010-04-19T01:00:00.000       FALSE 16592604789            22:03:00
#> 5 2010-04-19T01:00:00.000       FALSE 16592604789            22:04:00
#> 6 2010-04-19T01:00:00.000       FALSE 16592604789            22:05:00
#>   minuteData.value minutesAfterWakeup minutesAsleep minutesAwake
#> 1                1                  0           180            0
#> 2                1                  0           180            0
#> 3                1                  0           180            0
#> 4                1                  0           180            0
#> 5                1                  0           180            0
#> 6                1                  0           180            0
#>   minutesToFallAsleep restlessCount restlessDuration
#> 1                   0             0                0
#> 2                   0             0                0
#> 3                   0             0                0
#> 4                   0             0                0
#> 5                   0             0                0
#> 6                   0             0                0
#>                 startTime timeInBed
#> 1 2010-04-18T22:00:00.000       180
#> 2 2010-04-18T22:00:00.000       180
#> 3 2010-04-18T22:00:00.000       180
#> 4 2010-04-18T22:00:00.000       180
#> 5 2010-04-18T22:00:00.000       180
#> 6 2010-04-18T22:00:00.000       180

#Delete sleep log
delete_sleep_log(token, log$logId)
```

You can find more details [here](https://dev.fitbit.com/docs/sleep/).

### Devices

``` r
# Get deice information you registerd
get_devices(token)
#>   battery deviceVersion features        id        lastSyncTime
#> 1  Medium       Alta HR     NULL 424040354 2017-11-28 15:12:39
#>            mac    type
#> 1 9F1F7466C3DA TRACKER

# Add alarms
tracker_id <- get_devices(token)$id[1]
add_alarm(token, tracker_id, "07:15-08:00", "MONDAY")
#>     alarmId deleted enabled recurring snoozeCount snoozeLength
#> 1 557227733   FALSE    TRUE     FALSE           3            9
#>   syncedToDevice        time    vibe weekDays
#> 1          FALSE 00:15+09:00 DEFAULT
alarm <- get_alarms(token, tracker_id)
alarm
#>     alarmId deleted enabled recurring snoozeCount snoozeLength
#> 1 471178121   FALSE   FALSE      TRUE           3            9
#> 2 557227733   FALSE    TRUE     FALSE           3            9
#>   syncedToDevice        time    vibe
#> 1           TRUE 05:03+09:00 DEFAULT
#> 2          FALSE 00:15+09:00 DEFAULT
#>                                       weekDays
#> 1 MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY
#> 2

# Update the content alarm
alarm_id <- tail(alarm, 1)$alarmId
update_alarm(token, tracker_id, alarm_id, "02:15-03:00", "FRIDAY")
#>     alarmId deleted enabled recurring snoozeCount snoozeLength
#> 1 557227733   FALSE    TRUE     FALSE           9            3
#>   syncedToDevice        time    vibe weekDays
#> 1          FALSE 14:15+09:00 DEFAULT
get_alarms(token, tracker_id)
#>     alarmId deleted enabled recurring snoozeCount snoozeLength
#> 1 471178121   FALSE   FALSE      TRUE           3            9
#> 2 557227733   FALSE    TRUE     FALSE           9            3
#>   syncedToDevice        time    vibe
#> 1           TRUE 05:03+09:00 DEFAULT
#> 2          FALSE 14:15+09:00 DEFAULT
#>                                       weekDays
#> 1 MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY
#> 2

# Delete alarm you registered here
delete_alarm(token, tracker_id, alarm_id)
#> Response [https://api.fitbit.com/1/user/-/devices/tracker/424040354/alarms/557227733.json]
#>   Date: 2017-12-16 10:50
#>   Status: 204
#>   Content-Type: application/json;charset=UTF-8
#> <EMPTY BODY>
get_alarms(token, tracker_id)
#>     alarmId deleted enabled recurring snoozeCount snoozeLength
#> 1 471178121   FALSE   FALSE      TRUE           3            9
#>   syncedToDevice        time    vibe
#> 1           TRUE 05:03+09:00 DEFAULT
#>                                       weekDays
#> 1 MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY
```

You can find more details [here](https://dev.fitbit.com/docs/devices/).

Contributing
------------

-   Fork it ( <https://github.com/teramonagi/fitbitr/fork> )
-   Create your feature branch (git checkout -b my-new-feature)
-   Commit your changes (git commit -am 'Add some feature')
-   Push to the branch (git push origin my-new-feature)
-   Create a new Pull Request

Acknowledgements
----------------

Many thanks to Mr.dichika since This package is based on the extension of [myFitbit package](https://github.com/dichika/myFitbit).

<!--
Future implementation
### Food Logging
You can find more details [here](https://dev.fitbit.com/docs/food-logging/).
### Friends
You can find more details [here](https://dev.fitbit.com/docs/friends/).

### Subscriptions
- https://dev.fitbit.com/docs/subscriptions/

### User
- https://dev.fitbit.com/docs/user/
### Body & Weight
You can find more details in [here](https://dev.fitbit.com/docs/body/)

-->
