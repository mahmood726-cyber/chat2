# R/analytics.R - Core Analytics for Meta-Analysis Quality Assessment

#' Load Meta-Analysis Quality Results
#' 
#' @param path Path to the complete_results.csv file
#' @return Data frame with quality metrics
#' @export
load_quality_results <- function(path = "results/complete_results.csv") {
  if (!file.exists(path)) {
    stop("Results file not found: ", path)
  }
  
  data <- read.csv(path, stringsAsFactors = FALSE)
  
  # Ensure factors are correctly typed
  if ("risk_category" %in% names(data)) {
    data$risk_category <- factor(data$risk_category, 
                                levels = c("Low", "Moderate", "High", "Critical"))
  }
  
  if ("data_quality" %in% names(data)) {
    data$data_quality <- factor(data$data_quality, 
                               levels = c("Low", "Medium", "High"))
  }
  
  return(data)
}

#' Summarize Risk Categories
#' 
#' @param data Data frame from load_quality_results
#' @return Summary table of risk categories
#' @export
summarize_risk <- function(data) {
  if (!"risk_category" %in% names(data)) {
    stop("Data must contain risk_category column")
  }
  
  table(data$risk_category, useNA = "ifany")
}

#' Calculate Overfitting Metrics
#' 
#' @param data Data frame from load_quality_results
#' @return Data frame with added overfitting columns
#' @export
calculate_overfitting_stats <- function(data) {
  # Calculate gap between apparent and cross-validated R2
  if (all(c("r2_apparent", "r2_cv") %in% names(data))) {
    data$r2_gap <- data$r2_apparent - data$r2_cv
    data$relative_shrinkage <- ifelse(data$r2_apparent > 0, 
                                     data$r2_gap / data$r2_apparent, 
                                     0)
  }
  
  return(data)
}

#' Identify High-Risk Datasets
#' 
#' @param data Data frame with quality metrics
#' @param kp_threshold K/P ratio threshold (default 10)
#' @param r2_gap_threshold R2 gap threshold (default 0.2)
#' @export
identify_high_risk <- function(data, kp_threshold = 10, r2_gap_threshold = 0.2) {
  kp_flag <- data$kp_ratio < kp_threshold
  r2_flag <- is.finite(data$r2_apparent) & is.finite(data$r2_cv) &
             (data$r2_apparent - data$r2_cv > r2_gap_threshold)

  # Treat NA flags as FALSE so they do not produce all-NA rows in the subset.
  select <- (kp_flag %in% TRUE) | (r2_flag %in% TRUE)

  high_risk <- data[select, ]

  return(high_risk)
}
