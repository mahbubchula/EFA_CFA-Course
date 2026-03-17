---
title: "05 · Exercises"
parent: "05 · Regression Analysis"
nav_order: 4
---

# Module 05 — Exercises: Regression Analysis
{: .no_toc }

**Module 05 · Regression Analysis**
{: .label .label-green }

---

## Instructions

Use the **BUTS dataset** (`BUTS_main.csv`) for all exercises. Apply both SPSS and R where specified.

{: .note }
> Before starting, compute composite mean scores for PS, SQ, EA, BI, and AB (see Module 01 for recoding and composite computation).

---

## Exercise 1 — Simple Linear Regression

**Objective**: Predict Behavioral Intention from Perceived Safety.

**SPSS / R Task**:

1. Run a simple linear regression with `BI_mean` as the dependent variable and `PS_mean` as the predictor.

2. Fill in this table:

| Statistic | Value |
|-----------|-------|
| R | |
| R² | |
| Adjusted R² | |
| F-statistic | |
| p-value | |
| B (PS_mean) | |
| β (standardized) | |
| t-value | |

3. Plot the regression line using a scatterplot of PS_mean vs BI_mean.

4. Write one sentence interpreting the R² value and one sentence interpreting the slope (B).

5. Are the regression assumptions met? Check:
   - Normality of residuals (histogram / Q-Q plot)
   - Homoscedasticity (residual vs. fitted plot)

---

## Exercise 2 — Multiple Linear Regression

**Objective**: Predict Behavioral Intention from multiple predictors.

**Tasks**:

1. Run multiple linear regression with `BI_mean` as the outcome and `PS_mean`, `SQ_mean`, `EA_mean` as predictors (Enter method).

2. Complete the results table:

| Predictor | B | SE | β | t | p | 95% CI |
|-----------|---|-----|---|---|---|--------|
| (Constant) | | | | | | |
| PS_mean | | | | | | |
| SQ_mean | | | | | | |
| EA_mean | | | | | | |

3. Report the overall model fit: F(___,___) = ___, p = ___, R² = ___, Adj. R² = ___

4. Check multicollinearity:

| Predictor | Tolerance | VIF |
|-----------|----------|-----|
| PS_mean | | |
| SQ_mean | | |
| EA_mean | | |

Is multicollinearity a problem? (VIF > 5 is concerning)

5. **Hierarchical regression**:
   - Block 1: `PS_mean` only
   - Block 2: Add `SQ_mean` and `EA_mean`

   Is the change in R² from Block 1 to Block 2 statistically significant?

6. Which predictor has the strongest effect on BI? How do you know?

---

## Exercise 3 — Binary Logistic Regression

**Objective**: Predict public transit use vs. private car use.

**Setup**: Create a binary variable `transit_use` from `mode_choice`:
- 0 = private car (mode_choice == 0)
- 1 = public transit (mode_choice == 2)
- Exclude motorcycles (1) and walking (3) for this exercise

In SPSS: `Transform → Compute` → `transit_use = (mode_choice == 2)`. Then filter to keep only modes 0 and 2.

In R:
```r
df_binary <- BUTS_data %>%
  filter(mode_choice %in% c(0, 2)) %>%
  mutate(transit_use = ifelse(mode_choice == 2, 1, 0))
```

**Tasks**:

1. Run binary logistic regression: outcome = `transit_use`, predictors = `PS_mean`, `SQ_mean`, `EA_mean`, `gender`, `income`.

2. Complete the results table (fill in B, SE, Wald, p, OR, 95% CI for OR):

| Predictor | B | SE | Wald | p | Exp(B) = OR | 95% CI |
|-----------|---|-----|------|---|------------|--------|
| PS_mean | | | | | | |
| SQ_mean | | | | | | |
| EA_mean | | | | | | |
| gender | | | | | | |
| income | | | | | | |
| Constant | | | | | | |

3. Report: Nagelkerke R² = ___, Hosmer-Lemeshow χ² = ___, p = ___

4. Is the Hosmer-Lemeshow test significant? What does this tell you about model fit?

5. What is the overall classification accuracy? ___% correct

6. **Interpretation**: In plain language, explain the odds ratio for `SQ_mean`. What does it mean for transit demand policy?

---

## Exercise 4 — Multinomial Logistic Regression

**Objective**: Predict mode choice (car/motorcycle/transit/walk) from attitudinal and sociodemographic variables.

**Tasks**:

1. Run multinomial logistic regression: outcome = `mode_choice` (4 categories), predictors = `PS_mean`, `SQ_mean`, `EA_mean`, `gender`, `income`, `age_group`.

   Reference category = 0 (car)

2. Report model fit:
   - Model χ²(df) = ___, p = ___
   - Nagelkerke R² = ___
   - Overall % classification = ___

3. Complete the odds ratio table for the comparison **Transit vs. Car**:

| Predictor | B | SE | Wald | p | Exp(B) |
|-----------|---|-----|------|---|--------|
| PS_mean | | | | | |
| SQ_mean | | | | | |
| EA_mean | | | | | |
| gender | | | | | |
| income_1 | | | | | |
| income_2 | | | | | |

4. Which predictor most strongly distinguishes transit users from car users?

5. Is the model better at classifying some modes than others? Report the per-category classification accuracy.

---

## Exercise 5 — Ordinal Logistic Regression

**Objective**: Analyze crash severity determinants.

**Setup**: Use the `crash_severity` variable (1=minor, 2=moderate, 3=severe, 4=fatal) and predictors related to crash circumstances.

If your BUTS dataset doesn't include crash severity variables, create simulated ones in R:
```r
set.seed(42)
n <- 450
BUTS_data$crash_severity <- sample(1:4, n, replace = TRUE,
                                   prob = c(0.40, 0.30, 0.20, 0.10))
BUTS_data$speed_excess <- rnorm(n, mean = 10, sd = 5)
BUTS_data$alcohol <- rbinom(n, 1, prob = 0.12)
BUTS_data$seatbelt <- rbinom(n, 1, prob = 0.78)
```

**Tasks**:

1. Run ordinal logistic regression (proportional odds model):
   - Outcome: `crash_severity` (ordered: 1 < 2 < 3 < 4)
   - Predictors: `speed_excess`, `alcohol`, `seatbelt`, `gender`, `age_group`

2. Report the **Test of Parallel Lines** result:
   - χ²(_) = ___, p = ___
   - Is the proportional odds assumption met?

3. Complete the parameter estimates table:

| Parameter | Estimate | SE | Wald | p | exp(B) |
|-----------|---------|-----|------|---|--------|
| Threshold [1\|2] | | | | | — |
| Threshold [2\|3] | | | | | — |
| Threshold [3\|4] | | | | | — |
| speed_excess | | | | | |
| alcohol | | | | | |
| seatbelt | | | | | |
| gender | | | | | |

4. Interpret the coefficient for `speed_excess` in terms of odds of being in a higher severity category.

5. **Policy implication**: Based on your results, which factor is most important for crash severity reduction? Justify with statistics.

---

## Exercise 6 — Count Regression (Poisson / Negative Binomial)

**Objective**: Model the number of crash events per observation period.

**Setup**: Create a crash count variable if not present:
```r
set.seed(42)
BUTS_data$crash_count <- rpois(nrow(BUTS_data), lambda = 2.5)
# Introduce overdispersion:
BUTS_data$crash_count <- rnbinom(nrow(BUTS_data), mu = 2.5, size = 1.8)
```

**Tasks**:

1. First, run **Poisson regression**: outcome = `crash_count`, predictors = `speed_excess`, `road_type`, `traffic_volume` (or similar).

2. Check for overdispersion:
   - Pearson χ²/df = ___
   - Is overdispersion present? (criterion: ratio > 1.5)

3. If overdispersed, run **Negative Binomial regression** with the same predictors.

4. Compare the two models:

| | Poisson | Negative Binomial |
|-|---------|------------------|
| -2 Log Likelihood | | |
| AIC | | |
| Pearson χ²/df | | |
| k (dispersion) | n/a | |

5. Report the Incidence Rate Ratios (IRR = exp(B)) for the better-fitting model.

6. **Interpretation**: What does an IRR of 1.45 for `road_type=highway` mean?

---

## Exercise 7 — Writing Up Regression Results

**Objective**: Practice academic writing for regression results.

Choose **one** of the following scenarios and write a complete results section (250–400 words):

**Option A — Linear Regression**:
> Write up the results from Exercise 2 (multiple linear regression predicting BI). Include the model summary, assumption checks, and interpretation of each significant predictor.

**Option B — Logistic Regression**:
> Write up the results from Exercise 3 (binary logistic regression predicting transit use). Include model fit statistics, odds ratios with confidence intervals, and classification accuracy.

**Option C — Crash Analysis**:
> Write up the results from Exercise 5 (ordinal regression of crash severity). Include assumption checks, significant predictors, and policy implications.

**Your write-up should include**:
- [ ] Sample description (n, outcome variable description)
- [ ] Software used (SPSS version / R version and packages)
- [ ] Model fit statistics
- [ ] Correct coefficients with significance levels
- [ ] Plain-language interpretation of at least 2 predictors
- [ ] Appropriate table or figure

---

## Answer Hints

{: .note }
> These are approximate expected values. Your results may differ depending on missing data handling and how variables are coded.

**Exercise 1 Expected**:
- R² ≈ .36–.42 (PS alone predicts about 38% of BI variance)
- β ≈ .60–.65

**Exercise 2 Expected**:
- R² ≈ .42–.48 (three predictors combined)
- All three predictors: p < .001
- PS has the strongest β (standardized)

**Exercise 3 Expected**:
- Nagelkerke R² ≈ .22–.28
- SQ_mean OR ≈ 1.8–2.2
- Overall accuracy ≈ 75–85%

**Exercise 5 Expected**:
- Parallel lines test: p > .05 (assumption met)
- speed_excess: significant (p < .001), positive coefficient
- seatbelt: significant (p < .001), negative coefficient (protective)

---

*[← Back to Module 05 Overview](./README.md)*
