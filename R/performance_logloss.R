#' @title Log Loss
#' @name performance_logloss
#'
#' @description Compute the log loss for models with binary outcome.
#'
#' @param model Model with binary outcome.
#' @param ... Currently not used.
#'
#' @return Numeric, the log loss of \code{model}.
#'
#' @details Logistic regression models predict the probability of an outcome of
#'   being a "success" or "failure" (or 1 and 0 etc.). \code{performance_logloss()} evaluates
#'   how good or bad the predicted probabilities are. High values indicate
#'   bad predictions, while low values indicate good predictions. The lower
#'   the log-loss, the better the model predicts the outcome.
#'
#' @examples
#' data(mtcars)
#' m <- glm(formula = vs ~ hp + wt, family = binomial, data = mtcars)
#' performance_logloss(m)
#'
#' @importFrom stats fitted
#' @importFrom insight get_response
#' @export
performance_logloss <- function(model, ...) {
  UseMethod("performance_logloss")
}


#' @export
performance_logloss.default <- function(model, ...) {
  mean(log(1 - abs(insight::get_response(model) - stats::fitted(model))) * -1)
}


#' @export
performance_logloss.brmsfit <- function(model, ...) {
  yhat <- stats::fitted(object = model, summary = TRUE, ...)[, "Estimate"]
  mean(log(1 - abs(insight::get_response(model) - yhat)) * -1)
}