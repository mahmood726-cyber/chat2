
# tests/test_analytics.R - Validation of Chat2 logic

cat("==== STARTING VALIDATION ====\n")

# Resolve the package root relative to this test file so the suite runs
# from any working directory and on any machine.
this_file <- tryCatch(
  normalizePath(sys.frame(1)$ofile, mustWork = FALSE),
  error = function(e) NA_character_
)
if (is.na(this_file) || !nzchar(this_file)) {
  # Fallback: assume the test is invoked from the package root.
  pkg_root <- getwd()
} else {
  pkg_root <- normalizePath(file.path(dirname(this_file), ".."))
}
cat("Package root:", pkg_root, "\n")

source(file.path(pkg_root, "R", "analytics.R"))
cat("Sourced analytics.R\n")
source(file.path(pkg_root, "R", "plotting.R"))
cat("Sourced plotting.R\n")

# Test 1: Data Loading
cat("Test 1: Loading results...")
results <- load_quality_results(file.path(pkg_root, "results", "complete_results.csv"))
stopifnot(is.data.frame(results), nrow(results) > 0)
cat(" SUCCESS\n")
cat("  Datasets loaded:", nrow(results), "\n")

# Test 2: Risk Summary
cat("\nTest 2: Summarizing risk categories...\n")
risk_tab <- summarize_risk(results)
stopifnot(sum(risk_tab) == nrow(results))
print(risk_tab)

# Test 3: Overfitting Calculation
cat("\nTest 3: Calculating overfitting stats...")
results_enhanced <- calculate_overfitting_stats(results)
stopifnot("r2_gap" %in% names(results_enhanced))
cat(" SUCCESS\n")

# Test 4: High Risk Identification
cat("\nTest 4: Identifying high-risk datasets...")
hr <- identify_high_risk(results)
stopifnot(is.data.frame(hr), nrow(hr) <= nrow(results))
cat(" SUCCESS\n")
cat("  Found", nrow(hr), "high-risk candidates.\n")

cat("\n==== VALIDATION COMPLETED ====\n")
