# ==============================================================================
# MODULE 04: COVARIANCE-BASED SEM (CB-SEM) WITH lavaan
# Course: Advanced Statistical Methods for Transportation & Behavioral Research
#         EFA, CFA, CB-SEM, and Regression Analysis
# Instructor: Dr. Mahbub Hassan
#             Department of Civil Engineering, Chulalongkorn University
#             mahbub.hassan@ieee.org
# ==============================================================================

library(lavaan)
library(semPlot)
library(semTools)
library(tidyverse)

# ------------------------------------------------------------------------------
# SECTION 1: LOAD DATA
# ------------------------------------------------------------------------------

buts <- read.csv("../Datasets/BUTS_main.csv", stringsAsFactors = FALSE)
sem_data <- na.omit(buts[, c("PS1","PS2","PS3","PS4",
                              "SQ1","SQ2","SQ3","SQ4",
                              "EA1","EA2","EA3","EA4",
                              "BI1","BI2","BI3",
                              "AB1","AB2","AB3")])
cat("SEM Sample Size:", nrow(sem_data), "\n")

# ------------------------------------------------------------------------------
# SECTION 2: FULL SEM MODEL SPECIFICATION
# ------------------------------------------------------------------------------

full_sem_model <- '
  # ============================================================
  # MEASUREMENT MODEL
  # ============================================================
  # Exogenous constructs (predictors)
  PS =~ PS1 + PS2 + PS3 + PS4     # Perceived Safety
  SQ =~ SQ1 + SQ2 + SQ3 + SQ4     # Service Quality
  EA =~ EA1 + EA2 + EA3 + EA4     # Environmental Attitude

  # Endogenous constructs (outcomes)
  BI =~ BI1 + BI2 + BI3           # Behavioral Intention
  AB =~ AB1 + AB2 + AB3           # Actual Behavior

  # ============================================================
  # STRUCTURAL MODEL
  # ============================================================
  # H1: Perceived Safety → Behavioral Intention
  # H2: Service Quality  → Behavioral Intention
  # H3: Environmental Attitude → Behavioral Intention
  # H4: Behavioral Intention → Actual Behavior
  # H5: Perceived Safety → Actual Behavior (direct)

  BI ~ a1*PS + a2*SQ + a3*EA
  AB ~ b1*BI + b2*PS

  # ============================================================
  # DEFINED PARAMETERS: Indirect & Total Effects
  # ============================================================
  # Indirect effect of PS on AB via BI
  ind_PS_AB   := a1 * b1
  # Indirect effect of SQ on AB via BI
  ind_SQ_AB   := a2 * b1
  # Indirect effect of EA on AB via BI
  ind_EA_AB   := a3 * b1
  # Total effect of PS on AB (direct + indirect)
  total_PS_AB := b2 + a1 * b1
'

# ------------------------------------------------------------------------------
# SECTION 3: ESTIMATE FULL SEM MODEL
# ------------------------------------------------------------------------------

cat("\n===== FULL SEM ESTIMATION =====\n\n")

sem_fit <- lavaan::sem(
  model     = full_sem_model,
  data      = sem_data,
  estimator = "ML",
  missing   = "listwise",
  se        = "bootstrap",    # Bootstrap SE for mediation testing
  bootstrap = 5000
)

# Also run standard (faster) for initial inspection
sem_fit_std <- lavaan::sem(
  model     = full_sem_model,
  data      = sem_data,
  estimator = "MLR",
  missing   = "listwise"
)

# ------------------------------------------------------------------------------
# SECTION 4: MODEL FIT ASSESSMENT
# ------------------------------------------------------------------------------

cat("===== MODEL FIT INDICES =====\n\n")

fit_idx <- lavaan::fitMeasures(sem_fit_std,
  c("chisq","df","pvalue","cfi","tli","rmsea",
    "rmsea.ci.lower","rmsea.ci.upper","srmr","aic","bic"))

cat(sprintf("χ²(df=%d) = %.3f, p = %.4f\n",
            as.integer(fit_idx["df"]), fit_idx["chisq"], fit_idx["pvalue"]))
cat(sprintf("χ²/df = %.3f  [Threshold ≤ 3.0]\n", fit_idx["chisq"]/fit_idx["df"]))
cat(sprintf("CFI   = %.3f  [Threshold ≥ 0.90]\n", fit_idx["cfi"]))
cat(sprintf("TLI   = %.3f  [Threshold ≥ 0.90]\n", fit_idx["tli"]))
cat(sprintf("RMSEA = %.3f  [%.3f, %.3f]  [Threshold ≤ 0.08]\n",
            fit_idx["rmsea"], fit_idx["rmsea.ci.lower"], fit_idx["rmsea.ci.upper"]))
cat(sprintf("SRMR  = %.3f  [Threshold ≤ 0.08]\n", fit_idx["srmr"]))
cat(sprintf("AIC   = %.1f\n", fit_idx["aic"]))
cat(sprintf("BIC   = %.1f\n", fit_idx["bic"]))

# ------------------------------------------------------------------------------
# SECTION 5: STRUCTURAL PATH COEFFICIENTS
# ------------------------------------------------------------------------------

cat("\n\n===== STRUCTURAL PATH RESULTS =====\n\n")

std_solution <- lavaan::standardizedSolution(sem_fit_std)

# Extract structural paths only
struct_paths <- std_solution[std_solution$op == "~",
                              c("lhs","op","rhs","est.std","se","z","pvalue")]
names(struct_paths) <- c("Outcome","Op","Predictor","Beta","SE","z","p")

cat("Standardized Path Coefficients:\n")
cat(sprintf("%-8s %-5s %-8s %-8s %-8s %-8s %-10s %-5s\n",
            "H", "Path", "From", "To", "β", "SE", "t/z", "Sig"))
cat(strrep("-", 70), "\n")

hyps <- data.frame(
  From  = c("PS","SQ","EA","BI","PS"),
  To    = c("BI","BI","BI","AB","AB"),
  Label = c("H1","H2","H3","H4","H5"),
  stringsAsFactors = FALSE
)

for(i in 1:nrow(hyps)) {
  row <- struct_paths[struct_paths$Predictor == hyps$From[i] &
                        struct_paths$Outcome  == hyps$To[i], ]
  if(nrow(row) > 0) {
    sig <- ifelse(row$p < .001, "***", ifelse(row$p < .01, "**",
           ifelse(row$p < .05, "*", "ns")))
    supp <- ifelse(row$p < .05, "✓ Yes", "✗ No")
    cat(sprintf("%-8s %-5s %-8s %-8s %-8.3f %-8.3f %-10.3f %-5s [%s]\n",
                hyps$Label[i],
                paste(hyps$From[i], "→", hyps$To[i]),
                hyps$From[i], hyps$To[i],
                row$Beta, row$SE, row$z, sig, supp))
  }
}
cat(strrep("-", 70), "\n")
cat("*** p<.001, ** p<.01, * p<.05, ns not significant\n")

# R² for endogenous variables
cat("\nR² (Variance Explained):\n")
r2 <- lavaan::inspect(sem_fit_std, "r2")
for(v in names(r2)) {
  if(v %in% c("BI","AB")) {
    cat(sprintf("  R²(%s) = %.3f  (%.1f%% variance explained)\n",
                v, r2[[v]], r2[[v]] * 100))
  }
}

# ------------------------------------------------------------------------------
# SECTION 6: INDIRECT EFFECTS AND MEDIATION ANALYSIS
# ------------------------------------------------------------------------------

cat("\n\n===== MEDIATION ANALYSIS (BOOTSTRAPPED) =====\n\n")

# Extract defined parameters with bootstrapped CIs
params <- lavaan::parameterEstimates(
  sem_fit,
  boot.ci.type = "bca.simple",
  level        = 0.95
)

# Filter for defined parameters (:=)
defined_params <- params[params$op == ":=",
                          c("lhs","label","est","se","z","pvalue","ci.lower","ci.upper")]

cat("Indirect and Total Effects (Bootstrap CI, 5000 samples):\n")
cat(sprintf("%-20s %-10s %-8s %-12s %-10s\n",
            "Effect", "Estimate", "SE", "95% BCa CI", "Sig?"))
cat(strrep("-", 65), "\n")

effect_labels <- c(
  ind_PS_AB   = "PS → BI → AB (indirect)",
  ind_SQ_AB   = "SQ → BI → AB (indirect)",
  ind_EA_AB   = "EA → BI → AB (indirect)",
  total_PS_AB = "PS → AB (total)"
)

for(i in 1:nrow(defined_params)) {
  effect_name <- effect_labels[defined_params$lhs[i]]
  if(!is.na(effect_name)) {
    sig <- ifelse(defined_params$ci.lower[i] > 0 | defined_params$ci.upper[i] < 0,
                  "✓ Yes", "✗ No")
    cat(sprintf("%-25s %-10.3f %-8.3f [%-5.3f, %-5.3f] %s\n",
                effect_name,
                defined_params$est[i], defined_params$se[i],
                defined_params$ci.lower[i], defined_params$ci.upper[i],
                sig))
  }
}
cat(strrep("-", 65), "\n")
cat("Mediation supported if 95% CI does not include zero.\n")
cat("Bootstrap samples: 5000, BCa confidence interval method.\n")

# Variance Accounted For (VAF) — proportion mediated
cat("\nVariance Accounted For (VAF) = Indirect / Total × 100:\n")
for(from in c("PS","SQ","EA")) {
  ind  <- defined_params$est[defined_params$lhs == paste0("ind_",from,"_AB")]
  dir  <- struct_paths$Beta[struct_paths$Predictor == from & struct_paths$Outcome == "AB"]
  if(length(ind) > 0 && length(dir) > 0) {
    total <- ind + dir
    vaf <- (ind / total) * 100
    med_type <- ifelse(abs(dir) < 0.05, "Full mediation",
                       ifelse(vaf > 20, "Partial mediation", "Complementary"))
    cat(sprintf("  %s: VAF = %.1f%% → %s\n", from, vaf, med_type))
  } else if(length(ind) > 0) {
    cat(sprintf("  %s: Indirect only (no direct path specified)\n", from))
  }
}

# ------------------------------------------------------------------------------
# SECTION 7: PATH DIAGRAM
# ------------------------------------------------------------------------------

cat("\n===== PATH DIAGRAM =====\n\n")

semPlot::semPaths(
  sem_fit_std,
  what       = "std",
  whatLabels = "std",
  layout     = "tree2",
  rotation   = 2,
  edge.label.cex = 0.65,
  node.label.cex = 0.80,
  sizeMan    = 5,
  sizeLat    = 12,
  color      = list(
    lat = c("#1565C0","#1565C0","#1565C0",  # exogenous blue
            "#D32F2F","#D32F2F"),           # endogenous red
    man = "#E3F2FD"
  ),
  edge.color = "#555555",
  title      = TRUE,
  main       = "Full SEM Model — Bangkok Urban Transportation Survey\nStandardized Estimates",
  mar        = c(2, 2, 3, 2)
)

# ------------------------------------------------------------------------------
# SECTION 8: MODEL COMPARISON (Full vs. Nested Models)
# ------------------------------------------------------------------------------

cat("\n===== MODEL COMPARISON =====\n\n")

# Reduced model: Remove direct PS → AB path (H5)
reduced_sem <- '
  PS =~ PS1 + PS2 + PS3 + PS4
  SQ =~ SQ1 + SQ2 + SQ3 + SQ4
  EA =~ EA1 + EA2 + EA3 + EA4
  BI =~ BI1 + BI2 + BI3
  AB =~ AB1 + AB2 + AB3

  BI ~ PS + SQ + EA
  AB ~ BI            # No direct PS → AB
'

sem_fit_reduced <- lavaan::sem(reduced_sem, data = sem_data, estimator = "MLR")

# Chi-square difference test
lavTestLRT(sem_fit_std, sem_fit_reduced)

fit_full    <- lavaan::fitMeasures(sem_fit_std,     c("chisq","df","cfi","rmsea","aic"))
fit_reduced <- lavaan::fitMeasures(sem_fit_reduced, c("chisq","df","cfi","rmsea","aic"))

cat("Model Comparison:\n")
cat(sprintf("%-15s %-8s %-6s %-8s %-8s %-10s\n",
            "Model","χ²","df","CFI","RMSEA","AIC"))
cat(sprintf("%-15s %-8.2f %-6d %-8.3f %-8.3f %-10.1f\n",
            "Full",
            fit_full["chisq"], as.integer(fit_full["df"]),
            fit_full["cfi"], fit_full["rmsea"], fit_full["aic"]))
cat(sprintf("%-15s %-8.2f %-6d %-8.3f %-8.3f %-10.1f\n",
            "Reduced",
            fit_reduced["chisq"], as.integer(fit_reduced["df"]),
            fit_reduced["cfi"], fit_reduced["rmsea"], fit_reduced["aic"]))

# ------------------------------------------------------------------------------
# SECTION 9: EXPORT RESULTS
# ------------------------------------------------------------------------------

dir.create("../Datasets/Output", showWarnings = FALSE, recursive = TRUE)

# Save structural paths
write.csv(struct_paths, "../Datasets/Output/04_SEM_structural_paths.csv", row.names = FALSE)

# Save fit indices
fit_summary <- data.frame(
  Index = c("chi2", "df", "chi2_df", "CFI", "TLI", "RMSEA",
            "RMSEA_lo", "RMSEA_hi", "SRMR", "AIC", "BIC"),
  Value = c(fit_idx["chisq"], fit_idx["df"],
            fit_idx["chisq"]/fit_idx["df"],
            fit_idx["cfi"], fit_idx["tli"], fit_idx["rmsea"],
            fit_idx["rmsea.ci.lower"], fit_idx["rmsea.ci.upper"],
            fit_idx["srmr"], fit_idx["aic"], fit_idx["bic"])
)
write.csv(fit_summary, "../Datasets/Output/04_SEM_fit_indices.csv", row.names = FALSE)

cat("\n===== MODULE 04 COMPLETE =====\n")
cat("✓ Full SEM model specified and estimated\n")
cat("✓ Structural paths assessed (β, SE, t, p)\n")
cat("✓ R² computed for endogenous constructs\n")
cat("✓ Mediation analysis with bootstrapped CIs\n")
cat("✓ Model comparison conducted\n")
cat("Proceed to Module 05: Regression Analysis\n")

# ==============================================================================
# END OF MODULE 04 SCRIPT
# ==============================================================================
