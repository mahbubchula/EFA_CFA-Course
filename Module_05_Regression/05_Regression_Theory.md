---
title: "Theory"
parent: "05 · Regression Analysis"
nav_order: 1
---

# 05 — Regression Analysis: Theory and Applications

> **Module 05 | Regression Analysis**
> *Course: Advanced Statistical Methods for Transportation & Behavioral Research*
> *Instructor: Mahbub Hassan, Chulalongkorn University*

---

## 1. Overview: When to Use Which Regression

```
Outcome Variable Type?
        │
        ├── Continuous (interval/ratio)
        │       ├── 1 predictor       → Simple Linear Regression
        │       └── Multiple predictors → Multiple Linear Regression
        │
        ├── Binary (0 or 1)            → Binary Logistic Regression
        │
        ├── 3+ unordered categories    → Multinomial Logistic Regression
        │
        ├── 3+ ordered categories      → Ordinal Logistic Regression
        │       (e.g., severity: minor/moderate/severe)
        │
        └── Count data
                ├── No overdispersion  → Poisson Regression
                └── Overdispersion     → Negative Binomial Regression
```

---

## 2. Multiple Linear Regression

### 2.1 The Model

```
Y = β₀ + β₁X₁ + β₂X₂ + ... + βₖXₖ + ε

Where:
  Y    = dependent variable (continuous)
  Xᵢ   = independent variables (predictors)
  βᵢ   = regression coefficients
  β₀   = intercept
  ε    = error term (residual)
```

### 2.2 Assumptions (LINE)

| Assumption | Description | Diagnostic |
|-----------|-------------|-----------|
| **L**inearity | Y is linear in Xᵢ | Residuals vs. fitted plot; added variable plots |
| **I**ndependence | Residuals are independent | Durbin-Watson test (1.5–2.5 acceptable) |
| **N**ormality | Residuals are normally distributed | Q-Q plot, Shapiro-Wilk of residuals |
| **E**qual variance (Homoscedasticity) | Constant variance of residuals | Breusch-Pagan test; residual vs. fitted plot |
| **No multicollinearity** | Predictors not highly correlated | VIF < 10 (ideally < 5); tolerance > 0.10 |

### 2.3 Model Evaluation

**R²**: Proportion of variance explained
```
R² = SSR / SST = 1 - SSE/SST
```

**Adjusted R²**: Penalizes for adding non-significant predictors
```
R²adj = 1 - [(1-R²)(n-1)/(n-k-1)]
```

**F-test**: Tests overall model significance
```
F = (R²/k) / [(1-R²)/(n-k-1)]
H₀: All β = 0 (model explains no variance)
```

**Effect Size**: f² = R² / (1 - R²)
- f² = 0.02: Small
- f² = 0.15: Medium
- f² = 0.35: Large

### 2.4 Interpreting Coefficients

**Unstandardized (B)**: Change in Y for 1-unit increase in Xᵢ, holding others constant.
**Standardized (β)**: Change in Y (in SD units) per 1 SD increase in Xᵢ. Use for comparing predictor importance.

### 2.5 Regression in Transportation: Example

**Research question**: What factors predict daily travel distance (km)?

```
Travel Distance = β₀ + β₁(Income) + β₂(Car Ownership) + β₃(Workplace Distance)
                      + β₄(Urbanization Level) + ε
```

---

## 3. Multicollinearity Diagnosis and Remedies

### 3.1 Variance Inflation Factor (VIF)

```
VIF = 1 / (1 - R²j)

Where R²j = R² when regressing Xj on all other predictors
```

| VIF | Interpretation |
|-----|---------------|
| 1 | No collinearity |
| 1–5 | Moderate (acceptable) |
| 5–10 | High (investigate) |
| > 10 | Severe — problematic |

### 3.2 Tolerance = 1/VIF
Tolerance < 0.10 → Severe multicollinearity

### 3.3 Remedies
1. Remove one of a highly correlated pair
2. Combine predictors (factor score from PCA)
3. Ridge regression (for severe cases)
4. Use structural equation model (SEM handles latent variable correlation)

---

## 4. Binary Logistic Regression

### 4.1 Why Not Linear Regression for Binary Outcomes?

Linear regression with a binary outcome violates:
- Homoscedasticity (variance depends on predicted value)
- Normality of residuals
- Produces predictions outside [0, 1]

**Solution**: Model the **log-odds** (logit) of the outcome.

### 4.2 The Logistic Regression Model

```
log[P(Y=1) / (1-P(Y=1))] = β₀ + β₁X₁ + ... + βₖXₖ

Or equivalently:
P(Y=1) = 1 / (1 + e^-(β₀ + β₁X₁ + ... + βₖXₖ))
```

### 4.3 Odds Ratio (OR) = exp(β)

The odds ratio is the primary interpretive statistic:

```
OR = exp(β)

OR > 1: Predictor increases odds of Y=1
OR < 1: Predictor decreases odds of Y=1
OR = 1: No effect
```

**Example interpretation**: OR = 1.42 for income:
"Each unit increase in income multiplies the odds of choosing transit by 1.42 (i.e., 42% increase in odds)."

### 4.4 Model Fit for Logistic Regression

| Measure | Description | Threshold |
|---------|-------------|-----------|
| **-2LL** | -2 log-likelihood; lower is better | — |
| **Cox & Snell R²** | Pseudo-R² | > 0.10 modest |
| **Nagelkerke R²** | Pseudo-R² (corrected) | > 0.20 acceptable |
| **Hosmer-Lemeshow** | Test of calibration | p > 0.05 |
| **Classification accuracy** | % correctly classified | > 70% good |

### 4.5 Example: Mode Choice Research

**Research question**: What predicts the choice of public transit over private car?

```
log[P(Transit) / P(Car)] = β₀ + β₁(Income) + β₂(Car Ownership)
                                + β₃(Perceived Safety) + β₄(Service Quality)
                                + β₅(Environmental Attitude)
```

| Predictor | B | OR | 95% CI | p |
|-----------|---|-----|--------|---|
| Income (high) | −0.42 | 0.66 | [0.51, 0.85] | .001 |
| Car ownership | −0.81 | 0.44 | [0.32, 0.62] | <.001 |
| Perceived Safety | +0.53 | 1.70 | [1.38, 2.09] | <.001 |
| Service Quality | +0.61 | 1.84 | [1.48, 2.29] | <.001 |
| Env. Attitude | +0.38 | 1.46 | [1.18, 1.82] | .001 |

---

## 5. Ordinal Logistic Regression (Proportional Odds Model)

### 5.1 When to Use

Use when the outcome is **ordered categorical**:
- Crash severity: 1=PDO, 2=Injury, 3=Fatality
- Satisfaction: 1=Very Dissatisfied to 5=Very Satisfied
- Service frequency: 1=Rare, 2=Occasional, 3=Regular, 4=Frequent

### 5.2 The Proportional Odds Model

```
log[P(Y ≤ j) / P(Y > j)] = αj - β₁X₁ - ... - βₖXₖ

Where αj = threshold for category j (j = 1, ..., J-1)
```

**Key assumption — Proportional Odds**:
The effect of each predictor is the same for all category comparisons.
Test: Brant test or Score test of proportionality

### 5.3 Interpretation

- **OR > 1**: Predictor increases the odds of being in a higher category
- **Example**: OR = 1.52 for speed:
  "Each unit increase in speed multiplies the odds of being in a higher severity category by 1.52"

### 5.4 Application: Crash Severity Analysis

```
Crash Severity = f(Speed limit, Road type, Time of day, Driver age,
                   Vehicle type, Weather, Road surface)
```

This is a classic application in accident research; ordinal regression is recommended when severity categories are ordered.

---

## 6. Poisson and Negative Binomial Regression (Count Outcomes)

### 6.1 When to Use

Outcome = count (non-negative integer):
- Number of crashes per road segment per year
- Number of traffic violations per driver
- Number of near-miss incidents

### 6.2 Poisson Regression

```
log(μ) = β₀ + β₁X₁ + ... + βₖXₖ

Where μ = expected count
```

**Assumption**: Mean = Variance (equidispersion)
**Check**: Deviance/df ≈ 1.0 (if >> 1: overdispersion)

### 6.3 Negative Binomial Regression

Use when variance >> mean (overdispersion) — very common in crash data:

```
log(μ) = β₀ + β₁X₁ + ... + βₖXₖ + ε

Where ε follows a Gamma distribution
```

**Interpretation**: Incidence Rate Ratio (IRR) = exp(β)
- IRR = 1.25 for lanes: "Each additional lane is associated with 25% more crashes"

---

## 7. Hierarchical (Sequential) Regression

Testing if adding a block of predictors significantly improves fit:

```
Model 1 (Block 1): Demographics only
    → F₁, R₁²

Model 2 (Block 2): Demographics + Attitudes
    → F₂, R₂²

ΔR² = R₂² - R₁²
ΔF = [(R₂² - R₁²)/k₂] / [(1-R₂²)/(n-k₁-k₂-1)]
```

If ΔF is significant (p < .05): Block 2 variables explain significant additional variance.

**Application in transportation**:
- Block 1: Sociodemographics (control variables)
- Block 2: Attitudinal factors (main interest)
- Block 3: Situational factors

---

## 8. Reporting Regression Results

### Publication Table (Multiple Linear Regression)

**Table X. Hierarchical Multiple Regression Results**

| Predictor | Block 1 β | Block 2 β |
|-----------|-----------|-----------|
| Gender (female) | .08 | .05 |
| Age | −.12* | −.09 |
| Income | .15** | .11* |
| **Perceived Safety** | | .31*** |
| **Service Quality** | | .27*** |
| **Environmental Attitude** | | .22*** |
| R² | .065 | .318 |
| ΔR² | | .253 |
| ΔF | | 42.1*** |

*p < .05; **p < .01; ***p < .001. n = 450.

### Publication Table (Binary Logistic Regression)

**Table X. Binary Logistic Regression: Predictors of Transit Choice**

| Predictor | B | SE | Wald | df | p | OR | 95% CI |
|-----------|---|-----|------|----|----|-----|--------|
| Perceived Safety | 0.53 | 0.11 | 23.2 | 1 | <.001 | 1.70 | [1.37, 2.10] |
| Service Quality | 0.61 | 0.11 | 30.7 | 1 | <.001 | 1.84 | [1.48, 2.29] |
| Env. Attitude | 0.38 | 0.11 | 11.8 | 1 | .001 | 1.46 | [1.18, 1.82] |

Cox & Snell R² = .218; Nagelkerke R² = .295; Classification accuracy = 76.2%.

---

## References

- Field, A. (2024). *Discovering Statistics Using IBM SPSS Statistics* (6th ed.). Sage.
- Hair, J. F., Black, W. C., Babin, B. J., & Anderson, R. E. (2019). *Multivariate Data Analysis* (8th ed.). Cengage.
- Hosmer, D. W., Lemeshow, S., & Sturdivant, R. X. (2013). *Applied Logistic Regression* (3rd ed.). Wiley.
- Lord, D., & Mannering, F. (2010). The statistical analysis of crash-frequency data. *Transportation Research Part A*, 44(5), 291–305.
- Washington, S., Karlaftis, M., Mannering, F., & Anastasopoulos, P. (2020). *Statistical and Econometric Methods for Transportation Data Analysis* (3rd ed.). CRC Press.

---

*See also: [05_SPSS_Guide.md](./05_SPSS_Guide.md) | [05_R_Script.R](./05_R_Script.R)*
