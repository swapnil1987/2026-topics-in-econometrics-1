# %% [markdown]
# # 05 · What is a p-value?
# **Question:** if the null were true, how often would we see a statistic this extreme?
# Use the lecture's textbook example: n = 200, sample mean = 22.64, sample SD = 18.14.
# These are hypothetical summary statistics, not a supplied dataset of individual earnings.
# %%
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2", repos = "https://cloud.r-project.org")
}
library(ggplot2)
options(repr.plot.width = 11, repr.plot.height = 6)
theme_set(theme_minimal(base_size = 17))
# %% [markdown]
# ## 1. Measure the observed gap in standard errors
# H0: population mean = 20; H1: population mean is different from 20.
# **Predict:** why is the raw difference 2.64 insufficient to judge the evidence?
# %%
sample_size <- 200
observed_mean <- 22.64
observed_sd <- 18.14
null_mean <- 20
alpha <- 0.05
standard_error <- observed_sd / sqrt(sample_size)
observed_t <- (observed_mean - null_mean) / standard_error
normal_p_value <- 2 * pnorm(-abs(observed_t))
print(data.frame(standard_error, observed_t, normal_p_value,
                 reject_at_alpha = normal_p_value < alpha))
# %% [markdown]
# ## 2. Shade BOTH tails beyond the observed statistic
# The shaded probability is calculated under the null reference distribution.
# We use the lecture's large-sample normal approximation for the t-statistic.
# %%
cutoff <- abs(observed_t)
plot_limit <- max(4, cutoff + 1)
normal_curve <- data.frame(z = seq(-plot_limit, plot_limit, length.out = 2001))
normal_curve$density <- dnorm(normal_curve$z)
print(ggplot(normal_curve, aes(z, density)) +
  geom_area(data = subset(normal_curve, z <= -cutoff), fill = "#E85D4A") +
  geom_area(data = subset(normal_curve, z >= cutoff), fill = "#E85D4A") +
  geom_line(colour = "#242424", linewidth = 1) +
  geom_vline(xintercept = c(-cutoff, cutoff), linetype = "dashed", colour = "#B83D2F") +
  labs(title = sprintf("Two-sided normal-reference p-value = %.4f", normal_p_value),
       x = "Test statistic under H0", y = "Density"))
# %% [markdown]
# ## 3. Make the repeated-sampling question concrete
# For this simulation ONLY, assume an i.i.d. normal population under H0 with SD 18.14.
# Draw fresh samples and re-estimate the SD in every one. These statistics have
# an exact Student t distribution with n-1 degrees of freedom in THIS model.
# That does not establish normal earnings or an exact t test in general.
# %%
set.seed(202609096)
repetitions <- 5000
null_samples <- matrix(rnorm(sample_size * repetitions, mean = null_mean,
                             sd = observed_sd), nrow = sample_size)
null_means <- colMeans(null_samples)
null_sds <- apply(null_samples, 2, sd)
null_t <- (null_means - null_mean) / (null_sds / sqrt(sample_size))
simulated_p_value <- mean(abs(null_t) >= abs(observed_t))
exact_normal_sample_p <- 2 * pt(-abs(observed_t), df = sample_size - 1)
simulation_mc_se <- sqrt(exact_normal_sample_p * (1 - exact_normal_sample_p) / repetitions)
print(data.frame(normal_approximation = normal_p_value,
                 exact_t_under_normal_sampling = exact_normal_sample_p,
                 simulation_tail_fraction = simulated_p_value,
                 monte_carlo_se = simulation_mc_se))
# %% [markdown]
# ## 4. Explain and change
# The p-value is NOT the probability that H0 is true or the probability that the
# result is "due to chance." It is a tail probability under a specified null model.
# Rejecting means the data are unusual under that model; non-rejection does not prove equality.
#
# **Try:** change null_mean to 22, keeping the observed statistics fixed, and rerun.
# Then change alpha from 0.05 to 0.01: the decision may change, but the p-value does not.
# Changing repetitions reduces Monte Carlo noise; it does not change the analytical p-value.
# The simulation is a teaching illustration, not a validation of actual earnings assumptions.
