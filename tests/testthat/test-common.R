context("common")

test_that("format_date works", {
  expect_equal(format_date(as.Date("2014-7-11")), "2014-07-11")
  expect_equal(format_date("2014-7-11"), "2014-7-11")
  expect_equal(format_date("today"), "today")
})

test_that("to_posixct works", {
  answer <- as.POSIXct(strptime("2016-03-21 23:21:22", "%Y-%m-%d %H:%M:%S"))
  expect_equal(to_posixct("2016-03-21T23:21:22"), answer)
  expect_equal(to_posixct("2016-03-21T23:21:22.2121"), answer)
  expect_equal(to_posixct("2016-03-21", "23:21:22"), answer)
})

