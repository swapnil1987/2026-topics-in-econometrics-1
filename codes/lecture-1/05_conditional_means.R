# Lecture 1: Conditional means and the law of iterated expectations
# Classroom question: How do group means combine to produce the overall mean?

library(ggplot2)

set.seed(2026)
number_of_workers <- 4000

# This is simulated descriptive data, not evidence of a causal degree effect.
degree <- rbinom(number_of_workers, size = 1, prob = 0.40)
hourly_wage <- 14 + 6.40 * degree + rnorm(number_of_workers, sd = 4.5)

wage_data <- data.frame(
  degree = degree,
  hourly_wage = hourly_wage
)

# E(Y | X): calculate the mean wage within each degree group.
group_means <- aggregate(
  hourly_wage ~ degree,
  data = wage_data,
  FUN = mean
)
names(group_means)[2] <- "conditional_mean"

group_counts <- aggregate(
  hourly_wage ~ degree,
  data = wage_data,
  FUN = length
)
names(group_counts)[2] <- "group_size"

group_summary <- merge(group_means, group_counts, by = "degree")
group_summary$group_share <- group_summary$group_size / number_of_workers
group_summary$degree_group <- ifelse(
  group_summary$degree == 1,
  "Degree",
  "No degree"
)
group_summary$degree_group <- factor(
  group_summary$degree_group,
  levels = c("No degree", "Degree")
)

# E[E(Y | X)]: weight each conditional mean by its group probability.
weighted_mean <- sum(
  group_summary$conditional_mean * group_summary$group_share
)
overall_mean <- mean(wage_data$hourly_wage)

group_summary$conditional_mean <- round(
  group_summary$conditional_mean,
  2
)
group_summary$group_share <- round(group_summary$group_share, 3)
group_summary

round(weighted_mean, 6)
round(overall_mean, 6)
all.equal(weighted_mean, overall_mean)

conditional_mean_plot <- ggplot(
  group_summary,
  aes(degree_group, conditional_mean)
) +
  geom_col(fill = "#E85D4A", width = 0.65) +
  geom_hline(
    yintercept = overall_mean,
    linetype = "dashed",
    linewidth = 1
  ) +
  annotate(
    "text",
    x = 1.5,
    y = overall_mean + 0.6,
    label = paste("Overall mean =", round(overall_mean, 2))
  ) +
  labs(
    title = "The overall mean averages the conditional means",
    subtitle = "The weights are the observed shares of the two groups",
    x = NULL,
    y = "Mean hourly wage"
  ) +
  theme_minimal(base_size = 14)

print(conditional_mean_plot)
