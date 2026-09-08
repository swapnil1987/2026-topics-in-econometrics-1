# Lecture 2: Means, standard errors, and two-sided inference
# Classroom question: How precisely have we estimated a population mean?
# Chapter 3 review supporting Chapter 4; this is not coefficient inference.

# Run from the repository root or from codes/lecture-2.
source_candidates <- c("R/lecture-02.R", "../../R/lecture-02.R")
source_path <- source_candidates[file.exists(source_candidates)][1]
if (is.na(source_path)) stop("Run from the repository root or codes/lecture-2.")
source(source_path)
library(ggplot2)

examples <- lecture2_examples(seed = 20260909)
school_data <- examples$school_data

# Each row is a simulated classroom. The known population mean is 79.1 points.
# A standard deviation describes score dispersion; an SE describes uncertainty
# about the sample mean. Scores are iid draws from the default simulated DGP.
number_of_classes <- nrow(school_data)
mean_score <- mean(school_data$score)
score_sd <- sd(school_data$score)
mean_se <- score_sd / sqrt(number_of_classes)
print(data.frame(number_of_classes, mean_score, score_sd, mean_se))

# H0: population mean = 80; H1: population mean != 80.
# This is a large-sample z approximation because the SE is estimated.
# A p-value is not the probability that H0 is true.
mean_inference <- lecture2_z_summary(
  estimate = mean_score, standard_error = mean_se, null_value = 80
)
print(mean_inference)
print(examples$dgp$population_mean)

# A binary regressor: its slope is exactly the difference in group means.
# small_class = 1 means at most 25 students; 0 means more than 25.
group_means <- aggregate(score ~ small_class, data = school_data, FUN = mean)
mean_difference <- with(
  school_data, mean(score[small_class == 1]) - mean(score[small_class == 0])
)
dummy_model <- lm(score ~ small_class, data = school_data)
print(group_means)
print(c(difference_in_means = mean_difference, dummy_slope = unname(coef(dummy_model)[2])))
# This contrasts groups with different class sizes; it is not the per-student
# class-size slope, nor evidence of a real-world causal intervention effect.

# Optional exercise: which intervals cover the fixed population mean?
# This separate normal population has KNOWN SD, so its z intervals are exact.
coverage_draws <- lecture2_mean_coverage(seed = 20260909)
print(data.frame(
  nominal_coverage = 0.95,
  simulated_coverage = mean(coverage_draws$covered),
  monte_carlo_se = sqrt(0.95 * 0.05 / nrow(coverage_draws))
))

interval_plot <- ggplot(
  head(coverage_draws, 40), aes(x = repetition, y = estimate)
) +
  geom_hline(yintercept = 80, linetype = "dashed", colour = "#242424") +
  geom_errorbar(aes(ymin = conf_low, ymax = conf_high), colour = "#E85D4A") +
  geom_point(colour = "#B83D2F") +
  labs(
    title = "Different samples give different confidence intervals",
    subtitle = "First 40 draws; dashed line: the fixed population mean",
    x = "Repeated sample", y = "Mean score and 95% confidence interval"
  ) +
  theme_minimal(base_size = 14)
print(interval_plot)
