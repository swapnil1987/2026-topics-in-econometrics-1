# Lecture 2 classroom code

Use the five [current notebooks and paired R scripts](../../colab/lecture-2/README.md)
for classroom delivery: LLN, CLT, unbiasedness, consistency, and p-values.

## Earlier combined examples (reference only)

Run `01_means_and_inference.R` first, then `02_ols_and_prediction.R`. Both source
the reusable functions in `R/lecture-02.R` and work with the working directory
set to either the repository root or `codes/lecture-2`. In an R session at the
root, use:

```r
source("codes/lecture-2/01_means_and_inference.R")
source("codes/lecture-2/02_ols_and_prediction.R")
```

From `codes/lecture-2`, use `source("01_means_and_inference.R")` and
`source("02_ols_and_prediction.R")`. Whole-script execution explicitly prints
the tables and plots. `Rscript` also works; its default graphics device may
write plots to `Rplots.pdf` in the working directory.

Only base R and the existing ggplot2 installation are used. From WSL at the
repository root, run the deterministic checks with:

```bash
~/miniconda3/bin/conda run --name topics-econometrics Rscript scripts/check-lecture-02.R
```

## Data and assumptions

All school data are simulated with seed **20260909**. One row represents one
classroom; class size is measured in students and its outcome in test-score
points. Class size is uniform on the integers 18 through 35. The default DGP is

```text
score = 95 - 0.6 * class_size + u
u = 8 * Z, Z ~ N(0, 1), independently across classrooms and of class size
```

Thus the conditional mean at 25 students is 80 points, the unconditional mean
is 79.1 points, and the conditional error variance is 64 points squared.
`small_class` is 1 for class sizes at most 25, otherwise 0. No scores are rounded
or truncated. This is a teaching model with no external source or data vintage;
it is not calibrated evidence about schools. A causal interpretation in real
data requires a design and assumptions beyond fitting this regression.

The optional heteroskedastic example replaces the error SD with
`4 + 0.3 * (class_size - 18)` and preserves zero conditional mean errors.
The separate hand example is exactly `x = 1:5`, `y = c(2, 4, 5, 4, 5)`:
intercept 2.2, slope 0.6, TSS 6, ESS 3.6, and RSS 2.4.

## Reusable API

Sourcing `R/lecture-02.R` only defines functions. Random-data helpers set the
supplied seed when called and advance the session's random-number state.
They default to seed 20260909 and do not write files or draw plots.

| Function | Arguments and return value |
| --- | --- |
| `lecture2_examples()` | `seed = 20260909, n = 400, heteroskedastic = FALSE`; named list with `school_data`, `hand_data`, and `dgp`. School columns: `class_size`, `small_class`, `score`, `conditional_mean`, `error_sd`. DGP metadata includes `intercept`, `slope`, `class_sizes`, `heteroskedastic`, `error_sd`, `population_mean`, `population_sd`. Metadata `error_sd` is `NA` for the heteroskedastic case; use the row-specific school column there. |
| `lecture2_z_summary()` | `estimate, standard_error, null_value = 0, level = 0.95`; one-row data frame with those inputs, `z_statistic`, `p_value`, `conf_low`, `conf_high`. Two-sided normal reference, not a Student t test. |
| `lecture2_ols_by_sums()` | `x, y`; list with named `coefficients` (`intercept`, `slope`), `n`, `mean_x`, `mean_y`, `sxx`, `sxy`, `fitted`, `residuals`, `tss`, `ess`, `rss`, `r_squared`. Includes an intercept; rejects missing/nonfinite inputs and constant x. R-squared is `NA` for constant y. |
| `lecture2_slope_se()` | `x, y`; one-row data frame with `homoskedastic` and `hc1` slope SEs. Both assume independence; the first also assumes constant conditional error variance. HC1 uses `n / (n - 2)`. |
| `lecture2_prediction_decomposition()` | `x, training_x, error_sd = 8, intercept = 95, slope = -0.6`; data frame with `x`, `conditional_mean`, `noise_variance`, `bias_squared`, `estimation_variance`, `mean_squared_prediction_error`. Exact for correctly specified simple OLS with an intercept, a fixed training design and iid errors of the supplied SD. |
| `lecture2_mean_coverage()` | `n = 30, repetitions = 1000, population_mean = 80, population_sd = 8, level = 0.95, seed = 20260909`; normal samples with known SD, returning `repetition`, `estimate`, `conf_low`, `conf_high`, `covered`. |
| `lecture2_ols_sampling()` | `training_x = rep(18:35, each = 5), repetitions = 1000, intercept = 95, slope = -0.6, error_sd = 8, seed = 20260909`; repeated OLS estimates conditional on the supplied design, returning `repetition`, `intercept`, `slope`, `homoskedastic_se`, `hc1_se`. Error SD can be scalar or one value per training observation. |

## Interpretation and optional exercises

The first script revisits Chapter 3's mean inference and confidence-interval
coverage. Chapter 4 covers OLS algebra, fit, assumptions, coefficient sampling
distributions, and the general prediction-error decomposition in Appendix 4.4.
Estimated coefficient SEs (including HC1) and the exact fixed-design,
homoskedastic prediction-variance formula are optional previews/extensions
beyond that formal chapter coverage. They are not extra assumptions required
for the chapter's general results. The optional OLS sampling helper reports
SEs as a preview alongside the sampling-distribution illustration.

Iid refers to sampling of the observation pairs `(X, Y)` and does not rule out
heteroskedasticity. Both SE formulas can be used with iid observation pairs;
only `homoskedastic` imposes constant conditional error variance.

The school-mean inference uses an estimated SE and a large-sample normal
approximation. The coverage exercise instead uses a separate normal population
with known SD, for which the z interval has exact nominal coverage. Its finite
simulation coverage still has Monte Carlo uncertainty.

Prediction risk holds **each test x fixed** and averages over training errors
and an independent new outcome error. It equals noise variance plus squared
bias plus estimation variance. Correctly specified OLS has zero conditional
bias here. The variance of fitted values across different class sizes is not
the estimator's variance at a fixed x. The supplied analytic decomposition is
for homoskedastic errors; do not apply it to the heteroskedastic preview.

For an optional sampling exercise, call `lecture2_ols_sampling()` and compare
`sd(draws$slope)` with the reported slope SEs. For heteroskedastic errors, pass
`error_sd = 4 + 0.3 * (training_x - 18)` with your chosen training design.
These are Monte Carlo illustrations, not deterministic proofs of SE accuracy.

The check script verifies hand OLS against `lm`, residual orthogonality,
TSS/ESS/RSS, the binary-regressor identity, numerical z inference, and HC1
against an independently assembled matrix sandwich. It also exhaustively
enumerates a small finite error distribution to verify prediction risk at
fixed x, without a Monte Carlo tolerance or an unconditional predictor variance.
