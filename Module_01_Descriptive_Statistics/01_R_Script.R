# ==============================================================================
# MODULE 01: DESCRIPTIVE STATISTICS & DATA PREPARATION
# Course: Advanced Statistical Methods for Transportation & Behavioral Research
#         EFA, CFA, CB-SEM, and Regression Analysis
# Instructor: Mahbub Hassan
#             Department of Civil Engineering, Chulalongkorn University
#             mahbub.hassan@ieee.org
# ==============================================================================
# Dataset: Bangkok Urban Transportation Survey (BUTS)
# File: ../Datasets/BUTS_main.csv
# ==============================================================================

# ------------------------------------------------------------------------------
# SECTION 0: INSTALL AND LOAD REQUIRED PACKAGES
# ------------------------------------------------------------------------------

# Install packages (run once, then comment out)
# install.packages(c("tidyverse", "psych", "corrplot", "MVN",
#                    "mice", "naniar", "ggplot2", "nortest",
#                    "moments", "knitr", "flextable"))

library(tidyverse)    # Data manipulation and visualization
library(psych)        # Psychological/psychometric methods (describe, alpha, fa)
library(corrplot)     # Correlation matrix visualization
library(MVN)          # Multivariate normality tests
library(mice)         # Multiple imputation for missing data
library(naniar)       # Missing data visualization
library(ggplot2)      # Publication-quality plots
library(nortest)      # Normality tests (Anderson-Darling, etc.)
library(moments)      # Skewness and kurtosis functions
library(flextable)    # Publication-ready tables

# ------------------------------------------------------------------------------
# SECTION 1: LOAD AND INSPECT DATA
# ------------------------------------------------------------------------------

# Set path to dataset (adjust as needed)
data_path <- "../Datasets/BUTS_main.csv"

# Load data
buts <- read.csv(data_path, stringsAsFactors = FALSE)

# Basic inspection
dim(buts)           # Number of rows (cases) and columns (variables)
str(buts)           # Structure: variable names, types, first few values
head(buts, 10)      # First 10 rows
summary(buts)       # Quick summary statistics

# Variable names
names(buts)

# ------------------------------------------------------------------------------
# SECTION 2: DATA CODING AND PREPARATION
# ------------------------------------------------------------------------------

# Convert categorical variables to factors with meaningful labels
buts$Gender <- factor(buts$Gender,
                      levels = c(1, 2),
                      labels = c("Male", "Female"))

buts$AgeGroup <- factor(buts$AgeGroup,
                        levels = c(1, 2, 3, 4, 5),
                        labels = c("18-25", "26-35", "36-45", "46-55", "56+"))

buts$PrimaryMode <- factor(buts$PrimaryMode,
                           levels = c(1, 2, 3, 4),
                           labels = c("Car", "Motorcycle", "Public Transit", "Walk/Cycle"))

buts$IncomeGroup <- factor(buts$IncomeGroup,
                           levels = c(1, 2, 3, 4),
                           labels = c("<15,000", "15,000-30,000", "30,001-50,000", ">50,000"))

buts$EducationLevel <- factor(buts$EducationLevel,
                              levels = c(1, 2, 3, 4, 5),
                              labels = c("Primary", "Secondary", "Vocational",
                                         "Bachelor's", "Postgraduate"))

# Define scale items (Likert variables)
perceived_safety_items <- c("PS1", "PS2", "PS3", "PS4", "PS5")
service_quality_items  <- c("SQ1", "SQ2", "SQ3", "SQ4")
env_attitude_items     <- c("EA1", "EA2", "EA3", "EA4")
behavioral_intention_items <- c("BI1", "BI2", "BI3")
actual_behavior_items  <- c("AB1", "AB2", "AB3")

all_scale_items <- c(perceived_safety_items, service_quality_items,
                     env_attitude_items, behavioral_intention_items,
                     actual_behavior_items)

# Extract scale items as a separate data frame
scale_data <- buts[, all_scale_items]

# ------------------------------------------------------------------------------
# SECTION 3: DESCRIPTIVE STATISTICS FOR CATEGORICAL VARIABLES
# ------------------------------------------------------------------------------

cat("===== SAMPLE CHARACTERISTICS =====\n\n")

# Frequency tables
cat("--- Gender ---\n")
print(table(buts$Gender))
cat("\n")
prop.table(table(buts$Gender)) * 100  # Percentages

cat("--- Age Group ---\n")
print(table(buts$AgeGroup))
round(prop.table(table(buts$AgeGroup)) * 100, 1)

cat("--- Primary Mode of Transport ---\n")
print(table(buts$PrimaryMode))
round(prop.table(table(buts$PrimaryMode)) * 100, 1)

cat("--- Income Group ---\n")
print(table(buts$IncomeGroup))
round(prop.table(table(buts$IncomeGroup)) * 100, 1)

# Publication-ready frequency table
demographics_summary <- data.frame(
  Variable = c(
    "Gender: Male", "Gender: Female",
    "Age: 18-25", "Age: 26-35", "Age: 36-45", "Age: 46-55", "Age: 56+",
    "Mode: Car", "Mode: Motorcycle", "Mode: Public Transit", "Mode: Walk/Cycle",
    "Income: <15,000 THB", "Income: 15,000-30,000", "Income: 30,001-50,000", "Income: >50,000"
  ),
  Frequency = c(
    sum(buts$Gender == "Male"), sum(buts$Gender == "Female"),
    sum(buts$AgeGroup == "18-25"), sum(buts$AgeGroup == "26-35"),
    sum(buts$AgeGroup == "36-45"), sum(buts$AgeGroup == "46-55"),
    sum(buts$AgeGroup == "56+"),
    sum(buts$PrimaryMode == "Car"), sum(buts$PrimaryMode == "Motorcycle"),
    sum(buts$PrimaryMode == "Public Transit"), sum(buts$PrimaryMode == "Walk/Cycle"),
    sum(buts$IncomeGroup == "<15,000"), sum(buts$IncomeGroup == "15,000-30,000"),
    sum(buts$IncomeGroup == "30,001-50,000"), sum(buts$IncomeGroup == ">50,000")
  )
)
demographics_summary$Percentage <- round(demographics_summary$Frequency / nrow(buts) * 100, 1)
print(demographics_summary)

# ------------------------------------------------------------------------------
# SECTION 4: DESCRIPTIVE STATISTICS FOR SCALE ITEMS
# ------------------------------------------------------------------------------

cat("\n===== DESCRIPTIVE STATISTICS FOR SCALE ITEMS =====\n\n")

# Using psych::describe() — comprehensive stats
desc_stats <- psych::describe(scale_data)
print(round(desc_stats[, c("n", "mean", "sd", "median", "min", "max", "skew", "kurtosis")], 3))

# Custom function to add skewness/kurtosis interpretation
interpret_normality <- function(skew, kurt) {
  skew_ok <- abs(skew) < 2
  kurt_ok  <- abs(kurt) < 7
  if(skew_ok & kurt_ok) "Normal" else "Non-normal"
}

# Enhanced descriptive table
desc_table <- data.frame(
  Item    = rownames(desc_stats),
  N       = desc_stats$n,
  Mean    = round(desc_stats$mean, 2),
  SD      = round(desc_stats$sd, 2),
  Median  = round(desc_stats$median, 2),
  Min     = desc_stats$min,
  Max     = desc_stats$max,
  Skew    = round(desc_stats$skew, 3),
  Kurt    = round(desc_stats$kurtosis, 3)
)
print(desc_table)

# ------------------------------------------------------------------------------
# SECTION 5: NORMALITY TESTING
# ------------------------------------------------------------------------------

cat("\n===== NORMALITY ASSESSMENT =====\n\n")

# 5.1 Shapiro-Wilk test for each item (best for n < 200; informative for larger)
cat("Shapiro-Wilk Normality Tests:\n")
sw_results <- sapply(scale_data, function(x) {
  test <- shapiro.test(x[!is.na(x)])
  c(W = round(test$statistic, 4), p = round(test$p.value, 4))
})
print(t(sw_results))

# 5.2 Anderson-Darling test (more sensitive in tails)
cat("\nAnderson-Darling Normality Tests:\n")
ad_results <- sapply(scale_data, function(x) {
  test <- nortest::ad.test(x[!is.na(x)])
  c(A = round(test$statistic, 4), p = round(test$p.value, 4))
})
print(t(ad_results))

# 5.3 Mardia's Multivariate Normality Test (critical for SEM)
cat("\nMardia's Multivariate Normality Test:\n")
mvn_result <- MVN::mvn(scale_data, mvnTest = "mardia",
                        univariateTest = "SW",
                        multivariatePlot = "none")
print(mvn_result$multivariateNormality)

# ------------------------------------------------------------------------------
# SECTION 6: VISUALIZATION
# ------------------------------------------------------------------------------

# 6.1 Histograms with normal curve overlay for each item
plot_normality_hist <- function(data, item_name) {
  ggplot(data, aes_string(x = item_name)) +
    geom_histogram(aes(y = ..density..), bins = 10, fill = "#2196F3",
                   color = "white", alpha = 0.8) +
    stat_function(fun = dnorm,
                  args = list(mean = mean(data[[item_name]], na.rm = TRUE),
                              sd   = sd(data[[item_name]], na.rm = TRUE)),
                  color = "#F44336", size = 1) +
    labs(title = paste("Distribution of", item_name),
         x = "Response (1–5 Likert)", y = "Density") +
    theme_minimal(base_size = 12) +
    theme(plot.title = element_text(face = "bold"))
}

# Plot for PS1 as example
print(plot_normality_hist(buts, "PS1"))

# 6.2 Q-Q Plots
qq_plot <- function(data, item_name) {
  ggplot(data, aes_string(sample = item_name)) +
    stat_qq(color = "#2196F3", size = 1.5) +
    stat_qq_line(color = "#F44336", size = 1) +
    labs(title = paste("Normal Q-Q Plot:", item_name),
         x = "Theoretical Quantiles", y = "Sample Quantiles") +
    theme_minimal(base_size = 12) +
    theme(plot.title = element_text(face = "bold"))
}

print(qq_plot(buts, "PS1"))

# 6.3 Box plots — all scale items
scale_long <- tidyr::pivot_longer(scale_data, cols = everything(),
                                   names_to = "Item", values_to = "Response")

ggplot(scale_long, aes(x = Item, y = Response)) +
  geom_boxplot(fill = "#2196F3", color = "#1565C0", alpha = 0.7, outlier.color = "red") +
  labs(title = "Box Plots — All Scale Items",
       subtitle = "Bangkok Urban Transportation Survey (BUTS, n = 450)",
       x = "Survey Item", y = "Response (1–5 Likert Scale)") +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(face = "bold")) +
  geom_hline(yintercept = 3, linetype = "dashed", color = "grey50")

# 6.4 Bar charts for categorical variables
ggplot(buts, aes(x = PrimaryMode, fill = PrimaryMode)) +
  geom_bar(color = "white", alpha = 0.85) +
  scale_fill_manual(values = c("#1976D2", "#388E3C", "#F57C00", "#7B1FA2")) +
  labs(title = "Primary Mode of Transportation",
       subtitle = "BUTS Sample (n = 450)",
       x = "Mode", y = "Count") +
  theme_minimal(base_size = 13) +
  theme(legend.position = "none",
        plot.title = element_text(face = "bold")) +
  geom_text(stat = "count", aes(label = ..count..), vjust = -0.5)

# ------------------------------------------------------------------------------
# SECTION 7: MISSING VALUE ANALYSIS
# ------------------------------------------------------------------------------

cat("\n===== MISSING VALUE ANALYSIS =====\n\n")

# 7.1 Summary of missing values per variable
miss_summary <- data.frame(
  Variable     = names(buts),
  N_Missing    = colSums(is.na(buts)),
  Pct_Missing  = round(colSums(is.na(buts)) / nrow(buts) * 100, 2)
)
miss_summary <- miss_summary[miss_summary$N_Missing > 0, ]
if(nrow(miss_summary) > 0) {
  print(miss_summary)
} else {
  cat("No missing values detected.\n")
}

# 7.2 Visual missing value pattern
naniar::gg_miss_var(buts) +
  labs(title = "Missing Values by Variable",
       subtitle = "BUTS Dataset") +
  theme_minimal()

# 7.3 Multiple imputation (if needed, >5% missing)
# Example: impute all variables with >5% missing
# imp <- mice::mice(buts[, all_scale_items], m = 5, method = "pmm",
#                   seed = 2024, printFlag = FALSE)
# buts_imputed <- mice::complete(imp, action = 1)  # Use first imputed dataset

# ------------------------------------------------------------------------------
# SECTION 8: OUTLIER DETECTION
# ------------------------------------------------------------------------------

cat("\n===== OUTLIER DETECTION =====\n\n")

# 8.1 Univariate outliers — z-scores
z_scores <- as.data.frame(scale(scale_data))
univariate_outliers <- which(apply(abs(z_scores), 1, max) > 3.0)
cat("Cases with univariate outliers (|z| > 3.0):", length(univariate_outliers), "\n")
if(length(univariate_outliers) > 0) {
  cat("Case IDs:", univariate_outliers, "\n")
}

# 8.2 Multivariate outliers — Mahalanobis distance
complete_cases <- complete.cases(scale_data)
mah_dist <- mahalanobis(
  scale_data[complete_cases, ],
  center = colMeans(scale_data[complete_cases, ]),
  cov    = cov(scale_data[complete_cases, ])
)

# Chi-square critical value: df = number of variables, p = 0.001
p_mah <- pchisq(mah_dist, df = ncol(scale_data), lower.tail = FALSE)
mah_outliers <- which(p_mah < 0.001)

cat("Multivariate outliers (Mahalanobis D², p < .001):", length(mah_outliers), "\n")

if(length(mah_outliers) > 0) {
  cat("Mahalanobis distances for potential outliers:\n")
  print(data.frame(
    CaseID = which(complete_cases)[mah_outliers],
    D2     = round(mah_dist[mah_outliers], 2),
    p      = round(p_mah[mah_outliers], 4)
  ))
  cat("\nRecommendation: Investigate these cases before deciding to remove.\n")
}

# ------------------------------------------------------------------------------
# SECTION 9: CORRELATION MATRIX
# ------------------------------------------------------------------------------

cat("\n===== CORRELATION MATRIX =====\n\n")

# Compute Pearson correlations
cor_matrix <- cor(scale_data, use = "pairwise.complete.obs", method = "pearson")
print(round(cor_matrix, 3))

# Visualize with corrplot
corrplot::corrplot(cor_matrix,
                   method = "color",
                   type   = "upper",
                   order  = "hclust",
                   addCoef.col = "black",
                   number.cex  = 0.65,
                   tl.col  = "black",
                   tl.srt  = 45,
                   tl.cex  = 0.85,
                   col     = colorRampPalette(c("#053061", "#2166ac", "#f7f7f7",
                                                "#d6604d", "#67001f"))(200),
                   title   = "Inter-Item Correlation Matrix (Pearson)",
                   mar     = c(0, 0, 2, 0))

# Check items with very low correlations
low_cor_pairs <- which(abs(cor_matrix) < 0.30 & cor_matrix != 1, arr.ind = TRUE)
if(nrow(low_cor_pairs) > 0) {
  cat("Item pairs with correlations < 0.30 (potential factor mismatch):\n")
  for(i in 1:nrow(low_cor_pairs)) {
    r <- low_cor_pairs[i, ]
    cat(rownames(cor_matrix)[r[1]], "&", colnames(cor_matrix)[r[2]],
        ": r =", round(cor_matrix[r[1], r[2]], 3), "\n")
  }
}

# ------------------------------------------------------------------------------
# SECTION 10: RELIABILITY ANALYSIS — CRONBACH'S ALPHA
# ------------------------------------------------------------------------------

cat("\n===== RELIABILITY ANALYSIS (CRONBACH'S ALPHA) =====\n\n")

# Function to run and report reliability
report_alpha <- function(data, items, construct_name) {
  cat(paste0("\n--- ", construct_name, " ---\n"))
  alpha_result <- psych::alpha(data[, items], check.keys = TRUE)
  cat("Cronbach's α =", round(alpha_result$total$raw_alpha, 3), "\n")
  cat("95% CI: [",
      round(alpha_result$total$raw_alpha - 1.96 * alpha_result$total$ase, 3), ",",
      round(alpha_result$total$raw_alpha + 1.96 * alpha_result$total$ase, 3), "]\n")
  cat("\nItem-Total Statistics:\n")
  item_stats <- alpha_result$item.stats
  print(round(item_stats[, c("mean", "sd", "r.cor", "r.drop", "alpha.drop")], 3))
  cat("\nInterpretation: α =",
      ifelse(alpha_result$total$raw_alpha >= 0.90, "Excellent (≥ 0.90)",
             ifelse(alpha_result$total$raw_alpha >= 0.80, "Good (0.80–0.89)",
                    ifelse(alpha_result$total$raw_alpha >= 0.70, "Acceptable (0.70–0.79)",
                           ifelse(alpha_result$total$raw_alpha >= 0.60, "Questionable (0.60–0.69)",
                                  "Poor (< 0.60)")))), "\n")
  return(alpha_result)
}

# Run reliability for each construct
alpha_PS <- report_alpha(buts, perceived_safety_items,    "Perceived Safety (PS)")
alpha_SQ <- report_alpha(buts, service_quality_items,     "Service Quality (SQ)")
alpha_EA <- report_alpha(buts, env_attitude_items,        "Environmental Attitude (EA)")
alpha_BI <- report_alpha(buts, behavioral_intention_items,"Behavioral Intention (BI)")
alpha_AB <- report_alpha(buts, actual_behavior_items,     "Actual Behavior (AB)")

# Summary table
reliability_summary <- data.frame(
  Construct = c("Perceived Safety", "Service Quality", "Environmental Attitude",
                "Behavioral Intention", "Actual Behavior"),
  Items = c(length(perceived_safety_items), length(service_quality_items),
            length(env_attitude_items), length(behavioral_intention_items),
            length(actual_behavior_items)),
  Alpha = c(round(alpha_PS$total$raw_alpha, 3),
            round(alpha_SQ$total$raw_alpha, 3),
            round(alpha_EA$total$raw_alpha, 3),
            round(alpha_BI$total$raw_alpha, 3),
            round(alpha_AB$total$raw_alpha, 3)),
  Interpretation = c(
    ifelse(alpha_PS$total$raw_alpha >= 0.90, "Excellent",
           ifelse(alpha_PS$total$raw_alpha >= 0.80, "Good", "Acceptable")),
    ifelse(alpha_SQ$total$raw_alpha >= 0.90, "Excellent",
           ifelse(alpha_SQ$total$raw_alpha >= 0.80, "Good", "Acceptable")),
    ifelse(alpha_EA$total$raw_alpha >= 0.90, "Excellent",
           ifelse(alpha_EA$total$raw_alpha >= 0.80, "Good", "Acceptable")),
    ifelse(alpha_BI$total$raw_alpha >= 0.90, "Excellent",
           ifelse(alpha_BI$total$raw_alpha >= 0.80, "Good", "Acceptable")),
    ifelse(alpha_AB$total$raw_alpha >= 0.90, "Excellent",
           ifelse(alpha_AB$total$raw_alpha >= 0.80, "Good", "Acceptable"))
  )
)

cat("\n===== RELIABILITY SUMMARY =====\n")
print(reliability_summary)

# ------------------------------------------------------------------------------
# SECTION 11: EXPORT RESULTS
# ------------------------------------------------------------------------------

# Save summary tables to CSV for reporting
write.csv(desc_table, "../Datasets/Output/01_descriptive_statistics.csv", row.names = FALSE)
write.csv(demographics_summary, "../Datasets/Output/01_sample_demographics.csv", row.names = FALSE)
write.csv(reliability_summary, "../Datasets/Output/01_reliability_summary.csv", row.names = FALSE)
write.csv(round(cor_matrix, 3), "../Datasets/Output/01_correlation_matrix.csv")

cat("\n===== MODULE 01 COMPLETE =====\n")
cat("Outputs saved to ../Datasets/Output/\n")
cat("Proceed to Module 02: Exploratory Factor Analysis\n")

# ==============================================================================
# END OF MODULE 01 SCRIPT
# ==============================================================================
