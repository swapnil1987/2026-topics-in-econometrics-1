# %% [markdown]
# # 01 · Law of large numbers
# **Question:** how does an average behave as we observe more people?
# Run each cell in order. Predict the result before running; change a parameter
# and rerun from that cell onward. This is a standalone R notebook.
#
# We invent a right-skewed hourly-earnings population: Y = 10 + Exponential(mean 10).
# Its mean is 20 and its SD is 10, in currency units per hour. These are not real data.
# %%
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2", repos = "https://cloud.r-project.org")
}
library(ggplot2)
options(repr.plot.width = 11, repr.plot.height = 6)
theme_set(theme_minimal(base_size = 17))
# %% [markdown]
# ## 1. Draw one growing sample
# The same sample grows as n increases; we do not draw a completely new sample at each n.
# **Predict:** must each additional observation move the average closer to 20?
# %%
set.seed(202609091)
minimum_earnings <- 10
exponential_mean <- 10
population_mean <- minimum_earnings + exponential_mean
max_sample_size <- 3000
earnings <- minimum_earnings + rexp(max_sample_size, rate = 1 / exponential_mean)
running_mean <- cumsum(earnings) / seq_along(earnings)
checkpoints <- c(10, 100, 1000, max_sample_size)
print(data.frame(n = checkpoints, sample_mean = running_mean[checkpoints],
                 error = running_mean[checkpoints] - population_mean))
# %% [markdown]
# ## 2. Inspect several possible paths
# Each panel is an independent sequence of draws from the same population.
# The horizontal axis uses a log scale so early and late sample sizes are visible.
# %%
set.seed(202609092)
paths <- do.call(rbind, lapply(1:4, function(path_id) {
  new_earnings <- minimum_earnings + rexp(max_sample_size, 1 / exponential_mean)
  data.frame(n = seq_along(new_earnings),
             mean = cumsum(new_earnings) / seq_along(new_earnings),
             path = paste("Sample path", path_id))
}))
print(ggplot(paths, aes(n, mean)) +
  geom_hline(yintercept = population_mean, linetype = "dashed", colour = "#68645F") +
  geom_line(colour = "#B83D2F", linewidth = 0.7) +
  scale_x_log10(breaks = c(1, 10, 100, 1000, max_sample_size)) +
  facet_wrap(~path, ncol = 2) +
  labs(title = "Averages stabilize, but need not improve at every step",
       x = "Sample size n (log scale)", y = "Running mean earnings"))
# %% [markdown]
# ## 3. Explain and change
# For i.i.d. draws with a finite mean, the LLN gives bar(Y)_n -> mu in probability.
# The graphs illustrate that theorem; four paths do not prove it.
#
# **Try:** change max_sample_size to 10000 and rerun. Does every path move monotonically?
# Then change exponential_mean to 20: predict the new population mean before rerunning.
# Larger n changes the amount of data in each average. More plotted paths only
# show more possible sample histories; they do not make an individual average more precise.
