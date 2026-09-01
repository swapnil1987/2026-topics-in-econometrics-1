# Lecture 1: Random variables and repeated sampling
# Classroom question: How does a random outcome become a numerical variable?

library(ggplot2)

set.seed(2026)

# One commute is uncertain before it happens.
one_commute <- rlnorm(1, meanlog = log(18), sdlog = 0.35)
one_commute

# Repeat the same random process for many students.
number_of_students <- 1000
commute_time <- rlnorm(
  number_of_students,
  meanlog = log(18),
  sdlog = 0.35
)

# The same outcome can generate two random variables:
# Y = commute time in minutes, and L = 1 if the commute is longer than 20 minutes.
long_commute <- as.integer(commute_time > 20)

commute_data <- data.frame(
  student = seq_len(number_of_students),
  commute_time = commute_time,
  long_commute = long_commute
)

head(commute_data)
mean(commute_data$commute_time)
mean(commute_data$long_commute)

commute_histogram <- ggplot(commute_data, aes(commute_time)) +
  geom_histogram(
    binwidth = 2,
    boundary = 0,
    fill = "#E85D4A",
    colour = "white"
  ) +
  geom_vline(xintercept = 20, linetype = "dashed", linewidth = 1) +
  labs(
    title = "A continuous random variable",
    subtitle = "Commute time can take any positive value",
    x = "Commute time (minutes)",
    y = "Number of students"
  ) +
  theme_minimal(base_size = 14)

long_commute_counts <- data.frame(
  outcome = c("No: L = 0", "Yes: L = 1"),
  count = as.numeric(table(factor(long_commute, levels = 0:1)))
)

long_commute_plot <- ggplot(long_commute_counts, aes(outcome, count)) +
  geom_col(fill = "#B83D2F", width = 0.65) +
  labs(
    title = "A binary random variable",
    subtitle = "The same commute is recoded as long or not long",
    x = NULL,
    y = "Number of students"
  ) +
  theme_minimal(base_size = 14)

print(commute_histogram)
print(long_commute_plot)
