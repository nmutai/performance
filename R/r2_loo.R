#' @title LOO-adjusted R2
#' @name r2_loo
#'
#' @description Compute LOO-adjusted R2.
#'
#' @param model A Bayesian regression model.
#'
#' @return The LOO-adjusted R2 for \code{model}, as numeric value.
#'
#' @details Unlike \code{\link{r2_bayes}}, which returns an "unadjusted" R2 value,
#'   \code{r2_loo()} calculates a LOO-adjusted R2, which comes conceptionally
#'   closer to an "adjusted" R2 measure.
#'
#' @examples
#' library(rstanarm)
#'
#' model <- stan_glm(mpg ~ wt + cyl, data = mtcars, chains = 1, iter = 500)
#' r2_loo(model)
#' @importFrom insight get_response find_algorithm
#' @importFrom stats var
#' @export
r2_loo <- function(model) {
  if (!requireNamespace("rstantools", quietly = TRUE)) {
    stop("Package `rstantools` needed for this function to work. Please install it.", call. = FALSE)
  }

  if (!requireNamespace("loo", quietly = TRUE)) {
    stop("Package `loo` needed for this function to work. Please install it.", call. = FALSE)
  }

  y <- insight::get_response(model)
  ypred <- rstantools::posterior_linpred(model)


  # for some weird models, not all response values can be
  # predicted, resulting in different lengths between y and ypred

  if (length(y) > ncol(ypred)) {
    tryCatch(
      {
        y <- y[as.numeric(attr(ypred, "dimnames")[[2]])]
      },
      error = function(x) {
        NULL
      }
    )
  }

  ll <- rstantools::log_lik(model)

  algorithm <- insight::find_algorithm(model)
  .n_chains <- algorithm$chains
  .n_samples <- (algorithm$iterations - algorithm$warmup) * algorithm$chains

  r_eff <- loo::relative_eff(
    exp(ll),
    chain_id = rep(1:.n_chains, each = .n_samples / .n_chains)
  )

  psis_object <- loo::psis(log_ratios = -ll, r_eff = r_eff)
  ypredloo <- loo::E_loo(ypred, psis_object, log_ratios = -ll)$value
  eloo <- ypredloo - y

  loor2 <- 1 - stats::var(eloo) / stats::var(y)

  names(loor2) <- "LOO-adjusted R2"
  loor2
}
