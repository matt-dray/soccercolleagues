test_df <- readRDS("test-data.rds")

test_that("fetching players takes correct input", {

  expect_error(get_players(1992, 1))
  expect_error(get_players(1992, c("England", "Scotland")))
  expect_error(get_players("x", "England"))

})

test_that("getting colleagues works", {

  x1 <- "Jihai Sun"
  x2 <- c("Shaun Wright-Phillips", "Bradley Wright-Phillips")

  x1_result <- get_colleagues(test_df, x1)
  x2_result <- get_colleagues(test_df, x2)

  expect_type(x1_result, "list")
  expect_length(names(x1_result), 12)

  expect_type(x2_result, "list")
  expect_length(names(x2_result), 12)

  expect_error(get_colleagues(test_df, 1))
  expect_error(get_colleagues(1, x1))

})

test_that("sampling colleagues works", {

  x1 <- "Jihai Sun"
  x2 <- c("Shaun Wright-Phillips", "Bradley Wright-Phillips")

  x1_result <- sample_colleagues(test_df, x1)
  x2_result <- sample_colleagues(test_df, x2)

  expect_type(x1_result, "character")
  expect_length(x1_result, 5)

  expect_type(x2_result, "character")
  expect_length(x2_result, 1)

  expect_error(sample_colleagues(test_df, 1))
  expect_error(sample_colleagues(1, x1))
  expect_error(sample_colleagues(test_df, x1, "x"))

})

test_that("app takes correct input", {

  expect_error(open_colleagues_quiz(1))

})
