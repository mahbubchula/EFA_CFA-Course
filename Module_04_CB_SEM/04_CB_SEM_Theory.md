# 04 — Covariance-Based SEM: Theory, Specification, and Application

> **Module 04 | Covariance-Based Structural Equation Modeling**
> *Course: Advanced Statistical Methods for Transportation & Behavioral Research*
> *Instructor: Dr. Mahbub Hassan, Chulalongkorn University*

---

## 1. What is SEM?

**Structural Equation Modeling (SEM)** is a general framework combining:
- **Measurement model** (CFA): how constructs are measured by indicators
- **Structural model**: causal paths between constructs

```
Full SEM = Measurement Model (CFA) + Structural Model (Path Analysis)
```

### 1.1 Why SEM Over Regression?

| Limitation of Multiple Regression | How SEM Addresses It |
|-----------------------------------|---------------------|
| Assumes predictors are measured without error | SEM explicitly models measurement error |
| Cannot handle latent variables | SEM designed for latent constructs |
| Cannot test mediation rigorously | SEM provides proper mediation tests |
| Single dependent variable | SEM allows multiple endogenous variables |
| No global fit assessment | SEM provides overall model fit |

---

## 2. SEM Model Components

### 2.1 Types of Variables in SEM

```
Exogenous latent (ξ, xi): Not explained by any path in the model
Endogenous latent (η, eta): Explained by paths from other variables
Observed indicators: Items measuring each latent variable
Error terms (δ for x-indicators, ε for y-indicators)
Disturbance terms (ζ, zeta): Residual of endogenous latents
```

### 2.2 Structural Paths

```
H1: Perceived Safety (PS) → Behavioral Intention (BI)
H2: Service Quality (SQ) → Behavioral Intention (BI)
H3: Environmental Attitude (EA) → Behavioral Intention (BI)
H4: Behavioral Intention (BI) → Actual Behavior (AB)
H5: Service Quality (SQ) → Perceived Safety (PS)  [indirect effect]
```

---

## 3. Specifying the Full SEM

### 3.1 lavaan Model Syntax

```r
sem_model <- '
  # ==== MEASUREMENT MODEL ====
  # Exogenous constructs (ξ)
  PS =~ PS1 + PS2 + PS3 + PS4   # Perceived Safety
  SQ =~ SQ1 + SQ2 + SQ3 + SQ4   # Service Quality
  EA =~ EA1 + EA2 + EA3 + EA4   # Environmental Attitude

  # Endogenous constructs (η)
  BI =~ BI1 + BI2 + BI3         # Behavioral Intention
  AB =~ AB1 + AB2 + AB3         # Actual Behavior

  # ==== STRUCTURAL MODEL ====
  # Direct effects (H1–H4)
  BI ~ PS + SQ + EA             # H1: PS→BI, H2: SQ→BI, H3: EA→BI
  AB ~ BI + PS                  # H4: BI→AB, H5: PS→AB (direct)
'
```

### 3.2 Two-Step Approach (Anderson & Gerbing, 1988)
**Best practice in transportation research:**

```
Step 1: Establish acceptable CFA (measurement model)
        ↓ Only after acceptable CFA fit
Step 2: Add structural paths and test the full model
```

Never estimate structural paths without first validating the measurement model.

---

## 4. Model Fit Assessment (Same as CFA)

Model fit thresholds are identical to CFA (Module 03):

| Index | Acceptable | Good |
|-------|-----------|------|
| χ²/df | ≤ 3.0 | ≤ 2.0 |
| CFI | ≥ 0.90 | ≥ 0.95 |
| TLI | ≥ 0.90 | ≥ 0.95 |
| RMSEA | ≤ 0.08 | ≤ 0.06 |
| SRMR | ≤ 0.08 | ≤ 0.06 |

**Note**: Adding structural paths often slightly worsens fit compared to the unconstrained CFA. This is acceptable as long as fit indices remain within acceptable range.

---

## 5. Interpreting Structural Path Coefficients

### 5.1 Standardized vs. Unstandardized

- **Unstandardized (B)**: Effect in original units; needed for prediction
- **Standardized (β)**: Effect in SD units; used for comparing effect sizes

```
β (standardized path coefficient):
  β = 0.10:  Small effect
  β = 0.30:  Medium effect
  β = 0.50+: Large effect
```

### 5.2 Effect Size: Cohen's f²

```
f² = R²included - R²excluded
     ────────────────────────
          1 - R²included

f² = 0.02: Small
f² = 0.15: Medium
f² = 0.35: Large
```

### 5.3 R² (Coefficient of Determination)

R² for each endogenous variable = proportion of variance explained:
- **R² < 0.10**: Weak explanation
- **R² 0.10–0.25**: Moderate
- **R² > 0.25**: Substantial (for behavioral models in transportation)

In SEM context:
- **R² ≥ 0.10**: Acceptable
- Some structural relationships in complex models may have lower R² — context matters

---

## 6. Mediation Analysis

### 6.1 What is Mediation?

```
X ────────────────────────────→ Y    (Direct Effect: c')
    ↓              ↑
    X → M → Y                       (Indirect Effect: a × b)
```

**Full mediation**: c' ≈ 0; indirect effect is significant
**Partial mediation**: c' significant; indirect effect also significant
**No mediation**: indirect effect is not significant

### 6.2 Baron & Kenny (1986) — Classical Approach (NOT recommended alone)

Step 1: X → Y significant
Step 2: X → M significant
Step 3: M → Y (with X) significant
Step 4: X → Y (with M) reduced or non-significant

**Problem**: Does not provide a proper test of the indirect effect.

### 6.3 Bootstrapped Confidence Intervals — CURRENT BEST PRACTICE

**Bootstrapped indirect effect**:
```
Indirect Effect (a × b) = effect of X on M × effect of M on Y
```

- Draw 5000 bootstrap samples
- Compute a × b for each sample
- Construct 95% (or 99%) CI for the indirect effect
- **If CI does not include zero**: indirect effect is significant

**In lavaan**: Use `:=` operator and `parameterEstimates(fit, boot.ci.type="bca.simple")`
**In AMOS**: Use bootstrapping option in Analysis Properties

### 6.4 Mediation Example: Transportation Research

**Research model:**
```
Service Quality (SQ) → Perceived Safety (PS) → Behavioral Intention (BI)
```

```r
# lavaan syntax for mediation
mediation_model <- '
  # Measurement model (abbreviated)
  PS =~ PS1 + PS2 + PS3 + PS4
  SQ =~ SQ1 + SQ2 + SQ3 + SQ4
  BI =~ BI1 + BI2 + BI3

  # Structural paths
  PS ~ a*SQ       # Path a: SQ → PS
  BI ~ b*PS + cp*SQ  # Path b: PS → BI; cp: direct SQ → BI

  # Indirect and total effects
  ab   := a * b        # Indirect effect
  total := cp + a * b  # Total effect
'
```

---

## 7. Moderation Analysis (Interaction Effects)

### 7.1 Moderation in SEM

Moderation tests whether the effect of X on Y **depends on the level of a third variable Z** (the moderator).

```
X → Y:  Effect changes depending on Z
```

### 7.2 Unconstrained Product Indicator Approach

For **latent variable moderation** in AMOS/lavaan:

```r
# Product indicator approach for latent moderation
# Interaction: SQ × EA on BI

# Create product indicators
data$SQ1_EA1 <- data$SQ1 * data$EA1
data$SQ2_EA2 <- data$SQ2 * data$EA2
data$SQ3_EA3 <- data$SQ3 * data$EA3

moderation_model <- '
  SQ =~ SQ1 + SQ2 + SQ3
  EA =~ EA1 + EA2 + EA3
  BI =~ BI1 + BI2 + BI3

  # Interaction construct
  SQ_EA =~ SQ1_EA1 + SQ2_EA2 + SQ3_EA3

  # Structural model with interaction
  BI ~ SQ + EA + SQ_EA   # SQ_EA = interaction term
'
```

### 7.3 SmartPLS Moderation (Easier)

SmartPLS 4.0 provides a dedicated **Moderating Effect** module:
- Two-Stage approach: More accurate
- Product Indicator: Classic approach
- Floodlight analysis: Find significance zones

---

## 8. Model Comparison

When comparing competing models (e.g., full vs. reduced model):

### 8.1 Chi-Square Difference Test (for nested models)
```
Δχ² = χ²(Model A) - χ²(Model B)
Δdf = df(Model A) - df(Model B)

If Δχ² > χ²critical (at Δdf): Model B fits significantly better
```

### 8.2 AIC and BIC (for non-nested models)
- Lower AIC/BIC: Better fit, penalizing complexity
- ΔAIC > 10: Strong evidence favoring lower-AIC model

---

## 9. Reporting SEM Results

### Table A: Structural Model Results

| Hypothesis | Path | β | SE | t | p | Supported? |
|-----------|------|---|-----|---|---|-----------|
| H1 | PS → BI | 0.312 | 0.041 | 7.61 | <.001 | ✓ Yes |
| H2 | SQ → BI | 0.287 | 0.038 | 7.55 | <.001 | ✓ Yes |
| H3 | EA → BI | 0.245 | 0.044 | 5.57 | <.001 | ✓ Yes |
| H4 | BI → AB | 0.521 | 0.049 | 10.63 | <.001 | ✓ Yes |
| H5 | PS → AB | 0.178 | 0.055 | 3.24 | .001 | ✓ Yes |

R²(BI) = 0.412; R²(AB) = 0.384

*Note*. β = standardized path coefficient. SE = standard error.
Fit: χ²/df = 2.41, CFI = .958, TLI = .951, RMSEA = .056 [.049, .064], SRMR = .051.

### Table B: Mediation Analysis

| Path | Indirect Effect (β) | 95% BCa CI | Mediation |
|------|-------------------|-----------|---------|
| SQ → PS → BI | 0.142 | [0.098, 0.189] | Partial |
| EA → PS → BI | 0.108 | [0.071, 0.152] | Partial |

*Note*. Bootstrap n = 5000. CI = confidence interval. BCa = bias-corrected accelerated.
Mediation supported when CI does not include zero.

---

## 10. Common SEM Applications in Transportation Research

### 10.1 Mode Choice Behavior (TPB-based SEM)
```
Attitude → Behavioral Intention → Mode Choice
Social Norm ↗                    ↑
Perceived Control ───────────────┘
```

### 10.2 Road Safety Model (PMT-based SEM)
```
Threat Severity ──┐
Vulnerability    ─┼→ Threat Appraisal → Safety Intention → Behavior
Self-Efficacy   ──┼→ Coping Appraisal ↗
Response Efficacy─┘
```

### 10.3 Transit Service Quality → Ridership
```
Service Quality ──→ Satisfaction ──→ Loyalty/Ridership
                          ↑
                   Perceived Value
```

### 10.4 Pro-Environmental Travel
```
Environmental Values → Awareness → Personal Norm → Green Travel Behavior
```

---

## References

- Anderson, J. C., & Gerbing, D. W. (1988). Structural equation modeling in practice. *Psychological Bulletin*, 103(3), 411–423.
- Baron, R. M., & Kenny, D. A. (1986). The moderator-mediator variable distinction. *Journal of Personality and Social Psychology*, 51(6), 1173–1182.
- Hair, J. F., Black, W. C., Babin, B. J., & Anderson, R. E. (2019). *Multivariate Data Analysis* (8th ed.). Cengage.
- Kline, R. B. (2023). *Principles and Practice of Structural Equation Modeling* (5th ed.). Guilford.
- MacKinnon, D. P. (2008). *Introduction to Statistical Mediation Analysis*. Erlbaum.
- Preacher, K. J., & Hayes, A. F. (2008). Asymptotic and resampling strategies for assessing and comparing indirect effects. *Behavior Research Methods*, 40(3), 879–891.
- Washington, S., Karlaftis, M., Mannering, F., & Anastasopoulos, P. (2020). *Statistical and Econometric Methods for Transportation Data Analysis* (3rd ed.). CRC Press.

---

*See also: [04_R_lavaan_SEM_Script.R](./04_R_lavaan_SEM_Script.R) | [04_SPSS_AMOS_Guide.md](./04_SPSS_AMOS_Guide.md)*
