# ==============================================================================
# BANGKOK URBAN TRANSPORTATION SURVEY (BUTS) — SYNTHETIC DATASET GENERATOR
# ==============================================================================
# Course: Advanced Statistical Methods for Transportation & Behavioral Research
# Instructor: Mahbub Hassan, Chulalongkorn University
# ==============================================================================
# This script generates a realistic synthetic dataset for use throughout
# the EFA, CFA, CB-SEM, and Regression modules.
#
# The data mimics a typical transportation behavior survey with:
#   - 450 respondents
#   - 5 latent constructs (PS, SQ, EA, BI, AB)
#   - Sociodemographic variables
#   - Mode choice outcome
#   - Realistic correlational structure
#
# NOTE: This is SYNTHETIC data generated for educational purposes.
#       Results will be consistent and reproducible across sessions.
# ==============================================================================

library(dplyr)

set.seed(2024)   # For reproducibility

n <- 450         # Sample size

# ==============================================================================
# STEP 1: GENERATE LATENT FACTOR SCORES
# ==============================================================================

# Latent factors with realistic correlational structure
# Using Cholesky decomposition to induce correlations

# Correlation matrix for 5 latent factors:
# PS (Perceived Safety), SQ (Service Quality), EA (Environmental Attitude),
# BI (Behavioral Intention), AB (Actual Behavior)

cor_latent <- matrix(c(
  # PS    SQ    EA    BI    AB
    1.00, 0.45, 0.32, 0.55, 0.42,   # PS
    0.45, 1.00, 0.38, 0.62, 0.48,   # SQ
    0.32, 0.38, 1.00, 0.58, 0.44,   # EA
    0.55, 0.62, 0.58, 1.00, 0.68,   # BI
    0.42, 0.48, 0.44, 0.68, 1.00    # AB
), nrow = 5, ncol = 5)

# Cholesky decomposition
chol_matrix <- chol(cor_latent)

# Generate 5 correlated standard normal variables
z <- matrix(rnorm(n * 5), nrow = n, ncol = 5)
latent_scores <- z %*% chol_matrix
colnames(latent_scores) <- c("PS_true", "SQ_true", "EA_true", "BI_true", "AB_true")
latent_df <- as.data.frame(latent_scores)

# Scale to mean=3.2, SD=0.8 (typical for 5-pt Likert)
for(v in names(latent_df)) {
  latent_df[[v]] <- latent_df[[v]] * 0.8 + 3.2
}

# ==============================================================================
# STEP 2: GENERATE INDICATORS FROM LATENT SCORES
# ==============================================================================

# Function: Generate Likert item from latent score + error
gen_likert <- function(latent, loading = 0.75, error_sd = 0.6, mean_adj = 0) {
  observed <- loading * latent + rnorm(length(latent), mean = mean_adj, sd = error_sd)
  # Round to integers and clip to 1-5
  pmax(1, pmin(5, round(observed)))
}

# Perceived Safety (PS): 5 items, loading 0.70-0.82
PS1 <- gen_likert(latent_df$PS_true, loading = 0.80, mean_adj = 0.10)
PS2 <- gen_likert(latent_df$PS_true, loading = 0.75, mean_adj = -0.05)
PS3 <- gen_likert(latent_df$PS_true, loading = 0.72, mean_adj = -0.25)
PS4 <- gen_likert(latent_df$PS_true, loading = 0.78, mean_adj = 0.00)
PS5 <- gen_likert(latent_df$PS_true, loading = 0.55, mean_adj = 0.20)  # Weaker item

# Service Quality (SQ): 4 items
SQ1 <- gen_likert(latent_df$SQ_true, loading = 0.82, mean_adj = -0.15)
SQ2 <- gen_likert(latent_df$SQ_true, loading = 0.85, mean_adj = 0.05)
SQ3 <- gen_likert(latent_df$SQ_true, loading = 0.76, mean_adj = -0.10)
SQ4 <- gen_likert(latent_df$SQ_true, loading = 0.74, mean_adj = -0.05)

# Environmental Attitude (EA): 4 items
EA1 <- gen_likert(latent_df$EA_true, loading = 0.81, mean_adj = 0.15)
EA2 <- gen_likert(latent_df$EA_true, loading = 0.78, mean_adj = 0.10)
EA3 <- gen_likert(latent_df$EA_true, loading = 0.74, mean_adj = 0.05)
EA4 <- gen_likert(latent_df$EA_true, loading = 0.71, mean_adj = -0.10)

# Behavioral Intention (BI): 3 items
BI1 <- gen_likert(latent_df$BI_true, loading = 0.84, mean_adj = 0.10)
BI2 <- gen_likert(latent_df$BI_true, loading = 0.80, mean_adj = -0.05)
BI3 <- gen_likert(latent_df$BI_true, loading = 0.76, mean_adj = 0.00)

# Actual Behavior (AB): 3 items
AB1 <- gen_likert(latent_df$AB_true, loading = 0.79, mean_adj = -0.20)
AB2 <- gen_likert(latent_df$AB_true, loading = 0.82, mean_adj = -0.15)
AB3 <- gen_likert(latent_df$AB_true, loading = 0.75, mean_adj = -0.10)

# ==============================================================================
# STEP 3: GENERATE SOCIODEMOGRAPHIC VARIABLES
# ==============================================================================

# Gender (1=Male, 2=Female): 58.9% Male
Gender <- sample(c(1, 2), n, replace = TRUE, prob = c(0.589, 0.411))

# Age Group (1-5)
AgeGroup <- sample(1:5, n, replace = TRUE, prob = c(0.211, 0.396, 0.249, 0.100, 0.044))

# Continuous age
Age <- case_when(
  AgeGroup == 1 ~ round(runif(n, 18, 25)),
  AgeGroup == 2 ~ round(runif(n, 26, 35)),
  AgeGroup == 3 ~ round(runif(n, 36, 45)),
  AgeGroup == 4 ~ round(runif(n, 46, 55)),
  AgeGroup == 5 ~ round(runif(n, 56, 70))
)

# Education Level (1=Primary to 5=Postgraduate)
EducationLevel <- sample(1:5, n, replace = TRUE, prob = c(0.05, 0.15, 0.20, 0.45, 0.15))

# Income Group (1-4)
IncomeGroup <- sample(1:4, n, replace = TRUE, prob = c(0.189, 0.433, 0.256, 0.122))

# Monthly Income (THB, continuous) — correlated with IncomeGroup
Income <- case_when(
  IncomeGroup == 1 ~ round(runif(n, 8000, 14999)),
  IncomeGroup == 2 ~ round(runif(n, 15000, 30000)),
  IncomeGroup == 3 ~ round(runif(n, 30001, 50000)),
  IncomeGroup == 4 ~ round(runif(n, 50001, 150000))
)

# Car Ownership (0=No, 1=Yes) — correlated with income
CarOwnership <- rbinom(n, 1, prob = pmin(0.9, pmax(0.1, (Income - 8000) / 100000)))

# Primary Mode of Transportation (1=Car, 2=Motorcycle, 3=Public Transit, 4=Walk/Cycle)
# Make mode choice partially dependent on PS, SQ, EA scores
ps_z  <- as.numeric(scale(latent_df$PS_true))
sq_z  <- as.numeric(scale(latent_df$SQ_true))
ea_z  <- as.numeric(scale(latent_df$EA_true))

mode_prob_base <- data.frame(
  car   = pmax(0.05, 0.35 - 0.05 * ps_z - 0.05 * sq_z),
  moto  = pmax(0.05, 0.25 - 0.03 * ps_z),
  tran  = pmax(0.05, 0.25 + 0.06 * ps_z + 0.06 * sq_z),
  walk  = pmax(0.05, 0.15 + 0.02 * ea_z)
)
mode_prob_norm <- mode_prob_base / rowSums(mode_prob_base)

PrimaryMode <- apply(mode_prob_norm, 1, function(p) sample(1:4, 1, prob = p))

# Trip distance (km/day, log-normal)
TripDistance_km <- round(rlnorm(n, meanlog = 2.5, sdlog = 0.8), 1)

# Trip time (minutes/day)
TripTime_min <- round(TripDistance_km * runif(n, 2.5, 5.0))

# Number of trips per day
TripsPerDay <- sample(1:6, n, replace = TRUE, prob = c(0.1, 0.4, 0.3, 0.1, 0.07, 0.03))

# Years driving/riding
YearsDriving <- pmax(1, Age - 18 - sample(0:5, n, replace = TRUE))

# Residential zone (1=Urban core, 2=Urban fringe, 3=Suburban, 4=Rural)
ResidentialZone <- sample(1:4, n, replace = TRUE, prob = c(0.35, 0.30, 0.25, 0.10))

# ==============================================================================
# STEP 4: INTRODUCE REALISTIC MISSING DATA (MCAR pattern)
# ==============================================================================

# Income has ~7% missing (common in surveys)
missing_income <- sample(1:n, size = round(0.07 * n))
IncomeGroup[missing_income] <- NA
Income[missing_income]      <- NA

# PS5 has ~2% missing (random)
missing_ps5 <- sample(1:n, size = round(0.02 * n))
PS5[missing_ps5] <- NA

# AB3 has ~3% missing
missing_ab3 <- sample(1:n, size = round(0.03 * n))
AB3[missing_ab3] <- NA

# ==============================================================================
# STEP 5: ASSEMBLE THE DATASET
# ==============================================================================

buts <- data.frame(
  # ID
  RespondentID = paste0("BUTS_", sprintf("%04d", 1:n)),

  # Sociodemographics
  Gender        = Gender,
  Age           = Age,
  AgeGroup      = AgeGroup,
  EducationLevel= EducationLevel,
  IncomeGroup   = IncomeGroup,
  Income        = Income,
  CarOwnership  = CarOwnership,

  # Travel behavior
  PrimaryMode   = PrimaryMode,
  TripDistance_km = TripDistance_km,
  TripTime_min  = TripTime_min,
  TripsPerDay   = TripsPerDay,
  YearsDriving  = YearsDriving,
  ResidentialZone = ResidentialZone,

  # Perceived Safety (5-pt Likert)
  PS1 = PS1, PS2 = PS2, PS3 = PS3, PS4 = PS4, PS5 = PS5,

  # Service Quality (5-pt Likert)
  SQ1 = SQ1, SQ2 = SQ2, SQ3 = SQ3, SQ4 = SQ4,

  # Environmental Attitude (5-pt Likert)
  EA1 = EA1, EA2 = EA2, EA3 = EA3, EA4 = EA4,

  # Behavioral Intention (5-pt Likert)
  BI1 = BI1, BI2 = BI2, BI3 = BI3,

  # Actual Behavior (5-pt Likert)
  AB1 = AB1, AB2 = AB2, AB3 = AB3,

  stringsAsFactors = FALSE
)

# ==============================================================================
# STEP 6: QUALITY CHECKS
# ==============================================================================

cat("==================================================\n")
cat("BUTS DATASET QUALITY CHECK\n")
cat("==================================================\n")
cat(sprintf("Total respondents: %d\n", nrow(buts)))
cat(sprintf("Total variables: %d\n", ncol(buts)))
cat("\nMissing values per variable:\n")
miss <- colSums(is.na(buts))
print(miss[miss > 0])

cat("\nScale item ranges (all should be 1-5):\n")
scale_items <- c("PS1","PS2","PS3","PS4","PS5",
                  "SQ1","SQ2","SQ3","SQ4",
                  "EA1","EA2","EA3","EA4",
                  "BI1","BI2","BI3",
                  "AB1","AB2","AB3")
for(item in scale_items) {
  cat(sprintf("  %-5s: [%d, %d], mean=%.2f, sd=%.2f\n",
              item, min(buts[[item]], na.rm=T), max(buts[[item]], na.rm=T),
              mean(buts[[item]], na.rm=T), sd(buts[[item]], na.rm=T)))
}

cat("\nMode choice distribution:\n")
print(round(prop.table(table(buts$PrimaryMode)) * 100, 1))

cat("\nGender distribution:\n")
print(round(prop.table(table(buts$Gender)) * 100, 1))

# Check inter-construct correlations
cat("\nConstruct-level correlations (should match design):\n")
construct_means <- data.frame(
  PS = rowMeans(buts[, c("PS1","PS2","PS3","PS4")], na.rm = TRUE),
  SQ = rowMeans(buts[, c("SQ1","SQ2","SQ3","SQ4")], na.rm = TRUE),
  EA = rowMeans(buts[, c("EA1","EA2","EA3","EA4")], na.rm = TRUE),
  BI = rowMeans(buts[, c("BI1","BI2","BI3")], na.rm = TRUE),
  AB = rowMeans(buts[, c("AB1","AB2","AB3")], na.rm = TRUE)
)
print(round(cor(construct_means, use = "complete.obs"), 3))

# ==============================================================================
# STEP 7: SAVE DATASET
# ==============================================================================

write.csv(buts, "BUTS_main.csv", row.names = FALSE)

# Create SPSS-friendly version (numeric only, no RespondentID as char)
buts_spss <- buts
buts_spss$RespondentID <- 1:n
write.csv(buts_spss, "BUTS_spss_import.csv", row.names = FALSE)

# Create output directory
dir.create("Output", showWarnings = FALSE)

cat("\n==================================================\n")
cat("Dataset saved:\n")
cat("  BUTS_main.csv       — Main dataset (n=450)\n")
cat("  BUTS_spss_import.csv — SPSS-ready version\n")
cat("==================================================\n")
