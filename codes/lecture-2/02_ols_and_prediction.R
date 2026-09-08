# Lecture 2: OLS by hand and prediction error
# Classroom question: What does the fitted line explain, and what remains uncertain?

# Run from the repository root or from codes/lecture-2.
source_candidates <- c("R/lecture-02.R", "../../R/lecture-02.R")
source_path <- source_candidates[file.exists(source_candidates)][1]
if (is.na(source_path)) stop("Run from the repository root or codes/lecture-2.")
source(source_path)
library(ggplot2)

examples <- lecture2_examples(seed = 20260909)
hand_data <- examples$hand_data
school_data <- examples$school_data

# Work out the five-point example before looking at lm().
hand_data$centered_x <- hand_data$x - mean(hand_data$x)
hand_data$centered_y <- hand_data$y - mean(hand_data$y)
hand_data$cross_product <- hand_data$centered_x * hand_data$centered_y
hand_data$squared_x <- hand_data$centered_x^2
print(hand_data)
hand_fit <- lecture2_ols_by_sums(hand_data$x, hand_data$y)
print(hand_fit$coefficients)  # intercept = 2.2; slope = 0.6
print(coef(lm(y ~ x, data = hand_data)))

# With an intercept, residuals sum to zero and are orthogonal to x.
# TSS = ESS + RSS: total = explained + residual sum of squares.
print(c(
  residual_sum = sum(hand_fit$residuals),
  x_residual_sum = sum(hand_data$x * hand_fit$residuals),
  TSS = hand_fit$tss, ESS = hand_fit$ess, RSS = hand_fit$rss
))

# In the simulated DGP, E[score | class_size] = 95 - 0.6 * class_size.
school_model <- lm(score ~ class_size, data = school_data)
print(coef(school_model))
# The DGP imposes E[u | class_size] = 0. Real observational data would require
# an identification argument before treating this association as causal.

school_plot <- ggplot(school_data, aes(class_size, score)) +
  geom_point(alpha = 0.25, colour = "#242424") +
  geom_abline(intercept = 95, slope = -0.6, linetype = "dashed", linewidth = 1) +
  geom_abline(
    intercept = unname(coef(school_model)[1]),
    slope = unname(coef(school_model)[2]), colour = "#E85D4A", linewidth = 1
  ) +
  labs(
    title = "OLS estimates the conditional mean from a noisy sample",
    subtitle = "Coral: fitted line; dashed: known population line",
    x = "Class size (students)", y = "Classroom test score (points)"
  ) +
  theme_minimal(base_size = 14)
print(school_plot)

# Predict at three FIXED class sizes. Risk averages over repeated training
# outcomes and an independent new classroom outcome at each of these x values.
prediction_data <- data.frame(class_size = c(18, 25, 35))
prediction_data$fitted_score <- as.numeric(predict(school_model, prediction_data))
print(prediction_data)
# Optional extension beyond formal Chapter 4: exact homoskedastic variance.
# Appendix 4.4 supplies the general decomposition; here we evaluate its terms
# under extra assumptions imposed by our simulated DGP.
prediction_risk <- lecture2_prediction_decomposition(
  x = prediction_data$class_size, training_x = school_data$class_size,
  error_sd = examples$dgp$error_sd
)
print(prediction_risk)
# Conditional-mean MSE = bias^2 + estimation variance (bias is zero here).
# New-outcome MSE also includes 8^2 = 64 points^2 of irreducible noise.
# Do not substitute var(predict(school_model)): variation across class sizes
# describes different fitted means, not estimation uncertainty at a fixed x.

# Optional preview beyond formal Chapter 4: estimated slope standard errors.
# Heteroskedasticity changes standard errors, not OLS algebra.
heteroskedastic_data <- lecture2_examples(
  seed = 20260909, heteroskedastic = TRUE
)$school_data
print(lecture2_slope_se(heteroskedastic_data$class_size, heteroskedastic_data$score))
# homoskedastic assumes constant error variance; HC1 allows variance to vary with x.
# Both require independent observations. HC1 need not be larger in each sample.
# Iid (X, Y) pairs can have heteroskedastic errors: iid is not a synonym for
# homoskedasticity. Coefficient SE estimation is developed after Chapter 4.
