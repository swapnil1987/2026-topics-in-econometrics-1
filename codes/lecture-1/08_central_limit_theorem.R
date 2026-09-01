# Lecture 1: Central limit theorem
# Classroom question: How can averages become bell-shaped when data are skewed?

library(ggplot2)

set.seed(2026)

# The exponential population is strongly right-skewed.
# Its population mean and standard deviation are both 1.
population_mean <- 1
population_standard_deviation <- 1
sample_sizes <- c(1, 5, 30)
number_of_repetitions <- 5000

clt_data <- do.call(
  rbind,
  lapply(sample_sizes, function(current_sample_size) {
    sample_means <- replicate(
      number_of_repetitions,
      mean(rexp(current_sample_size, rate = 1))
    )

    data.frame(
      sample_mean = sample_means,
      standardized_mean =
        sqrt(current_sample_size) *
        (sample_means - population_mean) /
        population_standard_deviation,
      sample_size = current_sample_size,
      panel = paste("n =", current_sample_size)
    )
  })
)

clt_summary <- do.call(
  rbind,
  lapply(sample_sizes, function(current_sample_size) {
    current_data <- clt_data[
      clt_data$sample_size == current_sample_size,
    ]

    data.frame(
      sample_size = current_sample_size,
      mean_of_sample_means = mean(current_data$sample_mean),
      empirical_standard_deviation = sd(current_data$sample_mean),
      theoretical_standard_deviation =
        population_standard_deviation / sqrt(current_sample_size)
    )
  })
)

clt_summary[, -1] <- round(clt_summary[, -1], 3)
clt_summary

clt_data$panel <- factor(
  clt_data$panel,
  levels = paste("n =", sample_sizes)
)

normal_reference <- expand.grid(
  standardized_mean = seq(-4, 5, length.out = 600),
  panel = factor(
    paste("n =", sample_sizes),
    levels = paste("n =", sample_sizes)
  )
)
normal_reference$density <- dnorm(normal_reference$standardized_mean)

clt_plot <- ggplot(clt_data, aes(standardized_mean)) +
  geom_density(fill = "#F7D9D5", colour = "#B83D2F", linewidth = 1) +
  geom_line(
    data = normal_reference,
    aes(standardized_mean, density),
    inherit.aes = FALSE,
    colour = "#222222",
    linewidth = 1
  ) +
  facet_wrap(~panel, nrow = 1) +
  coord_cartesian(xlim = c(-4, 5), ylim = c(0, 0.48)) +
  labs(
    title = "Standardized sample means approach the normal curve",
    subtitle = "Shaded: simulation; black line: standard normal density",
    x = "Standardized sample mean",
    y = "Density"
  ) +
  theme_minimal(base_size = 13)

print(clt_plot)
