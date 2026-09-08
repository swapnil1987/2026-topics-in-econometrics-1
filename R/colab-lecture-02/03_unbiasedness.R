# %% [markdown]
# # 03 · Unbiasedness
# **Question:** can an estimator be correct on average but imprecise?
# Keep sample size fixed. Compare the sample mean, the first observation,
# and an intentionally shifted estimator: sample mean + 2.
# The population is invented earnings Y = 10 + Exponential(mean 10).
# %%
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2", repos = "https://cloud.r-project.org")
}
library(ggplot2)
options(repr.plot.width = 11, repr.plot.height = 6)
theme_set(theme_minimal(base_size = 17))
# %% [markdown]
# ## 1. Repeat three rules on the same samples
# **Predict:** which rules have expectation 20? Which have the smallest spread?
# Each column is a fresh sample; all three rules use that same column.
# %%
set.seed(202609094)
population_mean <- 20
population_sd <- 10
sample_size <- 25
repetitions <- 5000
bias_shift <- 2
samples <- matrix(10 + rexp(sample_size * repetitions, rate = 1 / 10),
                  nrow = sample_size)
estimates <- data.frame(
  sample_mean = colMeans(samples),
  first_observation = samples[1, ],
  shifted_mean = colMeans(samples) + bias_shift
)
expected_values <- c(population_mean, population_mean, population_mean + bias_shift)
unbiasedness_summary <- data.frame(
  rule = names(estimates), theoretical_expectation = expected_values,
  simulation_average = vapply(estimates, mean, numeric(1)),
  theoretical_bias = expected_values - population_mean,
  simulated_bias = vapply(estimates, mean, numeric(1)) - population_mean,
  estimator_sd = vapply(estimates, sd, numeric(1)),
  monte_carlo_se_of_average = vapply(estimates, sd, numeric(1)) / sqrt(repetitions)
)
print(unbiasedness_summary, row.names = FALSE)
# %% [markdown]
# ## 2. Inspect center and spread separately
# The dashed line is the true mean. Each density represents repeated estimates at n = 25.
# The simulation average need not equal its theoretical expectation exactly.
# %%
plot_data <- stack(estimates)
print(ggplot(plot_data, aes(values, colour = ind)) +
  geom_density(linewidth = 1) +
  geom_vline(xintercept = population_mean, linetype = "dashed") +
  scale_colour_manual(values = c(sample_mean = "#242424", first_observation = "#999188",
                                 shifted_mean = "#B83D2F")) +
  labs(title = "Unbiasedness concerns the center, not the spread",
       x = "Estimated mean earnings", y = "Density", colour = "Rule") +
  theme(legend.position = "bottom"))
# %% [markdown]
# ## 3. Explain and change
# E[bar(Y)] = mu and E[Y_1] = mu: both rules are unbiased.
# But Var(bar(Y)) = sigma^2/n, whereas Var(Y_1) = sigma^2.
# E[bar(Y)+2] = mu+2, so its bias is 2.
#
# **Try:** increase repetitions to 20000 while keeping n fixed. Simulation
# averages settle down, but the distribution of each individual estimator does not tighten.
# Then change bias_shift to -2. Predict where the shifted distribution moves.
# Monte Carlo SE measures uncertainty in the SIMULATION AVERAGE; it is not
# the sampling SD of an estimator from one sample. Simulation illustrates, not proves, unbiasedness.
