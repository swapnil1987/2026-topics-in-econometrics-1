# Lecture 1: Law of large numbers
# Classroom question: What does convergence in probability look like?

library(ggplot2)

set.seed(2026)

# Exponential draws are right-skewed and have population mean 1.
population_mean <- 1
number_of_draws <- 500
draws <- rexp(number_of_draws, rate = 1)

running_mean_data <- data.frame(
  sample_size = seq_len(number_of_draws),
  running_mean = cumsum(draws) / seq_len(number_of_draws)
)

running_mean_plot <- ggplot(
  running_mean_data,
  aes(sample_size, running_mean)
) +
  geom_hline(
    yintercept = population_mean,
    colour = "#E85D4A",
    linewidth = 1
  ) +
  geom_line(colour = "#222222", linewidth = 0.8) +
  labs(
    title = "One sample path: the running mean settles",
    subtitle = "The population is exponential with mean 1",
    x = "Sample size, n",
    y = "Running sample mean"
  ) +
  theme_minimal(base_size = 14)

print(running_mean_plot)

# The LLN is a probability statement across possible samples.
# Estimate Pr(|sample mean - population mean| > tolerance) for several n.
sample_sizes <- c(5, 10, 25, 50, 100, 250)
number_of_repetitions <- 10000
tolerance <- 0.20

error_probability <- sapply(sample_sizes, function(current_sample_size) {
  sample_means <- replicate(
    number_of_repetitions,
    mean(rexp(current_sample_size, rate = 1))
  )
  mean(abs(sample_means - population_mean) > tolerance)
})

lln_probability_data <- data.frame(
  sample_size = sample_sizes,
  estimated_probability = error_probability
)

lln_probability_data$estimated_probability <- round(
  lln_probability_data$estimated_probability,
  3
)
lln_probability_data

probability_plot <- ggplot(
  lln_probability_data,
  aes(sample_size, estimated_probability)
) +
  geom_line(colour = "#B83D2F", linewidth = 1) +
  geom_point(colour = "#B83D2F", size = 3) +
  scale_y_continuous(limits = c(0, 1)) +
  labs(
    title = "Large errors become less likely as n grows",
    subtitle = "Estimated probability that the sample mean misses 1 by more than 0.20",
    x = "Sample size, n",
    y = "Estimated probability"
  ) +
  theme_minimal(base_size = 14)

print(probability_plot)
