cat("R is working
")
cat("Checking ggplot2...")
if (requireNamespace("ggplot2", quietly = TRUE)) {
  cat(" ggplot2 is available
")
} else {
  cat(" ggplot2 is MISSING
")
}
