#' @title Mean Square Error of Linear Models
#' @name performance_mse
#'
#' @description Compute mean square error of linear models.
#'
#' @inheritParams performance_rmse
#' @inheritParams model_performance.lm
#'
#' @details The mean square error is the mean of the sum of squared residuals,
#'   i.e. it measures the average of the squares of the errors. Less technicaly
#'   speaking, the mean square error can be considered as the variance of the
#'   residuals, i.e. the variation in the outcome the model doesn't explain.
#'   Lower values (closer to zero) indicate better fit.
#'
#' @return Numeric, the mean square error of \code{model}.
#'
#' @examples
#' data(mtcars)
#' m <- lm(mpg ~ hp + gear, data = mtcars)
#' performance_mse(m)
#' @importFrom insight print_color
#' @importFrom stats residuals
#' @export
performance_mse <- function(model, verbose = TRUE) {
  res <- tryCatch(
    {
      if (inherits(model, c("vgam", "vglm"))) {
        model@residuals
      } else {
        stats::residuals(model)
      }
    },
    error = function(e) {
      NULL
    }
  )

  if (is.null(res) || all(is.na(res))) {
    if (verbose) insight::print_color("Can't extract residuals from model.\n", "red")
    return(NA)
  }

  mean(res^2, na.rm = T)
}


#' @rdname performance_mse
#' @export
mse <- performance_mse
