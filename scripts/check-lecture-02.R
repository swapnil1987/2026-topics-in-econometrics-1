# Deterministic algebra and numerical checks; no simulated-coverage thresholds.
# Run from the repository root or scripts/ with the topics-econometrics R.
source_candidates <- c("R/lecture-02.R", "../R/lecture-02.R")
source_path <- source_candidates[file.exists(source_candidates)][1]
if (is.na(source_path)) stop("Run from the repository root or scripts/.")

assert_close <- function(actual, expected, tolerance = 1e-10) {
  stopifnot(isTRUE(all.equal(
    unname(actual), unname(expected), tolerance = tolerance,
    check.attributes = FALSE
  )))
}

assert_error <- function(expression) {
  stopifnot(inherits(tryCatch(force(expression), error = identity), "error"))
}

# Sourcing creates only functions and does not consume random draws.
set.seed(20260909)
rng_before_source <- .Random.seed
helpers <- new.env(parent = globalenv())
sys.source(source_path, envir = helpers)
stopifnot(identical(rng_before_source, .Random.seed))
stopifnot(all(vapply(as.list(helpers, all.names = TRUE), is.function, logical(1))))
source(source_path)

examples <- lecture2_examples(seed = 20260909)
stopifnot(identical(examples, lecture2_examples(seed = 20260909)))
stopifnot(identical(names(examples), c("school_data", "hand_data", "dgp")))
school <- examples$school_data
hand <- examples$hand_data
stopifnot(nrow(school) == 400, all(school$class_size %in% 18:35))
stopifnot(identical(school$small_class, as.integer(school$class_size <= 25)))
assert_close(school$conditional_mean, 95 - 0.6 * school$class_size)
assert_close(school$error_sd, rep(8, 400))
assert_close(examples$dgp$population_mean, 79.1)
# Variance of a discrete uniform variable on 18 consecutive integers.
assert_close(examples$dgp$population_sd^2, 0.6^2 * (18^2 - 1) / 12 + 64)

fit <- lecture2_ols_by_sums(hand$x, hand$y)
reference <- lm(y ~ x, data = hand)
assert_close(fit$coefficients, c(2.2, 0.6))
assert_close(fit$coefficients, coef(reference))
assert_close(fit$fitted, fitted(reference))
assert_close(fit$residuals, residuals(reference))
assert_close(c(fit$sxx, fit$sxy), c(10, 6))
assert_close(c(fit$tss, fit$ess, fit$rss, fit$r_squared), c(6, 3.6, 2.4, 0.6))

# Check OLS identities on both the small hand example and the school sample.
for (data in list(hand, data.frame(x = school$class_size, y = school$score))) {
  fit <- lecture2_ols_by_sums(data$x, data$y)
  assert_close(fit$coefficients, coef(lm(y ~ x, data = data)))
  assert_close(sum(fit$residuals), 0)
  assert_close(sum((data$x - mean(data$x)) * fit$residuals), 0)
  assert_close(sum(fit$fitted * fit$residuals), 0, tolerance = 1e-7)
  assert_close(fit$tss, fit$ess + fit$rss)
}

dummy_fit <- lecture2_ols_by_sums(school$small_class, school$score)
group_zero <- mean(school$score[school$small_class == 0])
group_one <- mean(school$score[school$small_class == 1])
assert_close(dummy_fit$coefficients, c(group_zero, group_one - group_zero))

# Independent numerical reference values: z = +/- 2, two-sided p and 95% CI.
inference <- lecture2_z_summary(102, 1, null_value = 100)
assert_close(inference$z_statistic, 2)
assert_close(inference$p_value, 0.0455002638963584)
assert_close(c(inference$conf_low, inference$conf_high),
             c(100.04003601545995, 103.95996398454005))
assert_close(lecture2_z_summary(98, 1, 100)$p_value, inference$p_value)
assert_close(lecture2_z_summary(100, 1, 100)$p_value, 1)
interval_90 <- lecture2_z_summary(0, 1, level = 0.90)
assert_close(c(interval_90$conf_low, interval_90$conf_high),
             c(-1.64485362695147, 1.64485362695147))

# Compare homoskedastic SE to lm and HC1 to the matrix sandwich (base R only).
heteroskedastic <- lecture2_examples(seed = 20260909, heteroskedastic = TRUE)
assert_close(heteroskedastic$school_data$error_sd,
             4 + 0.3 * (heteroskedastic$school_data$class_size - 18))
for (data in list(hand, data.frame(
  x = heteroskedastic$school_data$class_size, y = heteroskedastic$school_data$score
))) {
  reference <- lm(y ~ x, data = data)
  standard_errors <- lecture2_slope_se(data$x, data$y)
  stopifnot(identical(names(standard_errors), c("homoskedastic", "hc1")))
  assert_close(standard_errors$homoskedastic, summary(reference)$coefficients[2, 2])
  design <- model.matrix(reference)
  bread <- solve(crossprod(design))
  meat <- crossprod(design, design * as.numeric(residuals(reference)^2))
  sandwich <- nrow(design) / (nrow(design) - ncol(design)) * bread %*% meat %*% bread
  assert_close(standard_errors$hc1, sqrt(sandwich[2, 2]))
}

# Exact finite-distribution verification of conditional prediction risk.
# Five fixed training x values, independent errors taking -8/+8 with equal
# probability: enumerate all 2^5 possible training samples, not random draws.
# OLS's variance formula needs error moments and independence, not normality.
training_x <- c(18, 22, 26, 30, 34)
test_x <- c(18, 25, 26, 35)
error_patterns <- as.matrix(expand.grid(rep(list(c(-8, 8)), length(training_x))))
predictions <- t(apply(error_patterns, 1, function(training_errors) {
  training_y <- 95 - 0.6 * training_x + training_errors
  model <- lm(training_y ~ training_x)
  as.numeric(predict(model, newdata = data.frame(training_x = test_x)))
}))
truth <- 95 - 0.6 * test_x
exact_bias_squared <- (colMeans(predictions) - truth)^2
centered_predictions <- sweep(predictions, 2, colMeans(predictions), "-")
# All equally likely possibilities form the population: divide by B, not B-1.
exact_estimation_variance <- colMeans(centered_predictions^2)
error_if_low <- sweep(predictions, 2, truth - 8, "-")
error_if_high <- sweep(predictions, 2, truth + 8, "-")
exact_prediction_mse <- colMeans((error_if_low^2 + error_if_high^2) / 2)
risk <- lecture2_prediction_decomposition(test_x, training_x)
assert_close(risk$conditional_mean, truth)
assert_close(risk$bias_squared, exact_bias_squared)
assert_close(risk$estimation_variance, exact_estimation_variance)
assert_close(risk$mean_squared_prediction_error, exact_prediction_mse)
assert_close(risk$mean_squared_prediction_error,
             risk$noise_variance + risk$bias_squared + risk$estimation_variance)
# Estimation variance is minimized at the training mean; noise stays at 64.
assert_close(risk$estimation_variance[test_x == mean(training_x)], 64 / 5)
assert_close(risk$noise_variance, rep(64, length(test_x)))
# Repeat with a different DGP to check that supplied parameters are respected.
alternative <- lecture2_prediction_decomposition(26, training_x, 4, 10, 2)
assert_close(alternative$conditional_mean, 62)
assert_close(alternative$mean_squared_prediction_error, 16 + 16 / 5)

# Deterministic reproducibility/shape checks for optional simulation helpers.
# These do not assert that a finite Monte Carlo sample has nominal coverage.
coverage <- lecture2_mean_coverage(repetitions = 12)
stopifnot(identical(coverage, lecture2_mean_coverage(repetitions = 12)))
stopifnot(identical(coverage$covered, coverage$conf_low <= 80 & coverage$conf_high >= 80))
assert_close(coverage$conf_high - coverage$conf_low, rep(2 * qnorm(0.975) * 8 / sqrt(30), 12))
sampling <- lecture2_ols_sampling(training_x, repetitions = 4)
stopifnot(identical(names(sampling),
                    c("repetition", "intercept", "slope", "homoskedastic_se", "hc1_se")))
stopifnot(identical(sampling, lecture2_ols_sampling(training_x, repetitions = 4)))
set.seed(20260909)
first_y <- 95 - 0.6 * training_x + rnorm(length(training_x), sd = 8)
assert_close(unlist(sampling[1, c("intercept", "slope")]), coef(lm(first_y ~ training_x)))
stopifnot(nrow(lecture2_ols_sampling(training_x, repetitions = 1)) == 1)
stopifnot(nrow(lecture2_ols_sampling(training_x, repetitions = 2, error_sd = 4:8)) == 2)

# Undefined estimates should fail clearly instead of silently returning NaN.
assert_error(lecture2_ols_by_sums(c(1, 1, 1), 1:3))
assert_error(lecture2_ols_by_sums(1:3, c(1, NA, 2)))
assert_error(lecture2_ols_by_sums(1:3, 1:4))
assert_error(lecture2_slope_se(1:2, 2:3))
assert_error(lecture2_z_summary(1, 0))
assert_error(lecture2_z_summary(1, 1, level = 1))
assert_error(lecture2_prediction_decomposition(25, rep(25, 5)))
assert_error(lecture2_prediction_decomposition(25, training_x, error_sd = -1))
assert_error(lecture2_mean_coverage(n = 1.5))
assert_error(lecture2_ols_sampling(training_x, error_sd = c(4, 8)))
stopifnot(is.na(lecture2_ols_by_sums(1:3, rep(2, 3))$r_squared))

cat("Lecture 2 deterministic checks passed.\n")
