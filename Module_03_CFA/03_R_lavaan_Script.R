# ==============================================================================
# MODULE 03: CONFIRMATORY FACTOR ANALYSIS (CFA) WITH lavaan
# Course: Advanced Statistical Methods for Transportation & Behavioral Research
#         EFA, CFA, CB-SEM, and Regression Analysis
# Instructor: Dr. Mahbub Hassan
#             Department of Civil Engineering, Chulalongkorn University
#             mahbub.hassan@ieee.org
# ==============================================================================
# Reference: Rosseel, Y. (2012). lavaan: An R Package for Structural Equation
#            Modeling. Journal of Statistical Software, 48(2), 1-36.
# ==============================================================================

# ------------------------------------------------------------------------------
# SECTION 0: LOAD PACKAGES
# ------------------------------------------------------------------------------

# install.packages(c("lavaan", "semPlot", "semTools", "psych",
#                    "tidyverse", "lavaanPlot", "tidySEM"))

library(lavaan)      # CFA/SEM estimation
library(semPlot)     # Path diagram visualization
library(semTools)    # Additional SEM tools (reliability, invariance)
library(psych)       # AVE, composite reliability helpers
library(tidyverse)   # Data manipulation
library(lavaanPlot)  # Publication-quality diagrams (optional)

# ------------------------------------------------------------------------------
# SECTION 1: LOAD DATA
# ------------------------------------------------------------------------------

buts <- read.csv("../Datasets/BUTS_main.csv", stringsAsFactors = FALSE)

# Items retained from EFA (Module 02)
# Adjust based on your EFA results
retained_items <- c("PS1", "PS2", "PS3", "PS4",      # Perceived Safety
                    "SQ1", "SQ2", "SQ3", "SQ4",      # Service Quality
                    "EA1", "EA2", "EA3", "EA4",      # Environmental Attitude
                    "BI1", "BI2", "BI3")             # Behavioral Intention

cfa_data <- na.omit(buts[, retained_items])
cat("CFA Sample Size:", nrow(cfa_data), "\n")

# ------------------------------------------------------------------------------
# SECTION 2: SPECIFY THE CFA MODEL
# ------------------------------------------------------------------------------

# lavaan model syntax
# =~  means "is measured by" (reflective measurement)
# ~~  means "covariance/correlation"
# ~   means "regressed on" (for structural paths, used in SEM)

cfa_model <- '
  # Factor 1: Perceived Safety
  PS =~ PS1 + PS2 + PS3 + PS4

  # Factor 2: Service Quality
  SQ =~ SQ1 + SQ2 + SQ3 + SQ4

  # Factor 3: Environmental Attitude
  EA =~ EA1 + EA2 + EA3 + EA4

  # Factor 4: Behavioral Intention
  BI =~ BI1 + BI2 + BI3
'
# Note: lavaan automatically allows all factor covariances (latent ~~ latent)
# and fixes the first indicator loading to 1.0 for scale-setting by default.

# ------------------------------------------------------------------------------
# SECTION 3: ESTIMATE THE CFA MODEL
# ------------------------------------------------------------------------------

cat("===== CFA MODEL ESTIMATION =====\n\n")

# 3.1 Standard ML estimation
cfa_fit <- lavaan::cfa(
  model     = cfa_model,
  data      = cfa_data,
  estimator = "ML",         # Maximum Likelihood
  std.lv    = FALSE,        # FALSE: scale by fixing first loading to 1.0
                            # TRUE:  scale by fixing factor variance to 1.0
  missing   = "listwise"
)

# 3.2 Robust ML (for non-normal data — recommended when |skew| > 2)
cfa_fit_robust <- lavaan::cfa(
  model     = cfa_model,
  data      = cfa_data,
  estimator = "MLR",        # Robust ML (Yuan-Bentler)
  std.lv    = FALSE,
  missing   = "listwise"
)

# Use robust estimator results for reporting if data is non-normal
# For this script, we'll use standard ML as primary

# ------------------------------------------------------------------------------
# SECTION 4: MODEL FIT ASSESSMENT
# ------------------------------------------------------------------------------

cat("===== STEP 1: MODEL FIT INDICES =====\n\n")

# Extract fit measures
fit_indices <- lavaan::fitMeasures(cfa_fit,
  fit.measures = c("chisq", "df", "pvalue", "chisq.scaled", "df.scaled",
                   "cfi", "tli", "rmsea", "rmsea.ci.lower", "rmsea.ci.upper",
                   "rmsea.pvalue", "srmr", "aic", "bic"))

# Format and display fit table
cat("------------------------------------------------------------\n")
cat("FIT INDEX              VALUE      THRESHOLD    RESULT\n")
cat("------------------------------------------------------------\n")
chi_df_ratio <- fit_indices["chisq"] / fit_indices["df"]
cat(sprintf("%-22s %-10.3f %-12s %s\n", "χ² / df",
    chi_df_ratio, "≤ 3.0",
    ifelse(chi_df_ratio <= 3.0, "✓ ACCEPTABLE", "✗ POOR")))
cat(sprintf("%-22s %-10.3f %-12s %s\n", "χ²",
    fit_indices["chisq"], "", ""))
cat(sprintf("%-22s %-10d %-12s\n", "df",
    as.integer(fit_indices["df"]), ""))
cat(sprintf("%-22s %-10.4f %-12s\n", "p-value",
    fit_indices["pvalue"], ""))
cat(sprintf("%-22s %-10.3f %-12s %s\n", "CFI",
    fit_indices["cfi"], "≥ 0.90",
    ifelse(fit_indices["cfi"] >= 0.95, "✓ GOOD",
           ifelse(fit_indices["cfi"] >= 0.90, "✓ ACCEPTABLE", "✗ POOR"))))
cat(sprintf("%-22s %-10.3f %-12s %s\n", "TLI",
    fit_indices["tli"], "≥ 0.90",
    ifelse(fit_indices["tli"] >= 0.95, "✓ GOOD",
           ifelse(fit_indices["tli"] >= 0.90, "✓ ACCEPTABLE", "✗ POOR"))))
cat(sprintf("%-22s %-10.3f %-12s %s\n", "RMSEA",
    fit_indices["rmsea"], "≤ 0.08",
    ifelse(fit_indices["rmsea"] <= 0.06, "✓ GOOD",
           ifelse(fit_indices["rmsea"] <= 0.08, "✓ ACCEPTABLE", "✗ POOR"))))
cat(sprintf("%-22s [%.3f, %.3f]\n", "RMSEA 90% CI",
    fit_indices["rmsea.ci.lower"], fit_indices["rmsea.ci.upper"]))
cat(sprintf("%-22s %-10.4f %-12s\n", "p(RMSEA ≤ .05)",
    fit_indices["rmsea.pvalue"], ""))
cat(sprintf("%-22s %-10.3f %-12s %s\n", "SRMR",
    fit_indices["srmr"], "≤ 0.08",
    ifelse(fit_indices["srmr"] <= 0.06, "✓ GOOD",
           ifelse(fit_indices["srmr"] <= 0.08, "✓ ACCEPTABLE", "✗ POOR"))))
cat("------------------------------------------------------------\n")
cat(sprintf("AIC = %.1f | BIC = %.1f\n", fit_indices["aic"], fit_indices["bic"]))

# Overall assessment
all_acceptable <- (chi_df_ratio <= 3.0 & fit_indices["cfi"] >= 0.90 &
                   fit_indices["tli"] >= 0.90 & fit_indices["rmsea"] <= 0.08 &
                   fit_indices["srmr"] <= 0.08)
cat("\nOverall fit:", ifelse(all_acceptable, "MODEL FIT IS ACCEPTABLE", "MODEL FIT NEEDS IMPROVEMENT"), "\n")

# ------------------------------------------------------------------------------
# SECTION 5: PARAMETER ESTIMATES — FACTOR LOADINGS
# ------------------------------------------------------------------------------

cat("\n\n===== STEP 2: FACTOR LOADINGS =====\n\n")

# Standardized solution (what we report)
std_solution <- lavaan::standardizedSolution(cfa_fit)

# Extract loadings only (op == "=~")
loadings_std <- std_solution[std_solution$op == "=~", ]

cat("Standardized Factor Loadings:\n")
cat(sprintf("%-6s %-6s %-10s %-10s %-10s %-10s %-12s\n",
            "Factor", "Item", "Loading", "SE", "z-value", "p-value", "Sig."))
cat(strrep("-", 65), "\n")

for(i in 1:nrow(loadings_std)) {
  sig <- ifelse(loadings_std$pvalue[i] < 0.001, "***",
         ifelse(loadings_std$pvalue[i] < 0.01, "**",
         ifelse(loadings_std$pvalue[i] < 0.05, "*", "ns")))
  flag <- ifelse(loadings_std$est.std[i] < 0.50, " ← Low",
          ifelse(loadings_std$est.std[i] >= 0.70, " ← Strong", ""))
  cat(sprintf("%-6s %-6s %-10.3f %-10.3f %-10.3f %-10.4f %-3s%s\n",
              loadings_std$lhs[i], loadings_std$rhs[i],
              loadings_std$est.std[i], loadings_std$se[i],
              loadings_std$z[i], loadings_std$pvalue[i],
              sig, flag))
}
cat(strrep("-", 65), "\n")
cat("Significance: *** p < .001, ** p < .01, * p < .05, ns = not significant\n")

# ------------------------------------------------------------------------------
# SECTION 6: CONVERGENT VALIDITY — AVE AND COMPOSITE RELIABILITY
# ------------------------------------------------------------------------------

cat("\n\n===== STEP 3: CONVERGENT VALIDITY =====\n\n")

# Function to compute AVE and CR from standardized loadings
compute_validity <- function(fit, factor_name) {
  std_sol  <- lavaan::standardizedSolution(fit)
  loadings <- std_sol[std_sol$op == "=~" & std_sol$lhs == factor_name, "est.std"]

  n_items     <- length(loadings)
  sum_load_sq <- sum(loadings^2)
  sum_error   <- sum(1 - loadings^2)

  AVE <- sum_load_sq / (sum_load_sq + sum_error)
  CR  <- (sum(loadings))^2 / ((sum(loadings))^2 + sum_error)

  return(c(
    n_items = n_items,
    AVE     = round(AVE, 3),
    CR      = round(CR, 3),
    sqrt_AVE= round(sqrt(AVE), 3)
  ))
}

# Compute for all factors
factors <- c("PS", "SQ", "EA", "BI")
factor_labels <- c("Perceived Safety", "Service Quality",
                   "Environmental Attitude", "Behavioral Intention")

cat("Convergent Validity Assessment:\n")
cat(sprintf("%-30s %-8s %-8s %-8s %-12s %-12s\n",
            "Construct", "Items", "CR", "AVE", "√AVE", "Interpretation"))
cat(strrep("-", 80), "\n")

validity_results <- list()
for(i in seq_along(factors)) {
  v <- compute_validity(cfa_fit, factors[i])
  validity_results[[factors[i]]] <- v

  cr_ok  <- v["CR"]  >= 0.70
  ave_ok <- v["AVE"] >= 0.50

  interp <- if(cr_ok & ave_ok) "✓ VALID"
             else if(cr_ok)    "△ CR OK; AVE borderline"
             else               "✗ Needs revision"

  cat(sprintf("%-30s %-8s %-8.3f %-8.3f %-12.3f %-12s\n",
              factor_labels[i], v["n_items"], v["CR"], v["AVE"], v["sqrt_AVE"], interp))
}
cat(strrep("-", 80), "\n")
cat("Criteria: CR ≥ 0.70; AVE ≥ 0.50\n")

# ------------------------------------------------------------------------------
# SECTION 7: DISCRIMINANT VALIDITY — HTMT AND FORNELL-LARCKER
# ------------------------------------------------------------------------------

cat("\n\n===== STEP 4: DISCRIMINANT VALIDITY =====\n\n")

# 7.1 Factor Correlations
cat("Latent Factor Correlations:\n")
factor_cor <- lavaan::lavInspect(cfa_fit, what = "cor.lv")
print(round(factor_cor, 3))

# 7.2 Fornell-Larcker Criterion
cat("\n--- Fornell-Larcker Criterion (√AVE > inter-factor correlations) ---\n")
sqrt_aves <- sapply(factors, function(f) {
  v <- validity_results[[f]]
  v["sqrt_AVE"]
})

cat(sprintf("\n%-30s %s\n", "Construct", paste(factor_labels, collapse = " | ")))
cat(strrep("-", 100), "\n")
for(i in seq_along(factors)) {
  row_vals <- sapply(seq_along(factors), function(j) {
    if(i == j) sprintf("[%.3f]", sqrt_aves[i])     # √AVE on diagonal
    else sprintf("%.3f", abs(factor_cor[i, j]))     # correlation off-diagonal
  })
  cat(sprintf("%-30s %s\n", factor_labels[i], paste(row_vals, collapse = " | ")))
}
cat("\nNote: [bracketed] = √AVE. Discriminant validity: √AVE > all off-diagonal values in row/column.\n")

# 7.3 HTMT via semTools
cat("\n--- HTMT Ratios (Henseler et al., 2015) ---\n")
htmt_result <- semTools::htmt(model = cfa_model, data = cfa_data)
print(round(htmt_result, 3))
cat("\nCriterion: HTMT < 0.85 supports discriminant validity\n")
cat("           HTMT < 0.90 (lenient threshold)\n")

# Check violations
htmt_matrix <- as.matrix(htmt_result)
violations <- which(htmt_matrix >= 0.85 & upper.tri(htmt_matrix), arr.ind = TRUE)
if(nrow(violations) > 0) {
  cat("\n⚠️  HTMT violations (≥ 0.85):\n")
  for(k in 1:nrow(violations)) {
    r <- violations[k, ]
    cat(rownames(htmt_matrix)[r[1]], "—", colnames(htmt_matrix)[r[2]],
        ": HTMT =", round(htmt_matrix[r[1], r[2]], 3), "\n")
  }
} else {
  cat("\n✓ All HTMT values < 0.85. Discriminant validity supported.\n")
}

# ------------------------------------------------------------------------------
# SECTION 8: MODIFICATION INDICES (IF FIT IS POOR)
# ------------------------------------------------------------------------------

cat("\n\n===== STEP 5: MODIFICATION INDICES (if needed) =====\n\n")

# Get modification indices
mi <- lavaan::modindices(cfa_fit, sort. = TRUE, maximum.number = 15,
                          op = c("=~", "~~"))

cat("Top 15 Modification Indices:\n")
print(mi[, c("lhs", "op", "rhs", "mi", "epc", "sepc.all")])

cat("\n")
cat("Interpretation:\n")
cat("  mi    = Expected improvement in χ² if parameter is freed\n")
cat("  epc   = Expected parameter change\n")
cat("  sepc.all = Standardized expected parameter change\n")
cat("\n")
cat("Common meaningful modifications:\n")
cat("  '~~' (error covariances): Free only when items have similar wording\n")
cat("  '=~' (cross-loadings): Free only with strong theoretical justification\n")
cat("  RULE: Always justify modification with theory; limit to 3-4 changes\n")

# Example: If modifying error covariance between PS1 and PS2 (if similar wording)
# cfa_model_mod <- '
#   PS =~ PS1 + PS2 + PS3 + PS4
#   SQ =~ SQ1 + SQ2 + SQ3 + SQ4
#   EA =~ EA1 + EA2 + EA3 + EA4
#   BI =~ BI1 + BI2 + BI3
#   PS1 ~~ PS2   # Freed error covariance (theoretical justification required)
# '
# cfa_fit_mod <- lavaan::cfa(cfa_model_mod, data = cfa_data, estimator = "ML")
# lavaan::anova(cfa_fit, cfa_fit_mod)  # Chi-square difference test

# ------------------------------------------------------------------------------
# SECTION 9: MEASUREMENT INVARIANCE TESTING (MULTI-GROUP)
# ------------------------------------------------------------------------------

cat("\n\n===== STEP 6: MEASUREMENT INVARIANCE (Multi-Group) =====\n\n")

# Test measurement invariance across Gender groups (Male vs. Female)
# Requires: Gender variable coded as factor with 2 levels

buts_gender <- buts[!is.na(buts$Gender) & buts$Gender %in% c(1, 2),
                    c(retained_items, "Gender")]
buts_gender$Gender_f <- factor(buts_gender$Gender, labels = c("Male", "Female"))
buts_gender_complete <- na.omit(buts_gender)

cat("Sample sizes by gender:\n")
print(table(buts_gender_complete$Gender_f))

# Step 1: Configural invariance (same structure, all parameters free)
fit_configural <- lavaan::cfa(cfa_model, data = buts_gender_complete,
                               group = "Gender_f", estimator = "ML")

# Step 2: Metric invariance (constrain loadings equal)
fit_metric <- lavaan::cfa(cfa_model, data = buts_gender_complete,
                           group = "Gender_f",
                           group.equal = "loadings",
                           estimator = "ML")

# Step 3: Scalar invariance (constrain loadings + intercepts equal)
fit_scalar <- lavaan::cfa(cfa_model, data = buts_gender_complete,
                           group = "Gender_f",
                           group.equal = c("loadings", "intercepts"),
                           estimator = "ML")

# Compare models
cat("\n--- Measurement Invariance Tests ---\n")
invariance_results <- lavaan::compareFit(fit_configural, fit_metric, fit_scalar)

# Extract comparison
inv_fit <- lavaan::lavTestScore(fit_metric)

# Manual comparison
configs <- lavaan::fitMeasures(fit_configural, c("cfi", "rmsea", "srmr", "df", "chisq"))
metrics <- lavaan::fitMeasures(fit_metric,     c("cfi", "rmsea", "srmr", "df", "chisq"))
scalars <- lavaan::fitMeasures(fit_scalar,     c("cfi", "rmsea", "srmr", "df", "chisq"))

cat(sprintf("%-20s %-8s %-8s %-8s %-8s %-8s %-8s\n",
            "Model", "χ²", "df", "CFI", "ΔCFI", "RMSEA", "SRMR"))
cat(strrep("-", 70), "\n")

models_list <- list(Configural = configs, Metric = metrics, Scalar = scalars)
prev_cfi <- NA
for(m_name in names(models_list)) {
  m_fit <- models_list[[m_name]]
  delta_cfi <- if(is.na(prev_cfi)) "—" else sprintf("%.3f", m_fit["cfi"] - prev_cfi)
  cat(sprintf("%-20s %-8.1f %-8d %-8.3f %-8s %-8.3f %-8.3f\n",
              m_name,
              m_fit["chisq"], as.integer(m_fit["df"]),
              m_fit["cfi"], delta_cfi,
              m_fit["rmsea"], m_fit["srmr"]))
  prev_cfi <- m_fit["cfi"]
}
cat(strrep("-", 70), "\n")
cat("Criterion for invariance: |ΔCFI| ≤ .010 (Cheung & Rensvold, 2002)\n")
cat("                          |ΔRMSEA| ≤ .015 is also sometimes used\n")

# ------------------------------------------------------------------------------
# SECTION 10: PATH DIAGRAM
# ------------------------------------------------------------------------------

cat("\n===== STEP 7: PATH DIAGRAM =====\n\n")

# semPlot path diagram
semPlot::semPaths(
  cfa_fit,
  what        = "std",          # Show standardized estimates
  whatLabels  = "std",
  layout      = "tree2",
  rotation    = 2,
  edge.label.cex = 0.75,
  node.label.cex = 0.85,
  sizeMan     = 7,
  sizeLat     = 10,
  color       = list(lat = "#1565C0", man = "#BBDEFB"),
  edge.color  = "#424242",
  title       = TRUE,
  title.color = "black",
  title.adj   = 0.5,
  mar         = c(3, 3, 3, 3),
  main        = "CFA Measurement Model\nBangkok Urban Transportation Survey"
)

# ------------------------------------------------------------------------------
# SECTION 11: SUMMARY TABLE FOR PUBLICATION
# ------------------------------------------------------------------------------

cat("\n===== FINAL: PUBLICATION SUMMARY =====\n\n")

# Compile full measurement model table
all_loadings <- std_solution[std_solution$op == "=~",
                              c("lhs", "rhs", "est.std", "se", "z", "pvalue")]
names(all_loadings) <- c("Factor", "Item", "Loading", "SE", "z", "p")
all_loadings$Sig <- ifelse(all_loadings$p < 0.001, "***",
                    ifelse(all_loadings$p < 0.01, "**",
                    ifelse(all_loadings$p < 0.05, "*", "ns")))

cat("Complete Measurement Model Table:\n")
print(all_loadings, digits = 3, row.names = FALSE)

cat("\nFit Summary: χ²/df =", round(chi_df_ratio, 3),
    "| CFI =", round(fit_indices["cfi"], 3),
    "| TLI =", round(fit_indices["tli"], 3),
    "| RMSEA =", round(fit_indices["rmsea"], 3),
    "| SRMR =", round(fit_indices["srmr"], 3), "\n")

# Save results
dir.create("../Datasets/Output", showWarnings = FALSE, recursive = TRUE)
write.csv(all_loadings, "../Datasets/Output/03_CFA_loadings.csv", row.names = FALSE)
write.csv(as.data.frame(fit_indices), "../Datasets/Output/03_CFA_fit_indices.csv")

cat("\n===== MODULE 03 COMPLETE =====\n")
cat("✓ CFA model specified and estimated\n")
cat("✓ Model fit assessed (CFI, TLI, RMSEA, SRMR)\n")
cat("✓ Convergent validity evaluated (loadings, CR, AVE)\n")
cat("✓ Discriminant validity tested (HTMT, Fornell-Larcker)\n")
cat("✓ Measurement invariance tested (if applicable)\n")
cat("Proceed to Module 04: CB-SEM Structural Model\n")

# ==============================================================================
# END OF MODULE 03 SCRIPT
# ==============================================================================
