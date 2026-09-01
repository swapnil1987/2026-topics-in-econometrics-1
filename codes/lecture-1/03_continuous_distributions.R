# Lecture 1: Shapes of continuous probability distributions
# Classroom question: What do the support, parameters, and tails look like?

library(ggplot2)

# Each density is evaluated on a grid appropriate for its support.
normal_x <- seq(-4, 4, length.out = 700)
lognormal_x <- seq(0.01, 6, length.out = 700)
chi_squared_x <- seq(0.01, 15, length.out = 700)
student_t_x <- seq(-5, 5, length.out = 700)
f_x <- seq(0.01, 4, length.out = 700)

continuous_densities <- rbind(
  data.frame(
    value = normal_x,
    density = dnorm(normal_x),
    distribution = "Normal: symmetric on the real line"
  ),
  data.frame(
    value = lognormal_x,
    density = dlnorm(lognormal_x, meanlog = 0, sdlog = 0.60),
    distribution = "Log-normal: positive and right-skewed"
  ),
  data.frame(
    value = chi_squared_x,
    density = dchisq(chi_squared_x, df = 4),
    distribution = "Chi-squared: nonnegative sum of squares"
  ),
  data.frame(
    value = student_t_x,
    density = dt(student_t_x, df = 5),
    distribution = "Student t: symmetric with heavier tails"
  ),
  data.frame(
    value = f_x,
    density = df(f_x, df1 = 5, df2 = 20),
    distribution = "F: positive ratio of variances"
  )
)

continuous_densities$distribution <- factor(
  continuous_densities$distribution,
  levels = c(
    "Normal: symmetric on the real line",
    "Log-normal: positive and right-skewed",
    "Chi-squared: nonnegative sum of squares",
    "Student t: symmetric with heavier tails",
    "F: positive ratio of variances"
  )
)

density_plot <- ggplot(
  continuous_densities,
  aes(value, density)
) +
  geom_area(fill = "#F7D9D5", alpha = 0.75) +
  geom_line(colour = "#B83D2F", linewidth = 1) +
  facet_wrap(~distribution, scales = "free", ncol = 2) +
  labs(
    title = "Continuous families have different supports and shapes",
    x = "Value",
    y = "Density"
  ) +
  theme_minimal(base_size = 12)

print(density_plot)

# A probability is an area, obtained from a cumulative distribution function.
normal_middle_probability <- pnorm(1.96) - pnorm(-1.96)
lognormal_probability_below_two <- plnorm(
  2,
  meanlog = 0,
  sdlog = 0.60
)

round(normal_middle_probability, 3)
round(lognormal_probability_below_two, 3)

# Compare the normal and Student t tails directly.
tail_grid <- seq(-5, 5, length.out = 700)
tail_comparison <- rbind(
  data.frame(
    value = tail_grid,
    density = dnorm(tail_grid),
    distribution = "Standard normal"
  ),
  data.frame(
    value = tail_grid,
    density = dt(tail_grid, df = 5),
    distribution = "Student t with 5 df"
  )
)

tail_plot <- ggplot(
  tail_comparison,
  aes(value, density, colour = distribution)
) +
  geom_line(linewidth = 1.1) +
  scale_colour_manual(values = c("#222222", "#E85D4A")) +
  labs(
    title = "Student t places more probability in the tails",
    x = "Value",
    y = "Density",
    colour = NULL
  ) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "bottom")

print(tail_plot)
