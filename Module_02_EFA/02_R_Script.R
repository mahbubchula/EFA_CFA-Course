# ==============================================================================
# MODULE 02: EXPLORATORY FACTOR ANALYSIS (EFA)
# Course: Advanced Statistical Methods for Transportation & Behavioral Research
#         EFA, CFA, CB-SEM, and Regression Analysis
# Instructor: Dr. Mahbub Hassan
#             Department of Civil Engineering, Chulalongkorn University
#             mahbub.hassan@ieee.org
# ==============================================================================
# Dataset: Bangkok Urban Transportation Survey (BUTS)
# File: ../Datasets/BUTS_main.csv
# ==============================================================================

# ------------------------------------------------------------------------------
# SECTION 0: LOAD PACKAGES
# ------------------------------------------------------------------------------

# install.packages(c("psych", "GPArotation", "nFactors", "ggplot2",
#                    "tidyverse", "corrplot", "RColorBrewer", "parameters"))

library(psych)          # fa(), fa.parallel(), KMO(), cortest.bartlett()
library(GPArotation)    # Rotation algorithms (oblimin, promax, etc.)
library(nFactors)       # Factor number determination
library(ggplot2)        # Visualization
library(tidyverse)      # Data manipulation
library(corrplot)       # Correlation visualization
library(parameters)     # model_parameters() for nice tables

# ------------------------------------------------------------------------------
# SECTION 1: LOAD AND PREPARE DATA
# ------------------------------------------------------------------------------

buts <- read.csv("../Datasets/BUTS_main.csv", stringsAsFactors = FALSE)

# Define all scale items for EFA
all_items <- c("PS1", "PS2", "PS3", "PS4", "PS5",
               "SQ1", "SQ2", "SQ3", "SQ4",
               "EA1", "EA2", "EA3", "EA4",
               "BI1", "BI2", "BI3",
               "AB1", "AB2", "AB3")

# Extract scale items only, complete cases
efa_data <- buts[, all_items]
efa_data_complete <- na.omit(efa_data)

cat("EFA Sample Size:", nrow(efa_data_complete), "\n")
cat("Number of Items:", ncol(efa_data_complete), "\n")
cat("Items:N ratio = 1:", round(nrow(efa_data_complete)/ncol(efa_data_complete)), "\n\n")

# ------------------------------------------------------------------------------
# SECTION 2: PRELIMINARY CHECKS — FACTORABILITY
# ------------------------------------------------------------------------------

cat("===== STEP 1: FACTORABILITY CHECKS =====\n\n")

# 2.1 Correlation matrix
cor_matrix <- cor(efa_data_complete, method = "pearson")

# Check for very low correlations (items may not share factors)
below_30 <- which(abs(cor_matrix) < 0.30 & lower.tri(cor_matrix), arr.ind = TRUE)
cat("Item pairs with |r| < 0.30 (potential issue):", nrow(below_30), "pairs\n")
if(nrow(below_30) > 0) {
  for(i in 1:min(nrow(below_30), 10)) {
    cat(rownames(cor_matrix)[below_30[i,1]], "&",
        colnames(cor_matrix)[below_30[i,2]], ": r =",
        round(cor_matrix[below_30[i,1], below_30[i,2]], 3), "\n")
  }
}

# Check for very high correlations (near-multicollinearity)
above_90 <- which(abs(cor_matrix) > 0.90 & lower.tri(cor_matrix), arr.ind = TRUE)
cat("\nItem pairs with |r| > 0.90 (multicollinearity risk):", nrow(above_90), "pairs\n")
if(nrow(above_90) > 0) {
  for(i in 1:nrow(above_90)) {
    cat(rownames(cor_matrix)[above_90[i,1]], "&",
        colnames(cor_matrix)[above_90[i,2]], ": r =",
        round(cor_matrix[above_90[i,1], above_90[i,2]], 3), "\n")
  }
}

# 2.2 KMO Test
cat("\n----- KMO Test -----\n")
kmo_result <- psych::KMO(cor_matrix)
cat("Overall KMO =", round(kmo_result$MSA, 3), "\n")

# Interpret KMO
kmo_interp <- ifelse(kmo_result$MSA >= 0.90, "Marvelous",
              ifelse(kmo_result$MSA >= 0.80, "Meritorious",
              ifelse(kmo_result$MSA >= 0.70, "Middling",
              ifelse(kmo_result$MSA >= 0.60, "Mediocre",
              ifelse(kmo_result$MSA >= 0.50, "Miserable", "Unacceptable — do NOT proceed")))))
cat("Interpretation:", kmo_interp, "\n")

# Item-level MSA
cat("\nItem-level MSA (flag if < 0.50):\n")
item_msa <- data.frame(Item = names(kmo_result$MSAi),
                        MSA  = round(kmo_result$MSAi, 3))
item_msa$Flag <- ifelse(item_msa$MSA < 0.50, "REMOVE", "OK")
print(item_msa[order(item_msa$MSA), ])

# Flag items to remove based on MSA
low_msa_items <- item_msa$Item[item_msa$MSA < 0.50]
if(length(low_msa_items) > 0) {
  cat("\nItems to remove (MSA < 0.50):", paste(low_msa_items, collapse = ", "), "\n")
}

# 2.3 Bartlett's Test of Sphericity
cat("\n----- Bartlett's Test of Sphericity -----\n")
bartlett_result <- psych::cortest.bartlett(cor_matrix, n = nrow(efa_data_complete))
cat("χ² =", round(bartlett_result$chisq, 2), "\n")
cat("df =", bartlett_result$df, "\n")
cat("p  =", format(bartlett_result$p.value, scientific = TRUE), "\n")
cat("Interpretation:", ifelse(bartlett_result$p.value < 0.05,
    "SIGNIFICANT — EFA is appropriate",
    "NOT significant — EFA NOT appropriate"), "\n")

# 2.4 Determinant of correlation matrix
cat("\n----- Correlation Matrix Determinant -----\n")
det_val <- det(cor_matrix)
cat("Determinant =", format(det_val, scientific = TRUE), "\n")
cat("Interpretation:", ifelse(det_val > 0.00001,
    "No extreme multicollinearity",
    "WARNING: Near-singular matrix — check for highly correlated items"), "\n")

# ------------------------------------------------------------------------------
# SECTION 3: DETERMINE NUMBER OF FACTORS
# ------------------------------------------------------------------------------

cat("\n\n===== STEP 2: DETERMINE NUMBER OF FACTORS =====\n\n")

# 3.1 Parallel Analysis (BEST METHOD — Horn, 1965)
cat("----- Parallel Analysis -----\n")
set.seed(2024)  # For reproducibility
parallel_result <- psych::fa.parallel(
  efa_data_complete,
  fm     = "pa",      # Principal Axis factoring
  fa     = "fa",      # Factor Analysis (not PCA)
  n.iter = 1000,      # Number of random data iterations
  main   = "Parallel Analysis Scree Plot",
  col    = c("#2196F3", "#F44336")
)

cat("\nParallel Analysis suggests:", parallel_result$nfact, "factors\n")

# 3.2 Kaiser Criterion (Eigenvalue > 1)
eigenvalues <- eigen(cor_matrix)$values
n_kaiser <- sum(eigenvalues > 1)
cat("\nKaiser Criterion (Eigenvalue > 1):", n_kaiser, "factors\n")

# Print eigenvalues
cat("\nEigenvalues:\n")
eigen_table <- data.frame(
  Factor     = 1:length(eigenvalues),
  Eigenvalue = round(eigenvalues, 3),
  Pct_Var    = round(eigenvalues / length(eigenvalues) * 100, 1),
  Cum_Pct    = round(cumsum(eigenvalues / length(eigenvalues) * 100), 1)
)
print(head(eigen_table, 10))

# 3.3 Custom Scree Plot
scree_df <- data.frame(
  Factor     = 1:length(eigenvalues),
  Eigenvalue = eigenvalues,
  Type       = "Actual"
)

ggplot(scree_df[1:min(15, nrow(scree_df)), ], aes(x = Factor, y = Eigenvalue)) +
  geom_line(color = "#2196F3", size = 1.2) +
  geom_point(color = "#2196F3", size = 3.5) +
  geom_hline(yintercept = 1.0, linetype = "dashed", color = "#F44336", size = 0.8) +
  annotate("text", x = 13, y = 1.1, label = "Eigenvalue = 1.0",
           color = "#F44336", size = 3.5) +
  scale_x_continuous(breaks = 1:15) +
  labs(title = "Scree Plot — Eigenvalues by Factor",
       subtitle = "BUTS Dataset | Bangkok Urban Transportation Survey",
       x = "Factor Number",
       y = "Eigenvalue",
       caption = "Dashed line: Kaiser criterion (eigenvalue = 1.0)") +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold"),
        panel.grid.minor = element_blank())

# 3.4 Summary of factor number decision
cat("\n----- Factor Number Summary -----\n")
cat("Method                      | Suggested Factors\n")
cat("----------------------------|------------------\n")
cat("Parallel Analysis           |", parallel_result$nfact, "\n")
cat("Kaiser Criterion (EV > 1)   |", n_kaiser, "\n")
cat("Theory/Conceptual framework |  4 (PS, SQ, EA, BI)\n")
cat("----------------------------|------------------\n")
cat("FINAL DECISION              |  4 factors\n\n")

# Store final number of factors
n_factors <- 4  # Adjust based on your parallel analysis result

# ------------------------------------------------------------------------------
# SECTION 4: RUN EFA — PRINCIPAL AXIS FACTORING, OBLIMIN ROTATION
# ------------------------------------------------------------------------------

cat("===== STEP 3: RUN EFA =====\n\n")

# 4.1 Initial EFA (no rotation) — check communalities first
efa_initial <- psych::fa(
  efa_data_complete,
  nfactors = n_factors,
  fm       = "pa",        # Principal Axis Factoring
  rotate   = "none",      # No rotation for initial run
  scores   = "regression",
  use      = "pairwise"
)

cat("--- Initial Communalities (Unrotated) ---\n")
communalities <- data.frame(
  Item         = rownames(efa_initial$communality),
  Communality  = round(efa_initial$communality, 3),
  Flag         = ifelse(efa_initial$communality < 0.30, "LOW — consider removing", "OK")
)
print(communalities[order(communalities$Communality), ])

# Items to investigate due to low communality
low_comm_items <- communalities$Item[communalities$Communality < 0.30]
if(length(low_comm_items) > 0) {
  cat("\nItems with communality < 0.30:", paste(low_comm_items, collapse = ", "), "\n")
  cat("Consider removing these items and re-running EFA.\n")
}

# 4.2 Main EFA — Direct Oblimin rotation
cat("\n--- Main EFA: PAF + Oblimin Rotation ---\n")
efa_oblimin <- psych::fa(
  efa_data_complete,
  nfactors = n_factors,
  fm       = "pa",
  rotate   = "oblimin",   # Direct oblimin (oblique rotation)
  scores   = "regression",
  use      = "pairwise",
  maxit    = 1000
)

# Print full results
print(efa_oblimin, digits = 3, cut = 0.40, sort = TRUE)

# 4.3 Also run with Varimax for comparison (orthogonal)
cat("\n--- Comparison: Varimax Rotation ---\n")
efa_varimax <- psych::fa(
  efa_data_complete,
  nfactors = n_factors,
  fm       = "pa",
  rotate   = "varimax",
  scores   = "regression",
  use      = "pairwise",
  maxit    = 1000
)

cat("Factor correlations (Oblimin solution):\n")
print(round(efa_oblimin$Phi, 3))

# ------------------------------------------------------------------------------
# SECTION 5: EVALUATE THE EFA SOLUTION
# ------------------------------------------------------------------------------

cat("\n\n===== STEP 4: EVALUATE EFA SOLUTION =====\n\n")

# 5.1 Pattern matrix with loadings
loadings_matrix <- as.data.frame(unclass(efa_oblimin$loadings))
names(loadings_matrix) <- paste0("F", 1:n_factors)
loadings_matrix$Item <- rownames(loadings_matrix)

cat("Pattern Matrix (loadings ≥ 0.40 are meaningful):\n")
print(round(loadings_matrix[, 1:n_factors], 3))

# 5.2 Identify cross-loading items
cat("\n----- Cross-Loading Check -----\n")
for(i in 1:nrow(loadings_matrix)) {
  loads <- abs(as.numeric(loadings_matrix[i, 1:n_factors]))
  sorted_loads <- sort(loads, decreasing = TRUE)

  if(sorted_loads[1] >= 0.40 && sorted_loads[2] >= 0.30) {
    diff <- sorted_loads[1] - sorted_loads[2]
    if(diff < 0.15) {
      cat("CROSS-LOADING:", loadings_matrix$Item[i],
          "| Top loadings:", round(sorted_loads[1], 3), "and", round(sorted_loads[2], 3),
          "| Difference:", round(diff, 3), "→ Consider removing\n")
    }
  }
}

# 5.3 Items with no meaningful loading
cat("\n----- Items with No Clear Loading (< 0.40 on all factors) -----\n")
for(i in 1:nrow(loadings_matrix)) {
  loads <- abs(as.numeric(loadings_matrix[i, 1:n_factors]))
  if(max(loads) < 0.40) {
    cat("NO LOADING:", loadings_matrix$Item[i],
        "| Max loading:", round(max(loads), 3), "→ Remove\n")
  }
}

# 5.4 Communalities in rotated solution
cat("\n----- Communalities (Rotated Solution) -----\n")
comm_rotated <- data.frame(
  Item        = names(efa_oblimin$communality),
  Communality = round(efa_oblimin$communality, 3),
  Status      = ifelse(efa_oblimin$communality >= 0.50, "Good",
                       ifelse(efa_oblimin$communality >= 0.30, "Acceptable", "Low — review"))
)
print(comm_rotated[order(comm_rotated$Communality), ])

# 5.5 Factor correlation matrix (Phi)
cat("\n----- Factor Correlation Matrix (Phi) -----\n")
print(round(efa_oblimin$Phi, 3))
cat("\nNote: If all |r| < 0.15, consider orthogonal rotation (Varimax)\n")
cat("      If any |r| > 0.85, factors may be too similar (consider merging)\n")

# ------------------------------------------------------------------------------
# SECTION 6: VISUALIZATION — FACTOR LOADING HEATMAP
# ------------------------------------------------------------------------------

# Create clean loading matrix for visualization
load_viz <- as.data.frame(unclass(efa_oblimin$loadings))
factor_labels <- c("F1: Safety", "F2: Service Quality",
                   "F3: Env. Attitude", "F4: Intention")
names(load_viz) <- factor_labels

load_long <- load_viz %>%
  rownames_to_column("Item") %>%
  pivot_longer(-Item, names_to = "Factor", values_to = "Loading")

ggplot(load_long, aes(x = Factor, y = Item, fill = Loading)) +
  geom_tile(color = "white", size = 0.5) +
  geom_text(aes(label = ifelse(abs(Loading) >= 0.40,
                               sprintf("%.2f", Loading), "")),
            size = 3.2, fontface = "bold") +
  scale_fill_gradient2(low = "#053061", mid = "#f7f7f7", high = "#67001f",
                       midpoint = 0, limits = c(-1, 1),
                       name = "Loading") +
  labs(title = "EFA Pattern Matrix Heatmap",
       subtitle = paste0("PAF + Oblimin | ", n_factors, " factors | n = ", nrow(efa_data_complete)),
       x = "Factor", y = "Item") +
  theme_minimal(base_size = 11) +
  theme(plot.title = element_text(face = "bold"),
        axis.text.x = element_text(angle = 15, hjust = 1))

# ------------------------------------------------------------------------------
# SECTION 7: CLEAN SOLUTION WITH RETAINED ITEMS
# ------------------------------------------------------------------------------

cat("\n\n===== STEP 5: FINAL CLEAN EFA SOLUTION =====\n\n")

# Define retained items (update based on your EFA evaluation above)
# These assume PS5 and AB3 are removed as examples
retained_items <- c("PS1", "PS2", "PS3", "PS4",      # Factor 1: Perceived Safety
                    "SQ1", "SQ2", "SQ3", "SQ4",      # Factor 2: Service Quality
                    "EA1", "EA2", "EA3", "EA4",      # Factor 3: Environmental Attitude
                    "BI1", "BI2", "BI3")             # Factor 4: Behavioral Intention

efa_final <- psych::fa(
  efa_data_complete[, retained_items],
  nfactors = n_factors,
  fm       = "pa",
  rotate   = "oblimin",
  scores   = "regression",
  use      = "pairwise",
  maxit    = 1000
)

cat("FINAL EFA SOLUTION:\n\n")
print(efa_final, digits = 3, cut = 0.40, sort = TRUE)

# ------------------------------------------------------------------------------
# SECTION 8: PUBLICATION TABLE — FORMAT EFA RESULTS
# ------------------------------------------------------------------------------

cat("\n\n===== STEP 6: PUBLICATION TABLE =====\n\n")

# Build publication-ready table
final_loadings <- as.data.frame(unclass(efa_final$loadings))
names(final_loadings) <- c("F1_Safety", "F2_Quality", "F3_EnvAtt", "F4_Intention")
final_loadings$Communality <- round(efa_final$communality, 3)
final_loadings$Item <- rownames(final_loadings)

# Round loadings and suppress < 0.40
final_table <- final_loadings %>%
  mutate(across(starts_with("F"), ~ ifelse(abs(.) < 0.40, "", sprintf("%.3f", .))))

# Print formatted table
cat(sprintf("%-6s %-10s %-10s %-10s %-10s %-8s\n",
            "Item", "F1:Safety", "F2:Quality", "F3:EnvAtt", "F4:Intnt", "h²"))
cat(strrep("-", 58), "\n")
for(i in 1:nrow(final_loadings)) {
  cat(sprintf("%-6s %-10s %-10s %-10s %-10s %-8.3f\n",
              final_loadings$Item[i],
              ifelse(abs(final_loadings$F1_Safety[i]) >= 0.40,
                     sprintf("%.3f", final_loadings$F1_Safety[i]), ""),
              ifelse(abs(final_loadings$F2_Quality[i]) >= 0.40,
                     sprintf("%.3f", final_loadings$F2_Quality[i]), ""),
              ifelse(abs(final_loadings$F3_EnvAtt[i]) >= 0.40,
                     sprintf("%.3f", final_loadings$F3_EnvAtt[i]), ""),
              ifelse(abs(final_loadings$F4_Intention[i]) >= 0.40,
                     sprintf("%.3f", final_loadings$F4_Intention[i]), ""),
              final_loadings$Communality[i]))
}
cat(strrep("-", 58), "\n")

# Variance explained
var_explained <- efa_final$Vaccounted
cat(sprintf("\n%-30s %-10s %-10s %-10s %-10s\n",
            "Statistic", "F1", "F2", "F3", "F4"))
cat(sprintf("%-30s %-10.3f %-10.3f %-10.3f %-10.3f\n",
            "Eigenvalue",
            var_explained[1,1], var_explained[1,2],
            var_explained[1,3], var_explained[1,4]))
cat(sprintf("%-30s %-10.1f %-10.1f %-10.1f %-10.1f\n",
            "% Variance",
            var_explained[2,1]*100, var_explained[2,2]*100,
            var_explained[2,3]*100, var_explained[2,4]*100))
cat(sprintf("%-30s %-10.1f %-10.1f %-10.1f %-10.1f\n",
            "Cumulative %",
            var_explained[3,1]*100, var_explained[3,2]*100,
            var_explained[3,3]*100, var_explained[3,4]*100))

cat("\nFactor Correlation Matrix (Phi):\n")
print(round(efa_final$Phi, 3))

# ------------------------------------------------------------------------------
# SECTION 9: RELIABILITY FOR EACH FACTOR
# ------------------------------------------------------------------------------

cat("\n\n===== STEP 7: RELIABILITY PER FACTOR =====\n\n")

factors_list <- list(
  "F1: Perceived Safety"      = c("PS1", "PS2", "PS3", "PS4"),
  "F2: Service Quality"        = c("SQ1", "SQ2", "SQ3", "SQ4"),
  "F3: Environmental Attitude" = c("EA1", "EA2", "EA3", "EA4"),
  "F4: Behavioral Intention"   = c("BI1", "BI2", "BI3")
)

reliability_results <- lapply(names(factors_list), function(factor_name) {
  items <- factors_list[[factor_name]]
  alpha_res <- psych::alpha(efa_data_complete[, items], check.keys = TRUE)
  cat(factor_name, ": α =", round(alpha_res$total$raw_alpha, 3), "\n")
  return(round(alpha_res$total$raw_alpha, 3))
})

# ------------------------------------------------------------------------------
# SECTION 10: EXPORT RESULTS
# ------------------------------------------------------------------------------

# Create output directory if needed
dir.create("../Datasets/Output", showWarnings = FALSE, recursive = TRUE)

# Save pattern matrix
write.csv(final_loadings, "../Datasets/Output/02_EFA_pattern_matrix.csv", row.names = TRUE)

# Save factor scores for later use (if desired)
# factor_scores <- as.data.frame(efa_final$scores)
# names(factor_scores) <- c("Safety_Score", "Quality_Score", "EnvAtt_Score", "Intention_Score")
# write.csv(factor_scores, "../Datasets/Output/02_EFA_factor_scores.csv", row.names = FALSE)

cat("\n===== MODULE 02 COMPLETE =====\n")
cat("✓ Factorability confirmed (KMO, Bartlett)\n")
cat("✓ Number of factors determined (Parallel Analysis)\n")
cat("✓ EFA conducted (PAF + Oblimin)\n")
cat("✓ Pattern matrix evaluated and cleaned\n")
cat("✓ Reliability assessed\n")
cat("Proceed to Module 03: Confirmatory Factor Analysis\n")

# ==============================================================================
# END OF MODULE 02 SCRIPT
# ==============================================================================
