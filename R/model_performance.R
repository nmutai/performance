#' @title Model Performance
#' @name model_performance
#'
#' @description See the documentation for your object's class:
#' \itemize{
#'   \item \link[=model_performance.lm]{Frequentist Regressions}
#'   \item \link[=model_performance.merMod]{Mixed models}
#'   \item \link[=model_performance.stanreg]{Bayesian models}
#'   \item \link[=model_performance.lavaan]{CFA / SEM lavaan models}
#' }
#' \code{compare_performance()} computes indices of model performance for
#' different models at once and hence allows comparison of indices across models.
#'
#' @param model Statistical model.
#' @param metrics Can be \code{"all"} or a character vector of metrics to be computed.
#'   See related documentation of object's class for details.
#' @param rank Logical, if \code{TRUE}, models are ranked according to "best overall
#'   model performance". See 'Details'.
#' @param ... Arguments passed to or from other methods, resp. for
#'   \code{compare_performance()}, one or multiple model objects (also of
#'   different classes).
#'
#' @return For \code{model_performance()}, a data frame (with one row) and one
#'   column per "index" (see \code{metrics}). For \code{compare_performance()},
#'   the same data frame with one row per model.
#'
#' @details \subsection{Bayes factor for Model Comparison}{
#'   If all models were fit from the same data, \code{compare_performance()}
#'   returns an additional column named \code{BF}, which shows the Bayes factor
#'   (see \code{\link[bayestestR]{bayesfactor_models}}) for each model against
#'   the denominator model. The \emph{first} model is used as denominator model,
#'   and its Bayes factor is set to \code{NA} to indicate the reference model.
#'   }
#'   \subsection{Ranking Models}{
#'   When \code{rank = TRUE}, a new column \code{Performance_Score} is returned. This
#'   score ranges from 0\% to 100\%, higher values indicating better model performance.
#'   Calculation is based on normalizing all indices (i.e. rescaling them to a
#'   range from 0 to 1), and taking the mean value of all indices for each model.
#'   This is a rather quick heuristic, but might be helpful as exploratory index.
#'   \cr \cr
#'   In particular when models are of different types (e.g. mixed models, classical
#'   linear models, logistic regression, ...), not all indices will be computed
#'   for each model. In case where an index can't be calculated for a specific
#'   model type, this model gets an \code{NA} value. All indices that have any
#'   \code{NA}s are excluded from calculating the performance score.
#'   \cr \cr
#'   There is a \code{plot()}-method for \code{compare_performance()},
#'   which creates a "spiderweb" plot, where the different indices are
#'   normalized and larger values indicate better model performance.
#'   Hence, points closer to the center indicate worse fit indices
#'   (see \href{https://easystats.github.io/see/articles/performance.html}{online-documentation}
#'   for more details).
#'   }
#'
#' @examples
#' library(lme4)
#'
#' m1 <- lm(mpg ~ wt + cyl, data = mtcars)
#' model_performance(m1)
#'
#' m2 <- glm(vs ~ wt + mpg, data = mtcars, family = "binomial")
#' m3 <- lmer(Petal.Length ~ Sepal.Length + (1 | Species), data = iris)
#' compare_performance(m1, m2, m3)
#'
#' data(iris)
#' lm1 <- lm(Sepal.Length ~ Species, data = iris)
#' lm2 <- lm(Sepal.Length ~ Species + Petal.Length, data = iris)
#' lm3 <- lm(Sepal.Length ~ Species * Petal.Length, data = iris)
#' compare_performance(lm1, lm2, lm3)
#' compare_performance(lm1, lm2, lm3, rank = TRUE)
#' @export
model_performance <- function(model, ...) {
  UseMethod("model_performance")
}


#' @rdname model_performance
#' @export
performance <- model_performance
