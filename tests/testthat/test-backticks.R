if (require("testthat") && require("performance")) {
  context("backticks")

  data(iris)
  iris$`a m` <- iris$Species
  iris$`Sepal Width` <- iris$Sepal.Width
  m1 <- lm(`Sepal Width` ~ Petal.Length + `a m` * log(Sepal.Length), data = iris)
  m2 <- lm(Sepal.Width ~ Petal.Length + Species * log(Sepal.Length), data = iris)

  test_that("check_collinearity, backticks", {
    expect_equal(check_collinearity(m1)$Parameter, c("Petal.Length", "a m", "log(Sepal.Length)", "a m:log(Sepal.Length)"))
    expect_equal(check_collinearity(m2)$Parameter, c("Petal.Length", "Species", "log(Sepal.Length)", "Species:log(Sepal.Length)"))
  })
}
