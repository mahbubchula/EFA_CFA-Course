# ==============================================================================
# MODULE 05: REGRESSION ANALYSIS
# Course: Advanced Statistical Methods for Transportation & Behavioral Research
#         EFA, CFA, CB-SEM, and Regression Analysis
# Instructor: Dr. Mahbub Hassan
#             Department of Civil Engineering, Chulalongkorn University
#             mahbub.hassan@ieee.org
# ==============================================================================

# install.packages(c("tidyverse","car","lmtest","MASS","nnet","ordinal",
#                    "effects","ggplot2","broom","performance","see"))

library(tidyverse)
library(car)          # VIF, Anova, linearHypothesis
library(lmtest)       # Breusch-Pagan, Durbin-Watson
library(MASS)         # polr (ordinal regression), glm.nb (negative binomial)
library(nnet)         # multinom (multinomial logistic)
library(ordinal)      # clm (cumulative link model, more flexible ordinal)
library(effects)      # Effect plots
library(broom)        # tidy model outputs
library(performance)  # model fit metrics, check_model
library(ggplot2)

# ------------------------------------------------------------------------------
# SECTION 1: LOAD DATA
# ------------------------------------------------------------------------------

buts <- read.csv("../Datasets/BUTS_main.csv", stringsAsFactors = FALSE)

# Create factor scores (sum scores as proxy — use CFA scores in practice)
buts$PS_score <- rowMeans(buts[, c("PS1","PS2","PS3","PS4")], na.rm = TRUE)
buts$SQ_score <- rowMeans(buts[, c("SQ1","SQ2","SQ3","SQ4")], na.rm = TRUE)
buts$EA_score <- rowMeans(buts[, c("EA1","EA2","EA3","EA4")], na.rm = TRUE)
buts$BI_score <- rowMeans(buts[, c("BI1","BI2","BI3")], na.rm = TRUE)
buts$AB_score <- rowMeans(buts[, c("AB1","AB2","AB3")], na.rm = TRUE)

# Prepare outcome variables
buts$ModeChoice_bin <- ifelse(buts$PrimaryMode %in% c(3, 4), 1, 0)  # Transit/walk = 1
buts$ModeChoice_cat <- factor(buts$PrimaryMode,
                               levels = 1:4,
                               labels = c("Car","Motorcycle","PublicTransit","Walk"))
buts$Gender_f <- factor(buts$Gender, levels = c(1,2), labels = c("Male","Female"))
buts$AgeGroup_f <- factor(buts$AgeGroup)
buts$Income_f   <- factor(buts$IncomeGroup)

reg_data <- na.omit(buts[, c("AB_score","BI_score","PS_score","SQ_score","EA_score",
                               "Gender_f","AgeGroup_f","Income_f",
                               "ModeChoice_bin","ModeChoice_cat",
                               "PrimaryMode","Age","Income","CarOwnership")])
cat("Regression sample size:", nrow(reg_data), "\n")

# ==============================================================================
# PART A: MULTIPLE LINEAR REGRESSION
# ==============================================================================

cat("\n\n========================================\n")
cat("PART A: MULTIPLE LINEAR REGRESSION\n")
cat("========================================\n")
cat("Outcome: Actual Behavior (AB_score, continuous)\n\n")

# ------------------------------------------------------------------------------
# A1: Simple Linear Regression
# ------------------------------------------------------------------------------

cat("----- A1: Simple Linear Regression -----\n")
lm_simple <- lm(AB_score ~ BI_score, data = reg_data)
summary(lm_simple)

cat(sprintf("R² = %.3f, F(%d,%d) = %.2f, p = %.4f\n",
            summary(lm_simple)$r.squared,
            summary(lm_simple)$fstatistic[2],
            summary(lm_simple)$fstatistic[3],
            pf(summary(lm_simple)$fstatistic[1],
               summary(lm_simple)$fstatistic[2],
               summary(lm_simple)$fstatistic[3], lower.tail=FALSE)))

# Plot simple regression
ggplot(reg_data, aes(x = BI_score, y = AB_score)) +
  geom_point(alpha = 0.4, color = "#1565C0") +
  geom_smooth(method = "lm", color = "#D32F2F", se = TRUE, fill = "#FFCDD2") +
  labs(title = "Simple Linear Regression: Behavioral Intention → Actual Behavior",
       x = "Behavioral Intention (mean score)",
       y = "Actual Behavior (mean score)") +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold"))

# ------------------------------------------------------------------------------
# A2: Multiple Linear Regression (Block/Hierarchical)
# ------------------------------------------------------------------------------

cat("\n----- A2: Multiple Linear Regression (Hierarchical) -----\n")

# Block 1: Demographics
lm_block1 <- lm(AB_score ~ Gender_f + AgeGroup_f + Income_f, data = reg_data)

# Block 2: + Attitudinal factors
lm_block2 <- lm(AB_score ~ Gender_f + AgeGroup_f + Income_f +
                              PS_score + SQ_score + EA_score + BI_score,
                data = reg_data)

# Model summaries
cat("\nBlock 1 (Demographics only):\n")
print(summary(lm_block1))

cat("\nBlock 2 (+ Attitudinal factors):\n")
print(summary(lm_block2))

# ΔR² significance test
anova_compare <- anova(lm_block1, lm_block2)
cat("\nModel Comparison (ΔR²):\n")
print(anova_compare)
cat(sprintf("ΔR² = %.3f, ΔF(%d,%d) = %.3f, p = %.4f\n",
            summary(lm_block2)$r.squared - summary(lm_block1)$r.squared,
            anova_compare$Df[2], anova_compare$Res.Df[2],
            anova_compare$F[2], anova_compare$`Pr(>F)`[2]))

# Standardized coefficients
lm_standardized <- lm(scale(AB_score) ~ scale(PS_score) + scale(SQ_score) +
                                         scale(EA_score) + scale(BI_score) +
                                         Gender_f + AgeGroup_f + Income_f,
                       data = reg_data)
cat("\nStandardized Coefficients:\n")
print(round(coef(lm_standardized), 3))

# ------------------------------------------------------------------------------
# A3: Regression Diagnostics
# ------------------------------------------------------------------------------

cat("\n----- A3: Regression Assumptions -----\n")

# A3.1 Multicollinearity
cat("VIF (Variance Inflation Factor):\n")
vif_vals <- car::vif(lm_block2)
print(round(vif_vals, 3))
problem_vif <- vif_vals[vif_vals > 5]
if(length(problem_vif) > 0) {
  cat("⚠️  HIGH VIF (> 5):", paste(names(problem_vif), collapse=", "), "\n")
} else {
  cat("✓ All VIF < 5. No multicollinearity concern.\n")
}

# A3.2 Durbin-Watson test (independence of residuals)
dw_test <- lmtest::dwtest(lm_block2)
cat(sprintf("\nDurbin-Watson statistic: %.3f (ideal: ~2.0)\n", dw_test$statistic))
cat(sprintf("p-value: %.4f\n", dw_test$p.value))

# A3.3 Breusch-Pagan test (homoscedasticity)
bp_test <- lmtest::bptest(lm_block2)
cat(sprintf("\nBreusch-Pagan test: χ²(df=%d) = %.3f, p = %.4f\n",
            bp_test$parameter, bp_test$statistic, bp_test$p.value))
cat(ifelse(bp_test$p.value > 0.05, "✓ Homoscedasticity assumption not violated",
           "⚠️  Heteroscedasticity detected — use robust standard errors"), "\n")

# A3.4 Normality of residuals
shapiro_res <- shapiro.test(residuals(lm_block2))
cat(sprintf("\nShapiro-Wilk test (residuals): W = %.4f, p = %.4f\n",
            shapiro_res$statistic, shapiro_res$p.value))

# A3.5 Diagnostic plots
par(mfrow = c(2, 2))
plot(lm_block2, which = c(1, 2, 3, 5),
     sub.caption = "Multiple Linear Regression Diagnostics")
par(mfrow = c(1, 1))

# publication-ready summary table
cat("\n----- Publication Summary Table -----\n")
tidy_m2 <- broom::tidy(lm_block2, conf.int = TRUE)
tidy_m2$sig <- ifelse(tidy_m2$p.value < .001, "***",
               ifelse(tidy_m2$p.value < .01, "**",
               ifelse(tidy_m2$p.value < .05, "*", "ns")))
cat(sprintf("%-30s %-8s %-8s %-8s %-8s %-8s %-6s\n",
            "Predictor", "B", "SE", "β*", "t", "p", "Sig"))
cat(strrep("-", 80), "\n")
std_coefs <- coef(lm_standardized)
for(i in 1:nrow(tidy_m2)) {
  term_name <- tidy_m2$term[i]
  beta_std <- if(grepl("score", term_name)) std_coefs[paste0("scale(",term_name,")")] else NA
  cat(sprintf("%-30s %-8.3f %-8.3f %-8s %-8.3f %-8.4f %-6s\n",
              term_name, tidy_m2$estimate[i], tidy_m2$std.error[i],
              ifelse(!is.na(beta_std), sprintf("%.3f", beta_std), "—"),
              tidy_m2$statistic[i], tidy_m2$p.value[i], tidy_m2$sig[i]))
}
cat(strrep("-", 80), "\n")
cat(sprintf("R² = %.3f, Adj.R² = %.3f, F(df1,df2) significant\n",
            summary(lm_block2)$r.squared,
            summary(lm_block2)$adj.r.squared))

# ==============================================================================
# PART B: BINARY LOGISTIC REGRESSION
# ==============================================================================

cat("\n\n========================================\n")
cat("PART B: BINARY LOGISTIC REGRESSION\n")
cat("========================================\n")
cat("Outcome: Mode Choice (1=Transit/Walk, 0=Car/Motorcycle)\n\n")

logit_model <- glm(ModeChoice_bin ~ PS_score + SQ_score + EA_score +
                                     Gender_f + AgeGroup_f + Income_f,
                    data   = reg_data,
                    family = binomial(link = "logit"))

cat("Model Summary:\n")
print(summary(logit_model))

# Odds Ratios and 95% CI
cat("\nOdds Ratios (OR) with 95% Confidence Intervals:\n")
or_table <- data.frame(
  OR      = round(exp(coef(logit_model)), 3),
  CI_low  = round(exp(confint(logit_model)[, 1]), 3),
  CI_high = round(exp(confint(logit_model)[, 2]), 3),
  p       = round(coef(summary(logit_model))[, 4], 4)
)
or_table$Sig <- ifelse(or_table$p < .001, "***",
                ifelse(or_table$p < .01, "**",
                ifelse(or_table$p < .05, "*", "ns")))
print(or_table)

# Model fit
cat("\nModel Fit Statistics:\n")
n     <- nrow(reg_data)
ll_0  <- logLik(glm(ModeChoice_bin ~ 1, data = reg_data, family = binomial))
ll_m  <- logLik(logit_model)
cox_r2    <- 1 - exp((-2/n) * (as.numeric(ll_m) - as.numeric(ll_0)))
nagelkerke <- cox_r2 / (1 - exp((2/n) * as.numeric(ll_0)))
cat(sprintf("Cox & Snell R²: %.3f\n", cox_r2))
cat(sprintf("Nagelkerke R²:  %.3f\n", nagelkerke))

# Classification table
pred_probs <- predict(logit_model, type = "response")
pred_class <- ifelse(pred_probs > 0.5, 1, 0)
conf_matrix <- table(Actual = reg_data$ModeChoice_bin, Predicted = pred_class)
cat("\nClassification Table:\n")
print(conf_matrix)
accuracy <- sum(diag(conf_matrix)) / sum(conf_matrix) * 100
cat(sprintf("Overall Accuracy: %.1f%%\n", accuracy))

# Hosmer-Lemeshow test
hl_groups <- cut(pred_probs, breaks = quantile(pred_probs, probs = seq(0, 1, 0.1)),
                  include.lowest = TRUE)
hl_observed <- tapply(reg_data$ModeChoice_bin, hl_groups, sum)
hl_expected <- tapply(pred_probs, hl_groups, sum)
hl_n        <- tapply(rep(1, nrow(reg_data)), hl_groups, length)
hl_stat     <- sum((hl_observed - hl_expected)^2 / (hl_expected * (1 - hl_expected/hl_n)),
                    na.rm = TRUE)
hl_p        <- pchisq(hl_stat, df = 8, lower.tail = FALSE)
cat(sprintf("\nHosmer-Lemeshow test: χ²(8) = %.3f, p = %.4f\n", hl_stat, hl_p))
cat(ifelse(hl_p > 0.05, "✓ Good calibration (p > 0.05)",
           "⚠️  Poor calibration — model may need revision"), "\n")

# ==============================================================================
# PART C: ORDINAL LOGISTIC REGRESSION
# ==============================================================================

cat("\n\n========================================\n")
cat("PART C: ORDINAL LOGISTIC REGRESSION\n")
cat("========================================\n")
cat("Outcome: Crash Severity (1=PDO, 2=Minor Injury, 3=Severe Injury, 4=Fatality)\n\n")

# Check if crash data available; use simplified example
if("CrashSeverity" %in% names(buts)) {
  reg_data$Severity_ord <- factor(reg_data$CrashSeverity, ordered = TRUE)
} else {
  # Simulate a severity outcome based on BI score for illustration
  set.seed(2024)
  reg_data$Severity_ord <- factor(
    sample(1:4, nrow(reg_data), replace = TRUE,
           prob = c(0.50, 0.30, 0.15, 0.05)),
    levels = 1:4,
    labels = c("PDO", "Minor Injury", "Serious Injury", "Fatal"),
    ordered = TRUE
  )
  cat("Note: Using simulated crash severity for illustration.\n\n")
}

# Proportional odds model
ordinal_model <- MASS::polr(
  Severity_ord ~ PS_score + SQ_score + Gender_f + AgeGroup_f,
  data   = reg_data,
  Hess   = TRUE,
  method = "logistic"
)

cat("Ordinal Logistic Regression Summary:\n")
print(summary(ordinal_model))

# Odds Ratios
cat("\nOdds Ratios with 95% CI:\n")
ctable <- coef(summary(ordinal_model))
p_vals <- pnorm(abs(ctable[, "t value"]), lower.tail = FALSE) * 2
or_ordinal <- cbind(
  OR   = round(exp(ctable[, "Value"]), 3),
  CI_lo = round(exp(ctable[, "Value"] - 1.96 * ctable[, "Std. Error"]), 3),
  CI_hi = round(exp(ctable[, "Value"] + 1.96 * ctable[, "Std. Error"]), 3),
  p    = round(p_vals, 4)
)
print(or_ordinal)

cat("\nInterpretation: Positive OR > 1 means higher predictor value")
cat(" increases odds of being in higher severity category.\n")

# ==============================================================================
# PART D: MULTINOMIAL LOGISTIC REGRESSION
# ==============================================================================

cat("\n\n========================================\n")
cat("PART D: MULTINOMIAL LOGISTIC REGRESSION\n")
cat("========================================\n")
cat("Outcome: Mode Choice (Car/Motorcycle/Transit/Walk)\n\n")

# Reference category = Car
reg_data$ModeChoice_cat <- relevel(reg_data$ModeChoice_cat, ref = "Car")

multinomial_model <- nnet::multinom(
  ModeChoice_cat ~ PS_score + SQ_score + EA_score + Gender_f + Income_f,
  data  = reg_data,
  trace = FALSE
)

cat("Multinomial Logistic Regression Summary:\n")
print(summary(multinomial_model))

# z-tests and p-values (not shown by default)
z_scores <- summary(multinomial_model)$coefficients /
            summary(multinomial_model)$standard.errors
p_values <- (1 - pnorm(abs(z_scores), 0, 1)) * 2

cat("\np-values for multinomial coefficients:\n")
print(round(p_values, 4))

cat("\nOdds Ratios:\n")
print(round(exp(coef(multinomial_model)), 3))

# Model fit
cat(sprintf("\nAIC: %.1f\n", AIC(multinomial_model)))
cat(sprintf("BIC: %.1f\n", BIC(multinomial_model)))

# ==============================================================================
# PART E: POISSON / NEGATIVE BINOMIAL (CRASH COUNT DATA)
# ==============================================================================

cat("\n\n========================================\n")
cat("PART E: COUNT DATA REGRESSION\n")
cat("========================================\n")

# Simulate crash count data (replace with real crash data)
set.seed(2024)
crash_data <- data.frame(
  CrashCount     = rnbinom(nrow(reg_data), mu = 2.5, size = 1.5),
  AADT           = runif(nrow(reg_data), 5000, 80000),  # Annual Average Daily Traffic
  SpeedLimit     = sample(c(40, 60, 80, 100, 120), nrow(reg_data), replace = TRUE),
  Lanes          = sample(2:6, nrow(reg_data), replace = TRUE),
  RoadType       = factor(sample(1:3, nrow(reg_data), replace = TRUE),
                          labels = c("Urban", "Suburban", "Rural"))
)

cat("Count Data Summary:\n")
cat(sprintf("Mean crash count: %.2f\n", mean(crash_data$CrashCount)))
cat(sprintf("Variance: %.2f\n", var(crash_data$CrashCount)))
cat(sprintf("Overdispersion index: %.2f\n",
            var(crash_data$CrashCount)/mean(crash_data$CrashCount)))

if(var(crash_data$CrashCount)/mean(crash_data$CrashCount) > 1.5) {
  cat("⚠️  Overdispersion detected — use Negative Binomial Regression\n\n")
}

# Negative Binomial Regression (for overdispersed count data)
nb_model <- MASS::glm.nb(
  CrashCount ~ log(AADT) + SpeedLimit + Lanes + RoadType,
  data = crash_data
)

cat("Negative Binomial Regression:\n")
print(summary(nb_model))

cat("\nIncidence Rate Ratios (IRR = exp(β)):\n")
irr_table <- data.frame(
  IRR   = round(exp(coef(nb_model)), 3),
  CI_lo = round(exp(confint(nb_model)[, 1]), 3),
  CI_hi = round(exp(confint(nb_model)[, 2]), 3),
  p     = round(coef(summary(nb_model))[, 4], 4)
)
print(irr_table)

cat("\nInterpretation: IRR > 1 means predictor increases crash count.\n")
cat("Example: IRR = 1.25 for Lanes → Each additional lane associated with 25% more crashes.\n")

# ==============================================================================
# SECTION 6: EXPORT RESULTS
# ==============================================================================

dir.create("../Datasets/Output", showWarnings = FALSE, recursive = TRUE)

write.csv(broom::tidy(lm_block2, conf.int = TRUE),
          "../Datasets/Output/05_OLS_results.csv", row.names = FALSE)
write.csv(or_table, "../Datasets/Output/05_Logistic_OR.csv", row.names = FALSE)

cat("\n===== MODULE 05 COMPLETE =====\n")
cat("✓ Multiple Linear Regression with hierarchical approach\n")
cat("✓ Binary Logistic Regression (mode choice)\n")
cat("✓ Ordinal Logistic Regression (crash severity)\n")
cat("✓ Multinomial Logistic Regression (multi-category mode choice)\n")
cat("✓ Negative Binomial Regression (crash counts)\n")
cat("Proceed to Module 06: Case Studies\n")

# ==============================================================================
# END OF MODULE 05 SCRIPT
# ==============================================================================
