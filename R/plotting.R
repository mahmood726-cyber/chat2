# R/plotting.R - Visualization for Meta-Analysis Quality

#' Plot K/P Ratio Distribution
#' 
#' @param data Data frame with quality metrics
#' @export
plot_kp_distribution <- function(data) {
  ggplot2::ggplot(data, ggplot2::aes(x = risk_category, y = kp_ratio, fill = risk_category)) +
    ggplot2::geom_boxplot() +
    ggplot2::scale_y_log10() +
    ggplot2::theme_minimal() +
    ggplot2::labs(title = "K/P Ratio by Risk Category",
                  x = "Risk Category",
                  y = "K/P Ratio (log scale)")
}

#' Plot Overfitting Gap
#' 
#' @param data Data frame with quality metrics
#' @export
plot_overfitting_gap <- function(data) {
  # Filter for cases where R2 is calculated
  plot_data <- data[is.finite(data$r2_apparent) & is.finite(data$r2_cv), ]
  
  ggplot2::ggplot(plot_data, ggplot2::aes(x = r2_apparent, y = r2_cv, color = risk_category)) +
    ggplot2::geom_point(size = 3, alpha = 0.7) +
    ggplot2::geom_abline(intercept = 0, slope = 1, linetype = "dashed") +
    ggplot2::theme_minimal() +
    ggplot2::labs(title = "Apparent vs. Cross-Validated R²",
                  subtitle = "Points below the line indicate overfitting",
                  x = "Apparent R²",
                  y = "CV R²")
}

#' Plot Heterogeneity vs. Risk
#' 
#' @param data Data frame with quality metrics
#' @export
plot_heterogeneity_risk <- function(data) {
  ggplot2::ggplot(data, ggplot2::aes(x = I2_null, y = risk_category, fill = risk_category)) +
    ggplot2::geom_violin(alpha = 0.5) +
    ggplot2::geom_jitter(height = 0.2, alpha = 0.3) +
    ggplot2::theme_minimal() +
    ggplot2::labs(title = "Baseline Heterogeneity by Risk Category",
                  x = "I² (%)",
                  y = "Risk Category")
}
