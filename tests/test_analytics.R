
# tests/test_analytics.R - Validation of Chat2 logic (Fixed Paths)

cat("==== STARTING VALIDATION ====\n")
setwd("C:/Users/user/OneDrive - NHS/Documents/chat2")
cat("Current directory:", getwd(), "\n")

# Source directly
source("R/analytics.R")
cat("Sourced analytics.R\n")
source("R/plotting.R")
cat("Sourced plotting.R\n")

# Test 1: Data Loading
cat("Test 1: Loading results...")
results <- load_quality_results("results/complete_results.csv")
cat(" SUCCESS\n")
cat("  Datasets loaded:", nrow(results), "\n")

# Test 2: Risk Summary
cat("\nTest 2: Summarizing risk categories...\n")
risk_tab <- summarize_risk(results)
print(risk_tab)

# Test 3: Overfitting Calculation
cat("\nTest 3: Calculating overfitting stats...")
results_enhanced <- calculate_overfitting_stats(results)
cat(" SUCCESS\n")

# Test 4: High Risk Identification
cat("\nTest 4: Identifying high-risk datasets...")
hr <- identify_high_risk(results)
cat(" SUCCESS\n")
cat("  Found", nrow(hr), "high-risk candidates.\n")

cat("\n==== VALIDATION COMPLETED ====\n")
