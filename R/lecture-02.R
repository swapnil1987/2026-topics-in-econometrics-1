# Lecture 2: reusable simulated examples and calculations.
# Base R only. Sourcing this file defines functions without drawing random data.
# Random-data helpers set the supplied seed when called (and advance R's RNG).

.lecture2_numeric <- function(x, name, minimum_length = 1L) {
  if (!is.numeric(x) || !is.null(dim(x)) ||
      length(x) < minimum_length || any(!is.finite(x))) {
    stop(name, " must be a finite numeric vector of length >= ", minimum_length,
         call. = FALSE)
  }
}

.lecture2_scalar <- function(x, name, positive = FALSE) {
  .lecture2_numeric(x, name)
  if (length(x) != 1L || (positive && x <= 0)) {
    stop(name, " must be a single ", if (positive) "positive " else "",
         "finite number.", call. = FALSE)
  }
}

.lecture2_count <- function(x, name, minimum = 1L) {
  .lecture2_scalar(x, name)
  if (x < minimum || x != floor(x)) {
    stop(name, " must be an integer >= ", minimum, ".", call. = FALSE)
  }
}

# One row is a simulated classroom; score is its test-score outcome in points.
# Class size is drawn uniformly from the integers 18,...,35, independently of Z.
# score = 95 - 0.6 * class_size + error_sd(class_size) * Z; Z ~ N(0, 1).
# The default has iid homoskedastic errors with SD 8 points. The optional
# heteroskedastic DGP has SD 4 + 0.3 * (class_size - 18), still E[u | X] = 0.
# These imposed assumptions identify the slope inside this simulation;
# an observational class-size regression alone would not establish causality.
lecture2_examples <- function(seed = 20260909, n = 400,
                              heteroskedastic = FALSE) {
  .lecture2_count(n, "n", minimum = 3L)
  if (!is.logical(heteroskedastic) || length(heteroskedastic) != 1L ||
      is.na(heteroskedastic)) {
    stop("heteroskedastic must be TRUE or FALSE.", call. = FALSE)
  }
  set.seed(seed)
  class_sizes <- 18:35
  class_size <- sample(class_sizes, size = n, replace = TRUE)
  error_sd <- if (heteroskedastic) 4 + 0.3 * (class_size - 18) else rep(8, n)
  conditional_mean <- 95 - 0.6 * class_size
  school_data <- data.frame(
    class_size = class_size,
    small_class = as.integer(class_size <= 25),
    score = conditional_mean + rnorm(n, sd = error_sd),
    conditional_mean = conditional_mean,
    error_sd = error_sd
  )
  support_sd <- if (heteroskedastic) 4 + 0.3 * (class_sizes - 18) else 8
  list(
    school_data = school_data,
    hand_data = data.frame(x = 1:5, y = c(2, 4, 5, 4, 5)),
    dgp = list(
      intercept = 95, slope = -0.6, class_sizes = class_sizes,
      heteroskedastic = heteroskedastic,
      error_sd = if (heteroskedastic) NA_real_ else 8,
      population_mean = 95 - 0.6 * mean(class_sizes),
      population_sd = sqrt(
        0.6^2 * mean((class_sizes - mean(class_sizes))^2) + mean(support_sd^2)
      )
    )
  )
}

# Normal-reference, two-sided inference. This is exact for a normal mean with
# known population SD; using an estimated SE generally makes it approximate.
lecture2_z_summary <- function(estimate, standard_error, null_value = 0,
                               level = 0.95) {
  .lecture2_scalar(estimate, "estimate")
  .lecture2_scalar(standard_error, "standard_error", positive = TRUE)
  .lecture2_scalar(null_value, "null_value")
  .lecture2_scalar(level, "level")
  if (level <= 0 || level >= 1) stop("level must lie between 0 and 1.")
  z_statistic <- (estimate - null_value) / standard_error
  critical_value <- qnorm((1 + level) / 2)
  data.frame(
    estimate = estimate, standard_error = standard_error,
    null_value = null_value, level = level, z_statistic = z_statistic,
    p_value = 2 * pnorm(-abs(z_statistic)),
    conf_low = estimate - critical_value * standard_error,
    conf_high = estimate + critical_value * standard_error
  )
}

# Simple OLS with an intercept, using centered sums rather than lm().
# TSS = total SS; ESS = explained SS; RSS = residual SS.
lecture2_ols_by_sums <- function(x, y) {
  .lecture2_numeric(x, "x", minimum_length = 2L)
  .lecture2_numeric(y, "y", minimum_length = 2L)
  if (length(x) != length(y)) stop("x and y must have equal lengths.")
  centered_x <- x - mean(x)
  centered_y <- y - mean(y)
  sxx <- sum(centered_x^2)
  if (sxx == 0) stop("x must vary to identify a slope.")
  sxy <- sum(centered_x * centered_y)
  slope <- sxy / sxx
  intercept <- mean(y) - slope * mean(x)
  fitted <- intercept + slope * x
  residuals <- y - fitted
  tss <- sum(centered_y^2)
  rss <- sum(residuals^2)
  list(
    coefficients = c(intercept = intercept, slope = slope),
    n = length(x), mean_x = mean(x), mean_y = mean(y),
    sxx = sxx, sxy = sxy, fitted = fitted, residuals = residuals,
    tss = tss, ess = sum((fitted - mean(y))^2), rss = rss,
    r_squared = if (tss == 0) NA_real_ else 1 - rss / tss
  )
}

# Optional preview beyond formal Chapter 4: estimated slope standard errors.
# Both SEs assume independent observations. The homoskedastic formula assumes
# constant error variance. HC1 permits heteroskedasticity; neither handles
# clustering. HC1 uses the n / (n - 2) degrees-of-freedom correction.
lecture2_slope_se <- function(x, y) {
  fit <- lecture2_ols_by_sums(x, y)
  if (fit$n <= 2) stop("At least three observations are needed for slope SEs.")
  residual_variance <- fit$rss / (fit$n - 2)
  hc1_variance <- fit$n / (fit$n - 2) *
    sum((x - fit$mean_x)^2 * fit$residuals^2) / fit$sxx^2
  data.frame(homoskedastic = sqrt(residual_variance / fit$sxx), hc1 = sqrt(hc1_variance))
}

# Exact squared prediction-error decomposition for correctly specified OLS
# with a fixed training design, an intercept, and iid errors of known SD.
# This closed-form homoskedastic variance is an extension beyond Chapter 4's
# general prediction-error decomposition, not an additional basic assumption.
# At EACH fixed test x, average over new training errors and independent new u:
# E[(Y_new - yhat(x))^2 | training_x, x]
#   = Var(u_new | x) + Bias[yhat(x) | training_x, x]^2
#     + Var[yhat(x) | training_x, x].
# Variation of the true mean across different x values is not prediction noise.
lecture2_prediction_decomposition <- function(x, training_x, error_sd = 8,
                                              intercept = 95, slope = -0.6) {
  .lecture2_numeric(x, "x")
  .lecture2_numeric(training_x, "training_x", minimum_length = 2L)
  .lecture2_scalar(error_sd, "error_sd", positive = TRUE)
  .lecture2_scalar(intercept, "intercept")
  .lecture2_scalar(slope, "slope")
  sxx <- sum((training_x - mean(training_x))^2)
  if (sxx == 0) stop("training_x must vary to identify a slope.")
  estimation_variance <- error_sd^2 * (
    1 / length(training_x) + (x - mean(training_x))^2 / sxx
  )
  data.frame(
    x = x, conditional_mean = intercept + slope * x,
    noise_variance = error_sd^2, bias_squared = 0,
    estimation_variance = estimation_variance,
    mean_squared_prediction_error = error_sd^2 + estimation_variance
  )
}

# Optional repeated-sampling exercise: exact normal-mean z intervals, known SD.
# Returned coverage indicators are Monte Carlo draws, not a coverage guarantee.
lecture2_mean_coverage <- function(n = 30, repetitions = 1000,
                                   population_mean = 80, population_sd = 8,
                                   level = 0.95, seed = 20260909) {
  .lecture2_count(n, "n")
  .lecture2_count(repetitions, "repetitions")
  standard_error <- population_sd / sqrt(n)
  # Validate the inference inputs before drawing any samples.
  lecture2_z_summary(population_mean, standard_error, level = level)
  set.seed(seed)
  estimates <- replicate(repetitions, mean(rnorm(n, population_mean, population_sd)))
  margin <- qnorm((1 + level) / 2) * standard_error
  data.frame(
    repetition = seq_len(repetitions), estimate = estimates,
    conf_low = estimates - margin, conf_high = estimates + margin,
    covered = abs(estimates - population_mean) <= margin
  )
}

# Optional sampling distribution conditional on a fixed class-size design.
# error_sd may be a scalar or one SD per training observation (HC1 preview).
lecture2_ols_sampling <- function(training_x = rep(18:35, each = 5),
                                  repetitions = 1000, intercept = 95,
                                  slope = -0.6, error_sd = 8, seed = 20260909) {
  .lecture2_numeric(training_x, "training_x", minimum_length = 3L)
  .lecture2_count(repetitions, "repetitions")
  .lecture2_scalar(intercept, "intercept")
  .lecture2_scalar(slope, "slope")
  .lecture2_numeric(error_sd, "error_sd")
  if (!(length(error_sd) %in% c(1L, length(training_x))) || any(error_sd <= 0)) {
    stop("error_sd must be positive, with length 1 or length(training_x).")
  }
  if (sum((training_x - mean(training_x))^2) == 0) stop("training_x must vary.")
  set.seed(seed)
  draws <- replicate(repetitions, {
    y <- intercept + slope * training_x + rnorm(length(training_x), sd = error_sd)
    fit <- lecture2_ols_by_sums(training_x, y)
    standard_errors <- lecture2_slope_se(training_x, y)
    c(fit$coefficients, homoskedastic_se = standard_errors$homoskedastic,
      hc1_se = standard_errors$hc1)
  })
  data.frame(repetition = seq_len(repetitions), t(draws), row.names = NULL)
}
