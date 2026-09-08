# %% [markdown]
# # 02 · Central limit theorem
# **Question:** can sample means look normal when individual earnings are skewed?
# We use the same invented population Y = 10 + Exponential(mean 10): mean 20, SD 10.
# Unlike the LLN path, each repetition below draws a complete fresh sample of size n.
# %%
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2", repos = "https://cloud.r-project.org")
}
library(ggplot2)
options(repr.plot.width = 11, repr.plot.height = 6)
theme_set(theme_minimal(base_size = 17))
# %% [markdown]
# ## 1. Fix the population; vary the sample size
# We plot Z = sqrt(n) * (sample mean - population mean) / population SD.
# Standardization lets us compare shapes without the shrinking spread hiding the result.
# **Predict:** which panel will look most like N(0,1)?
# %%
set.seed(202609093)
minimum_earnings <- 10
exponential_mean <- 10
population_mean <- minimum_earnings + exponential_mean
population_sd <- exponential_mean
sample_sizes <- c(1, 5, 30, 100)
repetitions <- 5000
clt_draws <- do.call(rbind, lapply(sample_sizes, function(n) {
  samples <- matrix(minimum_earnings + rexp(n * repetitions, 1 / exponential_mean),
                    nrow = n)
  sample_means <- colMeans(samples)
  data.frame(n = n, mean = sample_means,
             z = sqrt(n) * (sample_means - population_mean) / population_sd)
}))
# %% [markdown]
# ## 2. Compare standardized means with the normal density
# Each histogram contains 5,000 sample statistics, not 5,000 individuals.
# The red curve is the standard normal density. All panels use common axes.
# %%
clt_draws$panel <- factor(paste("n =", clt_draws$n), levels = paste("n =", sample_sizes))
print(ggplot(clt_draws, aes(z)) +
  geom_histogram(aes(y = after_stat(density)), binwidth = 0.25,
                 fill = "#DEDBD6", colour = "white") +
  stat_function(fun = dnorm, colour = "#B83D2F", linewidth = 1) +
  facet_wrap(~panel, ncol = 2) +
  labs(title = "Standardized sample means approach the normal shape",
       x = "sqrt(n) × (sample mean − 20) / 10", y = "Density"))
clt_summary <- do.call(rbind, lapply(sample_sizes, function(n) {
  values <- clt_draws$z[clt_draws$n == n]
  data.frame(n = n, simulated_mean = mean(values), simulated_sd = sd(values),
             theoretical_mean = 0, theoretical_sd = 1)
}))
print(clt_summary)
# %% [markdown]
# ## 3. Explain and change
# The CLT describes the limiting SHAPE of standardized estimation error:
# sqrt(n)(bar(Y)-mu)/sigma converges in distribution to N(0,1).
# The standardized statistic has mean 0 and variance 1 here at every n;
# those two moments alone do not make its distribution normal.
#
# **Try:** use sample_sizes = c(1, 2, 10, 50), then increase repetitions.
# Increasing n improves the approximation; increasing repetitions makes the
# displayed histogram a more accurate picture of its existing sampling distribution.
# There is no universal n at which every population gives a good normal approximation.
