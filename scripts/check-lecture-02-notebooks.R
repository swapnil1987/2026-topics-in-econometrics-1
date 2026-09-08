#!/usr/bin/env Rscript
# Run from the repository root in the topics-econometrics Conda environment.
Sys.setenv(TZ = "UTC")
options(warn = 2)
args <- commandArgs(trailingOnly = TRUE)
output_dir <- if (length(args)) args[1] else tempfile("lecture2-check-", tmpdir = "/tmp")
if (dir.exists(output_dir) && length(list.files(output_dir, all.files = TRUE, no.. = TRUE))) {
  stop("Choose a new or empty output directory; existing results will not be overwritten.")
}
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
stems <- c("01_law_of_large_numbers", "02_central_limit_theorem", "03_unbiasedness",
           "04_consistency", "05_p_value")
notebooks <- file.path("colab/lecture-2", paste0(stems, ".ipynb"))
sources <- file.path("R/colab-lecture-02", paste0(stems, ".R"))
stopifnot(identical(sort(list.files("colab/lecture-2", pattern = "\\.ipynb$")),
                    paste0(stems, ".ipynb")))
record <- list(state = "running", started_utc = format(Sys.time(), tz = "UTC"),
  working_directory = getwd(), host = Sys.info()[["nodename"]],
  commit = system2("git", c("rev-parse", "HEAD"), stdout = TRUE),
  dirty_state = system2("git", c("status", "--short"), stdout = TRUE),
  command = paste("conda run --name topics-econometrics Rscript scripts/check-lecture-02-notebooks.R", output_dir),
  r_version = R.version.string, ggplot2_version = as.character(packageVersion("ggplot2")),
  seeds = 202609091:202609096,
  input_md5 = as.list(tools::md5sum(c(notebooks, sources))),
  output_directory = output_dir)
save_record <- function() jsonlite::write_json(record, file.path(output_dir, "run-record.json"),
                                               auto_unbox = TRUE, pretty = TRUE)
save_record()
sink(file.path(output_dir, "execution.log"), split = TRUE)
tryCatch({
  environments <- list()
  for (i in seq_along(stems)) {
    notebook <- jsonlite::fromJSON(notebooks[i], simplifyVector = FALSE)
    stopifnot(notebook$metadata$kernelspec$name == "ir")
    code <- Filter(function(cell) cell$cell_type == "code", notebook$cells)
    stopifnot(all(vapply(code, function(cell) is.null(cell$execution_count) &&
                          length(cell$outputs) == 0L, logical(1))))
    text <- paste(vapply(code, function(cell) paste(unlist(cell$source), collapse = ""),
                        character(1)), collapse = "\n")
    stopifnot(identical(parse(text = text, keep.source = FALSE),
                        parse(sources[i], keep.source = FALSE)))
    environment <- new.env(parent = globalenv())
    cat("\nRUN", stems[i], "\n")
    cairo_pdf(file.path(output_dir, paste0(stems[i], ".pdf")), width = 11, height = 7)
    tryCatch({
      for (expression in parse(text = text)) {
        result <- withVisible(eval(expression, envir = environment))
        if (result$visible) print(result$value)
      }
    }, finally = dev.off())
    environments[[i]] <- environment
  }
  a <- environments[[1]]; b <- environments[[2]]; c <- environments[[3]]
  d <- environments[[4]]; e <- environments[[5]]
  stopifnot(max(abs(a$running_mean - cumsum(a$earnings) / seq_along(a$earnings))) < 1e-10)
  stopifnot(max(abs(b$clt_draws$z - sqrt(b$clt_draws$n) *
                     (b$clt_draws$mean - b$population_mean) / b$population_sd)) < 1e-12)
  stopifnot(max(abs(c$estimates$shifted_mean - c$estimates$sample_mean - c$bias_shift)) < 1e-12)
  stopifnot(abs(e$observed_t - 2.0582) < 5e-5, abs(e$normal_p_value - 0.0396) < 5e-5)
  # Six-Monte-Carlo-SE bounds are stochastic sanity checks, not proofs of theorems.
  stopifnot(all(abs(b$clt_summary$simulated_mean) < 6 / sqrt(b$repetitions)))
  stopifnot(all(vapply(seq_along(b$sample_sizes), function(i) {
    values <- b$clt_draws$z[b$clt_draws$n == b$sample_sizes[i]]
    length(values) == b$repetitions &&
      abs(mean(values) - b$clt_summary$simulated_mean[i]) < 1e-12
  }, logical(1))))
  mean_mcse <- c(c$population_sd / sqrt(c$sample_size), c$population_sd,
                 c$population_sd / sqrt(c$sample_size)) / sqrt(c$repetitions)
  stopifnot(all(abs(c$unbiasedness_summary$simulation_average - c$expected_values) < 6 * mean_mcse))
  exact_risk <- vapply(seq_len(nrow(d$consistency_results)), function(i) {
    row <- d$consistency_results[i, ]
    shape <- if (row$rule == "first") 1 else row$n
    shift <- switch(row$rule, fixed_shift = 2, shrinking_shift = 10 / row$n, 0)
    lower <- d$population_mean - d$epsilon - 10 - shift
    upper <- d$population_mean + d$epsilon - 10 - shift
    pgamma(lower, shape, rate = shape / 10) +
      pgamma(upper, shape, rate = shape / 10, lower.tail = FALSE)
  }, numeric(1))
  stopifnot(all(abs(d$consistency_results$probability_large_error - exact_risk) <
                  6 * sqrt(exact_risk * (1 - exact_risk) / d$repetitions) + 1 / d$repetitions))
  stopifnot(abs(e$simulated_p_value - e$exact_normal_sample_p) < 6 * e$simulation_mc_se)
  stopifnot(all(file.info(file.path(output_dir, paste0(stems, ".pdf")))$size > 1000))
  print(sessionInfo())
  record$state <- "succeeded"
  record$validation <- "Five notebook executions; source parity; formula checks; six-MCSE stochastic sanity checks. Hosted Colab execution not tested."
  cat("\nALL FIVE NOTEBOOKS PASSED. Outputs:", output_dir, "\n")
}, error = function(error) {
  record$state <<- "failed"
  record$error <<- conditionMessage(error)
  stop(error)
}, finally = {
  record$finished_utc <- format(Sys.time(), tz = "UTC")
  save_record()
  sink()
})
