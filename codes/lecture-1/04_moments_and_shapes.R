# Lecture 1: Mean, variance, skewness, and kurtosis
# Classroom question: Can equal means and variances hide different shapes?

library(ggplot2)

set.seed(2026)
number_of_draws <- 20000

raw_draws <- list(
  Normal = rnorm(number_of_draws),
  `Log-normal` = rlnorm(number_of_draws, sdlog = 0.55),
  `Student t (5 df)` = rt(number_of_draws, df = 5)
)

# Use population-style central moments to mirror the definitions in class.
moment_summary <- function(values) {
  centered_values <- values - mean(values)
  variance <- mean(centered_values^2)

  data.frame(
    mean = mean(values),
    variance = variance,
    standard_deviation = sqrt(variance),
    skewness = mean(centered_values^3) / variance^(3 / 2),
    kurtosis = mean(centered_values^4) / variance^2
  )
}

moment_table <- do.call(
  rbind,
  lapply(names(raw_draws), function(distribution_name) {
    summary_row <- moment_summary(raw_draws[[distribution_name]])
    summary_row$distribution <- distribution_name
    summary_row
  })
)

moment_table <- moment_table[
  , c(
    "distribution",
    "mean",
    "variance",
    "standard_deviation",
    "skewness",
    "kurtosis"
  )
]
moment_table[, -1] <- round(moment_table[, -1], 3)
moment_table

# Standardize each sample so the plots have the same center and spread.
standardize <- function(values) {
  centered_values <- values - mean(values)
  centered_values / sqrt(mean(centered_values^2))
}

shape_data <- do.call(
  rbind,
  lapply(names(raw_draws), function(distribution_name) {
    data.frame(
      standardized_value = standardize(raw_draws[[distribution_name]]),
      distribution = distribution_name
    )
  })
)

shape_data$distribution <- factor(
  shape_data$distribution,
  levels = c("Normal", "Log-normal", "Student t (5 df)")
)

shape_plot <- ggplot(shape_data, aes(standardized_value)) +
  geom_density(fill = "#F7D9D5", colour = "#B83D2F", linewidth = 1) +
  facet_wrap(~distribution, nrow = 1) +
  scale_x_continuous(breaks = c(-4, 0, 4)) +
  coord_cartesian(xlim = c(-4, 6), ylim = c(0, 0.55)) +
  labs(
    title = "Same mean and variance, different shapes",
    subtitle = "All three samples are standardized to mean 0 and variance 1",
    x = "Standardized value",
    y = "Density"
  ) +
  theme_minimal(base_size = 13)

print(shape_plot)
