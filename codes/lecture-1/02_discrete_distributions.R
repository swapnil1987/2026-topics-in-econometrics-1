# Lecture 1: Bernoulli, binomial, and Poisson distributions
# Classroom question: Which probability model matches each counting story?

library(ggplot2)

default_probability <- 0.30
number_of_loans <- 10
arrival_rate <- 3

# Exact probability mass functions.
bernoulli_support <- 0:1
binomial_support <- 0:number_of_loans
poisson_support <- 0:12

discrete_probabilities <- rbind(
  data.frame(
    value = bernoulli_support,
    probability = dbinom(
      bernoulli_support,
      size = 1,
      prob = default_probability
    ),
    distribution = "Bernoulli: one loan"
  ),
  data.frame(
    value = binomial_support,
    probability = dbinom(
      binomial_support,
      size = number_of_loans,
      prob = default_probability
    ),
    distribution = "Binomial: defaults among 10 loans"
  ),
  data.frame(
    value = poisson_support,
    probability = dpois(poisson_support, lambda = arrival_rate),
    distribution = "Poisson: arrivals in one hour"
  )
)

discrete_probabilities$distribution <- factor(
  discrete_probabilities$distribution,
  levels = c(
    "Bernoulli: one loan",
    "Binomial: defaults among 10 loans",
    "Poisson: arrivals in one hour"
  )
)

probability_plot <- ggplot(
  discrete_probabilities,
  aes(value, probability)
) +
  geom_col(fill = "#E85D4A", width = 0.72) +
  facet_wrap(~distribution, scales = "free_x", nrow = 1) +
  scale_x_continuous(breaks = 0:12) +
  labs(
    title = "Three discrete probability distributions",
    x = "Count",
    y = "Probability"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    axis.text.x = element_text(size = 8),
    strip.text = element_text(size = 10)
  )

print(probability_plot)

# Simulate many repetitions and compare empirical averages with theory.
set.seed(2026)
number_of_repetitions <- 10000

one_loan_default <- rbinom(
  number_of_repetitions,
  size = 1,
  prob = default_probability
)
defaults_among_ten <- rbinom(
  number_of_repetitions,
  size = number_of_loans,
  prob = default_probability
)
arrivals_per_hour <- rpois(number_of_repetitions, lambda = arrival_rate)

comparison <- data.frame(
  random_variable = c(
    "One loan defaults",
    "Defaults among 10 loans",
    "Arrivals per hour"
  ),
  empirical_mean = c(
    mean(one_loan_default),
    mean(defaults_among_ten),
    mean(arrivals_per_hour)
  ),
  theoretical_mean = c(
    default_probability,
    number_of_loans * default_probability,
    arrival_rate
  )
)

comparison$empirical_mean <- round(comparison$empirical_mean, 3)
comparison
