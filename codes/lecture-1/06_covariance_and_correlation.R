# Lecture 1: Covariance, correlation, and nonlinear relationships
# Classroom question: What information can a correlation miss?

library(ggplot2)

set.seed(2026)
number_of_observations <- 500
x <- runif(number_of_observations, min = -2, max = 2)

linear_y <- 2 * x + rnorm(number_of_observations, sd = 0.70)
u_shaped_y <- x^2 + rnorm(number_of_observations, sd = 0.35)
x_rescaled <- 100 * x

# Covariance changes when the units of X change; correlation does not.
relationship_summary <- data.frame(
  comparison = c(
    "Linear relationship",
    "Linear relationship after multiplying X by 100",
    "U-shaped relationship"
  ),
  covariance = c(
    cov(x, linear_y),
    cov(x_rescaled, linear_y),
    cov(x, u_shaped_y)
  ),
  correlation = c(
    cor(x, linear_y),
    cor(x_rescaled, linear_y),
    cor(x, u_shaped_y)
  )
)

relationship_summary$covariance <- round(
  relationship_summary$covariance,
  3
)
relationship_summary$correlation <- round(
  relationship_summary$correlation,
  3
)
relationship_summary

plot_data <- rbind(
  data.frame(
    x = x,
    y = linear_y,
    relationship = "Linear: correlation is informative"
  ),
  data.frame(
    x = x,
    y = u_shaped_y,
    relationship = "U-shaped: correlation is near zero"
  )
)

relationship_plot <- ggplot(plot_data, aes(x, y)) +
  geom_point(colour = "#E85D4A", alpha = 0.45) +
  geom_smooth(
    method = "lm",
    formula = y ~ x,
    se = FALSE,
    colour = "#3A388A",
    linetype = "dashed",
    linewidth = 1
  ) +
  geom_smooth(
    method = "loess",
    formula = y ~ x,
    se = FALSE,
    colour = "#222222",
    linewidth = 1
  ) +
  facet_wrap(~relationship, nrow = 1, scales = "free_y") +
  labs(
    title = "Pearson correlation measures linear co-movement",
    subtitle = "Dashed: linear fit; solid: flexible smooth",
    x = "X",
    y = "Y"
  ) +
  theme_minimal(base_size = 13)

print(relationship_plot)
