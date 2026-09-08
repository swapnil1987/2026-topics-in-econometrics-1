# %% [markdown]
# # 04 · Consistency
# **Question:** as n grows, does the probability of a meaningful error vanish?
# Use a fixed tolerance of one earnings unit and compare four estimator sequences.
# The invented population is Y = 10 + Exponential(mean 10), so mu = 20 and SD = 10.
# %%
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2", repos = "https://cloud.r-project.org")
}
library(ggplot2)
options(repr.plot.width = 11, repr.plot.height = 6)
theme_set(theme_minimal(base_size = 17))
# %% [markdown]
# ## 1. Define the error event before drawing data
# Consistency means P(|estimate - mu| > epsilon) -> 0 for EVERY fixed epsilon > 0.
# **Predict:** which rules will be consistent: mean, first observation, mean + 2,
# or mean + 10/n? The last rule is biased at every finite n, but its bias shrinks.
# %%
set.seed(202609095)
population_mean <- 20
sample_sizes <- c(10, 30, 100, 300, 1000)
repetitions <- 4000
epsilon <- 1
consistency_results <- do.call(rbind, lapply(sample_sizes, function(n) {
  samples <- matrix(10 + rexp(n * repetitions, rate = 1 / 10), nrow = n)
  sample_means <- colMeans(samples)
  estimates <- list(mean = sample_means, first = samples[1, ],
                    fixed_shift = sample_means + 2,
                    shrinking_shift = sample_means + 10 / n)
  data.frame(n = n, rule = names(estimates),
             probability_large_error = vapply(estimates,
               function(value) mean(abs(value - population_mean) > epsilon), numeric(1)))
}))
print(consistency_results, row.names = FALSE)
# %% [markdown]
# ## 2. Plot error probabilities, not just one fortunate path
# All rules use the same samples at each n. The vertical axis is the fraction
# of the 4,000 repetitions in which the absolute error exceeds the fixed tolerance.
# %%
print(ggplot(consistency_results, aes(n, probability_large_error, colour = rule)) +
  geom_line(linewidth = 1) + geom_point(size = 2) +
  scale_x_log10(breaks = sample_sizes) +
  scale_y_continuous(limits = c(0, 1)) +
  scale_colour_manual(values = c(mean = "#242424", first = "#999188",
                                 fixed_shift = "#B83D2F", shrinking_shift = "#D58F38")) +
  labs(title = "Does a fixed-size error become unlikely?",
       x = "Sample size n (log scale)", y = "Estimated probability of |error| > epsilon",
       colour = "Estimator") + theme(legend.position = "bottom"))
# %% [markdown]
# ## 3. Explain and change
# The mean is consistent by the LLN. Adding 10/n preserves consistency because it vanishes.
# The first-observation rule is unbiased but ignores all additional data: its error
# probability stays positive. The fixed-shift rule converges to 22, not the target 20.
#
# **Try:** set epsilon to 0.5 and rerun. Smaller tolerances require larger samples.
# If epsilon exceeds 2, even the fixed-shift rule can pass THAT tolerance;
# consistency requires success for every positive tolerance, not just one.
# Finite Monte Carlo probabilities fluctuate and do not prove the limiting claims.
