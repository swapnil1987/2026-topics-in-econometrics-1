# Lecture 5: deterministic verification of the hypothetical workshop examples.
# Run from the repository root:
# ~/miniconda3/bin/conda run --name topics-econometrics Rscript R/lecture-05-checks.R
# No external data, stochastic simulation, or seed is involved.

equal_to <- function(actual, expected, tolerance = 1e-10) {
  stopifnot(isTRUE(all.equal(unname(actual), unname(expected),
                            tolerance = tolerance, check.attributes = FALSE)))
}

# Q1: enumerate the joint distribution independently of conditional formulas.
joint <- data.frame(x = c(0, 0, 1, 1), y = c(0, 2, 0, 2),
                    probability = c(0.3, 0.1, 0.2, 0.4))
equal_to(sum(joint$probability), 1)
mean_x <- sum(joint$x * joint$probability)
mean_y <- sum(joint$y * joint$probability)
equal_to(mean_y, 1)
conditional_means <- vapply(0:1, function(group) {
  rows <- joint$x == group
  sum(joint$y[rows] * joint$probability[rows]) / sum(joint$probability[rows])
}, numeric(1))
equal_to(conditional_means, c(1 / 2, 4 / 3))
equal_to(sum(c(0.4, 0.6) * conditional_means), mean_y)
equal_to(mean(conditional_means), 11 / 12)
equal_to(sum((joint$x - mean_x) * (joint$y - mean_y) * joint$probability), 0.2)
equal_to(0.4 / sum(joint$probability[joint$y == 2]), 4 / 5)
equal_to(0.4 / sum(joint$probability[joint$x == 1]), 2 / 3)

# Q2: LIE and orthogonality for conditional-mean-zero, dependent errors.
mean_zero <- expand.grid(x = c(-2, 1, 3), sign = c(-1, 1))
mean_zero$probability <- rep(c(0.2, 0.3, 0.5), 2) / 2
mean_zero$u <- mean_zero$sign * (1 + mean_zero$x^2)
for (power in 0:2) {
  equal_to(sum(mean_zero$probability * mean_zero$x^power * mean_zero$u), 0)
}

# Q3: fit directly to all equally likely population support points.
nonlinear <- data.frame(x = c(-2, -1, 1, 2))
nonlinear$u <- nonlinear$x^2 - 5 / 2
nonlinear$y <- 5 + 3 * nonlinear$x + nonlinear$u
equal_to(mean(nonlinear$u), 0)
equal_to(mean(nonlinear$x * nonlinear$u), 0)
equal_to(mean(nonlinear$x^2 * nonlinear$u), 9 / 4)
equal_to(coef(lm(y ~ x, data = nonlinear)), c(5, 3))
equal_to(nonlinear$y[nonlinear$x == 2], 12.5)
stopifnot(all(nonlinear$u != 0))

# Q4: use explicit weight vectors instead of the simplified variance formulas.
sample_size <- 100
variance_y <- 4
weights_t <- c(0.5, rep(0.5 / (sample_size - 1), sample_size - 1))
weights_s <- c(1 / sqrt(sample_size),
               rep((1 - 1 / sqrt(sample_size)) / (sample_size - 1), sample_size - 1))
equal_to(sum(weights_t), 1)
equal_to(sum(weights_s), 1)
equal_to(variance_y * sum(weights_t^2), 100 / 99)
equal_to(variance_y * sum(weights_s^2), 4 / 55)

# Q5: verify the BLUE identity even for negative weights, then enumerate
# the outcome-dependent selection rule for several Bernoulli populations.
fixed_weights <- c(-0.25, 0.5, 0.75)
equal_to(sum(fixed_weights^2) - 1 / 3, sum((fixed_weights - 1 / 3)^2))
bernoulli_pairs <- expand.grid(y1 = 0:1, y2 = 0:1)
for (probability in c(0.1, 0.3, 0.5, 0.8)) {
  joint_prob <- dbinom(bernoulli_pairs$y1, 1, probability) *
    dbinom(bernoulli_pairs$y2, 1, probability)
  mean_minimum <- sum(pmin(bernoulli_pairs$y1, bernoulli_pairs$y2) * joint_prob)
  equal_to(mean_minimum, probability^2)
  stopifnot(mean_minimum < probability)
}

# Q6: the limit arguments are analytical; check the exact standardized shifts.
for (sample_size in c(16, 100, 10000)) {
  sigma_y <- 3
  shifts <- c(sigma_y / sample_size, sigma_y / sqrt(sample_size),
              sigma_y / sample_size^(1 / 4))
  equal_to(sqrt(sample_size) * shifts / sigma_y,
           c(1 / sqrt(sample_size), 1, sample_size^(1 / 4)))
}

# Q7: explicitly include all covariances of copied records.
copy_covariance <- kronecker(diag(100), matrix(25, 4, 4))
equal_to(sum(copy_covariance) / 400^2, 1 / 4)
equal_to(sum(diag(copy_covariance)) / 400^2, 1 / 16)
equal_to(2 * pnorm(-2), 0.04550026, tolerance = 1e-7)
equal_to(2 * pnorm(-4), 0.00006334248, tolerance = 1e-7)

# Q8: estimate the line independently from the recovered observations.
recovered <- data.frame(x = 0:3, y = c(2, 2, 4, 8))
recovered_fit <- lm(y ~ x, data = recovered)
equal_to(coef(recovered_fit), c(1, 2))
equal_to(residuals(recovered_fit), c(1, -1, -1, 1))
equal_to(sum((recovered$y - mean(recovered$y))^2), 24)
equal_to(sum((fitted(recovered_fit) - mean(recovered$y))^2), 20)
equal_to(sum(residuals(recovered_fit)^2), 4)
equal_to(summary(recovered_fit)$r.squared, 5 / 6)
equal_to(summary(recovered_fit)$sigma, sqrt(2))

# Q9: avoid summary(lm)$r.squared here because the question defines a
# centered R-squared for the explicitly no-intercept fit.
no_intercept <- data.frame(x = c(1, 2), y = c(2, 1))
no_intercept_fit <- lm(y ~ 0 + x, data = no_intercept)
equal_to(coef(no_intercept_fit), 4 / 5)
equal_to(residuals(no_intercept_fit), c(6 / 5, -3 / 5))
centered_tss <- sum((no_intercept$y - mean(no_intercept$y))^2)
residual_ss <- sum(residuals(no_intercept_fit)^2)
equal_to(residual_ss, 9 / 5)
equal_to(centered_tss, 1 / 2)
equal_to(1 - residual_ss / centered_tss, -13 / 5)
equal_to(sum((fitted(no_intercept_fit) - mean(no_intercept$y)) *
               residuals(no_intercept_fit)), -9 / 10)

# Q10: weighted population projections for different group proportions.
for (share_treated in c(0.1, 0.25, 0.5, 0.9)) {
  binary_population <- data.frame(d = c(0, 1), z = c(3, 1), y = c(22, 17),
                                  probability = c(1 - share_treated, share_treated))
  equal_to(coef(lm(y ~ d, weights = probability, data = binary_population)), c(22, -5))
  equal_to(binary_population$y, 10 + 3 * binary_population$d + 4 * binary_population$z)
}

# Q11: construct finite support with Var(X)=9 and Cov(X,Z)=-3.
ovb <- expand.grid(x = c(-3, 3), independent_component = c(-1, 1))
ovb$z <- -ovb$x / 3 + ovb$independent_component
ovb$y <- 10 + 2 * ovb$x + 6 * ovb$z
equal_to(mean(ovb$x^2), 9)
equal_to(mean(ovb$x * ovb$z), -3)
equal_to(coef(lm(y ~ x, data = ovb)), c(10, 0))
equal_to(mean(ovb$x * 6 * (ovb$z - mean(ovb$z))), -18)
ovb$x_star <- ovb$x / 3
ovb$y_star <- ovb$y / 2
equal_to(coef(lm(y_star ~ x_star + z, data = ovb)), c(5, 3, 3))
equal_to(coef(lm(y_star ~ x_star, data = ovb)), c(5, 0))

# Q12: independently verify the exact slope-error identity on a finite sample.
example_beta <- 0.75
example_errors <- c(1, -2, 0, 3, -1)
example_x <- c(-2, -1, 0, 2, 4)
example_y <- 3 + example_beta * example_x + example_errors
equal_to(coef(lm(example_y ~ example_x))[2] - example_beta,
         sum((example_x - mean(example_x)) * example_errors) /
           sum((example_x - mean(example_x))^2))
equal_to(36 / 4^2, 9 / 4)
equal_to(sqrt(36 / (144 * 4^2)), 1 / 8)
equal_to(pnorm(2) - pnorm(-2), 0.9544997, tolerance = 1e-7)
equal_to(2 * pnorm(1) - 1, 0.6826895, tolerance = 1e-7)
equal_to(mean(c(1, -1) / c(3, 1)), -1 / 3)

# Q13: numerical quadrature checks the hand-integrated density and moments.
density_y <- function(y) 8 * y
equal_to(integrate(density_y, 0, 0.5)$value, 1)
mean_continuous <- integrate(function(y) y * density_y(y), 0, 0.5)$value
second_moment <- integrate(function(y) y^2 * density_y(y), 0, 0.5)$value
equal_to(mean_continuous, 1 / 3)
equal_to(second_moment - mean_continuous^2, 1 / 72)
equal_to(integrate(density_y, 0.25, 0.5)$value /
           integrate(density_y, 0.125, 0.5)$value, 4 / 5)
equal_to(integrate(function(y) (1 - 2 * y) * density_y(y), 0, 0.5)$value, 1 / 3)
equal_to(integrate(function(y) ((1 - 2 * y) - 1 / 3)^2 * density_y(y), 0, 0.5)$value, 1 / 18)
equal_to(integrate(density_y, 0, 0.25)$value, 1 / 4)

# Q14: build a deterministic sample with exactly the supplied sample moments.
standard_x <- as.numeric(scale(c(-1, -1, 1, 1)))
orthogonal <- as.numeric(scale(c(-1, 1, -1, 1)))
scale_data <- data.frame(x = 2 + 2 * standard_x,
                         y = 8 + 6 * (-0.5 * standard_x + sqrt(0.75) * orthogonal))
equal_to(c(mean(scale_data$x), mean(scale_data$y), sd(scale_data$x), sd(scale_data$y),
           cor(scale_data$x, scale_data$y)), c(2, 8, 2, 6, -0.5))
original_fit <- lm(y ~ x, data = scale_data)
reverse_fit <- lm(x ~ y, data = scale_data)
equal_to(coef(original_fit), c(11, -1.5))
equal_to(coef(reverse_fit)[2], -1 / 6)
scale_data$x_star <- scale_data$x / 4
scale_data$y_star <- 10 - 2 * scale_data$y
transformed_fit <- lm(y_star ~ x_star, data = scale_data)
equal_to(coef(transformed_fit), c(-12, 12))
equal_to(summary(transformed_fit)$r.squared, 1 / 4)
equal_to(summary(transformed_fit)$sigma / summary(original_fit)$sigma, 2)

message("Lecture 5: all deterministic numerical and algebraic checks passed.")
