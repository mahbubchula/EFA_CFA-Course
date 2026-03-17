---
title: "Theory"
parent: "03 · Confirmatory Factor Analysis"
nav_order: 1
---

# 03 — Confirmatory Factor Analysis: Complete Theory and Guide

> **Module 03 | Confirmatory Factor Analysis (CFA)**
> *Course: Advanced Statistical Methods for Transportation & Behavioral Research*
> *Instructor: Mahbub Hassan, Chulalongkorn University*

---

## 1. What is CFA and Why Do We Need It?

**Confirmatory Factor Analysis (CFA)** tests a **researcher-specified** factor structure against observed data. You hypothesize exactly which items load on which factors, then evaluate how well this model fits the data.

### CFA vs. EFA

| Dimension | EFA | CFA |
|-----------|-----|-----|
| Purpose | Discover factor structure | Confirm/test factor structure |
| Factor-item assignment | Data-driven | Theory/EFA-driven (specified in advance) |
| Cross-loadings | Allowed | Constrained to zero (by default) |
| Model fit | Not evaluated globally | Formally tested with fit indices |
| Validity assessment | Not formally tested | Convergent and discriminant validity |
| Use in research | Scale development | Scale validation, pre-SEM measurement |

### Why CFA is required before SEM

1. **Measurement quality verification**: If indicators poorly measure their construct, structural paths will be biased
2. **Model identification**: CFA establishes proper identification of the measurement model
3. **Publication requirements**: Most top journals require CFA results before presenting SEM
4. **Validity evidence**: CFA provides formal tests of convergent and discriminant validity

---

## 2. CFA Model Specification

### 2.1 The CFA Model

For construct k and indicator j:

```
Xj = λjk × ξk + δj

Where:
  Xj  = observed indicator j
  λjk = factor loading (strength of relationship)
  ξk  = latent factor k
  δj  = measurement error (unique variance)
```

In matrix notation: **x = Λξ + δ**

### 2.2 Identification

A CFA model must be **identified** (enough known information to estimate all unknown parameters).

**Degrees of freedom**:
```
df = (p × (p+1)/2) − q

Where:
  p = number of observed variables
  q = number of free parameters (loadings, variances, covariances)
```

For a model to be identified:
- **df > 0**: Over-identified (testable) ← What we want
- **df = 0**: Just-identified (no fit test possible)
- **df < 0**: Under-identified (cannot be estimated)

**Model identification requirements:**
- Fix the scale of each factor (either fix one loading to 1.0, OR fix factor variance to 1.0)
- Each factor should have ≥ 3 indicators (for proper identification)

### 2.3 A Four-Factor CFA Example

```
lavaan syntax:

# Factor 1: Perceived Safety
PS =~ PS1 + PS2 + PS3 + PS4

# Factor 2: Service Quality
SQ =~ SQ1 + SQ2 + SQ3 + SQ4

# Factor 3: Environmental Attitude
EA =~ EA1 + EA2 + EA3 + EA4

# Factor 4: Behavioral Intention
BI =~ BI1 + BI2 + BI3

# Covariances (automatically estimated in CFA)
PS ~~ SQ
PS ~~ EA
PS ~~ BI
SQ ~~ EA
SQ ~~ BI
EA ~~ BI
```

The `=~` operator defines "is measured by" in lavaan.

---

## 3. Model Estimation Methods

### 3.1 Maximum Likelihood (ML) — Default
- Most common estimator
- Assumes multivariate normality
- Produces chi-square test and standard errors
- **Use when**: data are approximately normally distributed

### 3.2 Robust ML Estimators (when normality is violated)
- **MLR** (Yuan-Bentler scaled statistic): Robust to non-normality
- **MLM** (Satorra-Bentler): Corrects chi-square for non-normality
- **Use when**: |Skewness| > 2 or |Kurtosis| > 7 for some items
- In lavaan: `estimator = "MLR"`

### 3.3 Weighted Least Squares (for ordinal data)
- **DWLS** (Diagonally Weighted Least Squares): Best for ordinal Likert data
- Uses polychoric correlations
- In lavaan: `estimator = "WLSMV"`
- **Use when**: Treating Likert items as truly ordinal

**Practical recommendation**: For 5-point Likert scales with reasonable normality (|skew| < 2), ML or MLR is acceptable and widely used in transportation research.

---

## 4. Model Fit Assessment

Model fit indices evaluate how well the specified model reproduces the observed covariance matrix.

### 4.1 Chi-Square (χ²) Test

```
H₀: Model-implied Σ = Observed Σ (perfect fit)
H₁: Model-implied Σ ≠ Observed Σ
```

- We WANT to fail to reject H₀ (we want p > 0.05)
- But: With large samples (n > 200), χ² is almost always significant
- **Report χ² and df** but do not use as sole criterion
- **χ²/df ratio** (normed chi-square): ≤ 3.0 acceptable; ≤ 2.0 good

### 4.2 Comparative Fit Index (CFI)

```
CFI = 1 − (λmodel / λbaseline)

Where λ = max(χ² − df, 0)
```

- Compares model to independence (null) model
- **CFI ≥ 0.90**: Acceptable fit
- **CFI ≥ 0.95**: Good fit
- Not sensitive to sample size
- Most commonly reported in behavioral research

### 4.3 Tucker-Lewis Index (TLI) / Non-Normed Fit Index (NNFI)

- Similar to CFI; penalizes model complexity
- **TLI ≥ 0.90**: Acceptable; **TLI ≥ 0.95**: Good
- Can exceed 1.0 for very good models
- More conservative than CFI

### 4.4 Root Mean Square Error of Approximation (RMSEA)

```
RMSEA = √[(χ² − df) / (df × (n − 1))]
```

- Measures "error per degree of freedom"
- **RMSEA ≤ 0.05**: Close fit
- **RMSEA ≤ 0.08**: Acceptable (commonly used threshold)
- **RMSEA ≤ 0.10**: Marginal fit
- **RMSEA > 0.10**: Poor fit
- Report 90% confidence interval: [RMSEA_lo, RMSEA_hi]
- p(RMSEA ≤ 0.05) > 0.05: Test for close fit (p_close)

### 4.5 Standardized Root Mean Square Residual (SRMR)

```
SRMR = √(2Σi Σj≤i (sij − σ̂ij)² / (p(p+1)))
```

- Average standardized residual
- **SRMR ≤ 0.08**: Acceptable
- **SRMR ≤ 0.06**: Good
- Sensitive to large residuals
- Complements RMSEA well

### 4.6 Summary: Fit Index Thresholds

| Index | Poor | Acceptable | Good | Excellent |
|-------|------|-----------|------|-----------|
| **χ²/df** | > 5.0 | ≤ 3.0 | ≤ 2.0 | ≤ 1.0 |
| **CFI** | < 0.80 | ≥ 0.90 | ≥ 0.95 | ≥ 0.97 |
| **TLI** | < 0.80 | ≥ 0.90 | ≥ 0.95 | ≥ 0.97 |
| **RMSEA** | > 0.10 | ≤ 0.08 | ≤ 0.06 | ≤ 0.05 |
| **SRMR** | > 0.10 | ≤ 0.08 | ≤ 0.06 | ≤ 0.05 |

**Reporting requirement**: Always report at least χ²/df, CFI, TLI, RMSEA (with 90% CI), and SRMR.

---

## 5. Convergent Validity

All three criteria should be met simultaneously:

### 5.1 Factor Loadings (λ)

Standardized factor loadings represent the correlation between each item and its factor:

| Loading | Interpretation |
|---------|---------------|
| ≥ 0.70 | Strong — clearly reflects the construct |
| 0.50–0.69 | Moderate — acceptable |
| < 0.50 | Weak — consider removing (especially if AVE is borderline) |

**Decision**: Items with standardized loading < 0.40 should generally be removed.

### 5.2 Average Variance Extracted (AVE)

```
         Σλi²
AVE = ──────────────────
      Σλi² + Σ(1 − λi²)
```

Where λi = standardized loading for item i, and Σ(1 − λi²) = sum of measurement error variances.

- **AVE ≥ 0.50**: Construct explains more variance in indicators than error — convergent validity supported
- **AVE < 0.50**: Construct explains less variance than error — review items

### 5.3 Composite Reliability (CR)

```
            (Σλi)²
CR = ──────────────────────
      (Σλi)² + Σ(1 − λi²)
```

- **CR ≥ 0.70**: Acceptable internal consistency
- **CR ≥ 0.80**: Good
- **Superior to Cronbach's α** because it accounts for actual factor loadings
- CR ≥ 0.60 may be acceptable for exploratory research

---

## 6. Discriminant Validity

### 6.1 Fornell-Larcker Criterion (Traditional)

```
For each pair of constructs:
√AVE(ξk) > r(ξk, ξm)

Where r(ξk, ξm) = correlation between constructs k and m
```

If √AVE > all correlations with other constructs: discriminant validity supported.

**Limitation**: This criterion has been criticized as too lenient; the HTMT method is now preferred.

### 6.2 HTMT (Heterotrait-Monotrait Ratio) — CURRENT BEST PRACTICE

The HTMT ratio is based on the average inter-construct correlations relative to within-construct correlations:

```
         Mean of hetero-trait correlations
HTMT = ─────────────────────────────────────────────
       √(Mean of correlations within construct k ×
         Mean of correlations within construct m)
```

**Thresholds**:
- **HTMT < 0.85**: Discriminant validity supported (Henseler et al., 2015)
- **HTMT < 0.90**: Lenient threshold (Clark & Watson, 1995)
- **HTMT ≥ 0.85**: Discriminant validity is questionable

**HTMT confidence interval**: If 1.0 is not included in the 95% CI: discriminant validity supported.

### 6.3 Comparing Nested Models (Chi-Square Difference Test)

Constrain the correlation between two constructs to 1.0; if χ² increases significantly, constructs are distinct.

---

## 7. Model Modification

When initial model fit is poor, modification indices (MI) suggest where freeing parameters would improve fit.

### 7.1 Modification Indices
- MI > 10 suggests that freeing that parameter would improve χ² by at least that amount
- Common modifications: **error covariances** between items with similar wording

### 7.2 Rules for Responsible Modification

1. **Theory must justify the modification** — do not blindly follow MIs
2. **Check Expected Parameter Change (EPC)** — large EPC may indicate a substantive issue
3. **Cross-validate**: If you modify the model, validate in a new sample or split sample
4. **Report all modifications** and their theoretical justification
5. **Limit to 3–4 modifications** maximum for a single model

### 7.3 Common Sources of Poor Fit
- Items measuring more than one construct (cross-loadings)
- Items with near-identical wording (correlated errors)
- Construct being too broad (split into two constructs)
- Theoretical misspecification

---

## 8. Measurement Invariance Testing

When **comparing groups** (e.g., male vs. female, Thai vs. foreign travelers), measurement invariance must be established first.

### 8.1 Levels of Measurement Invariance

**Step 1: Configural Invariance (Baseline)**
- Same factor structure (same items per factor) in both groups
- All loadings and intercepts freely estimated per group
- Tests if the basic structure holds in both groups

**Step 2: Metric Invariance**
- Same factor loadings across groups (Λ constrained equal)
- Δχ², ΔCFI ≤ 0.010 (Cheung & Rensvold, 2002): metric invariance holds
- If metric invariance: latent variable relationships can be compared

**Step 3: Scalar Invariance**
- Same intercepts AND loadings across groups
- ΔCFI ≤ 0.010: scalar invariance holds
- If scalar invariance: latent means can be compared

**Step 4: Strict Invariance**
- Same error variances across groups
- Rarely tested; rarely required for most research purposes

### 8.2 Decision Framework

```
Configural → Metric → Scalar → Strict

If metric fails: Partial metric invariance (free non-invariant loadings)
If scalar fails: Partial scalar invariance acceptable for some comparisons
```

---

## 9. Complete CFA Workflow

```
Step 1: Define factor structure from EFA or theory
        ↓
Step 2: Write model syntax (lavaan/AMOS)
        ↓
Step 3: Estimate model (ML or robust estimator)
        ↓
Step 4: Check model fit (χ²/df, CFI, TLI, RMSEA, SRMR)
        ↓
Step 5a: GOOD FIT → Proceed to validity assessment
Step 5b: POOR FIT → Examine modification indices
              → Check for cross-loadings, correlated errors
              → Modify (with theoretical justification)
              → Re-estimate
        ↓
Step 6: Convergent validity: loadings ≥ 0.50, AVE ≥ 0.50, CR ≥ 0.70
        ↓
Step 7: Discriminant validity: HTMT < 0.85
        ↓
Step 8: If groups compared → Measurement invariance testing
        ↓
Step 9: Report results (Table: loadings, CR, AVE; fit indices; HTMT)
        ↓
Step 10: Proceed to structural model (Module 04)
```

---

## 10. Reporting CFA Results: Publication Tables

### Table A: Measurement Model Results

| Construct | Item | Standardized Loading | t-value | CR | AVE | α |
|-----------|------|---------------------|---------|-----|-----|---|
| **Perceived Safety** (PS) | PS1 | 0.78 | 15.2*** | **0.872** | **0.578** | 0.856 |
| | PS2 | 0.74 | 14.1*** | | | |
| | PS3 | 0.76 | 14.6*** | | | |
| | PS4 | 0.72 | 13.7*** | | | |
| **Service Quality** (SQ) | SQ1 | 0.81 | 16.3*** | **0.861** | **0.608** | 0.823 |
| | SQ2 | 0.82 | 16.5*** | | | |
| | SQ3 | 0.74 | 14.2*** | | | |
| | SQ4 | 0.72 | 13.8*** | | | |

*Note*. CR = composite reliability; AVE = average variance extracted; α = Cronbach's alpha.
All loadings significant at ***p < .001. χ²/df = 2.31, CFI = .961, TLI = .954, RMSEA = .054 [.046, .062], SRMR = .049.

### Table B: Discriminant Validity — HTMT Matrix

| | PS | SQ | EA | BI |
|--|---|----|----|----|
| **PS** | — | | | |
| **SQ** | 0.52 | — | | |
| **EA** | 0.41 | 0.47 | — | |
| **BI** | 0.63 | 0.71 | 0.58 | — |

*Note*. Values are HTMT ratios. All values < 0.85, supporting discriminant validity.

### Table C: Fornell-Larcker Criterion (Alternative)

| | PS | SQ | EA | BI |
|--|---|----|----|----|
| **PS** | **0.760** | | | |
| **SQ** | 0.381 | **0.780** | | |
| **EA** | 0.312 | 0.358 | **0.754** | |
| **BI** | 0.421 | 0.518 | 0.407 | **0.763** |

*Note*. Diagonal = √AVE. Off-diagonal = inter-construct correlation. Discriminant validity: √AVE > all correlations in row/column.

---

## References

- Anderson, J. C., & Gerbing, D. W. (1988). Structural equation modeling in practice: A review and recommended two-step approach. *Psychological Bulletin*, 103(3), 411–423.
- Brown, T. A. (2015). *Confirmatory Factor Analysis for Applied Research* (2nd ed.). Guilford.
- Fornell, C., & Larcker, D. F. (1981). Evaluating structural equation models with unobservable variables and measurement error. *Journal of Marketing Research*, 18(1), 39–50.
- Hair, J. F., Black, W. C., Babin, B. J., & Anderson, R. E. (2019). *Multivariate Data Analysis* (8th ed.). Cengage.
- Henseler, J., Ringle, C. M., & Sarstedt, M. (2015). A new criterion for assessing discriminant validity in variance-based structural equation modeling. *Journal of the Academy of Marketing Science*, 43(1), 115–135.
- Hu, L., & Bentler, P. M. (1999). Cutoff criteria for fit indexes in covariance structure analysis. *Structural Equation Modeling*, 6(1), 1–55.
- Kline, R. B. (2023). *Principles and Practice of Structural Equation Modeling* (5th ed.). Guilford.
- Rosseel, Y. (2012). lavaan: An R package for structural equation modeling. *Journal of Statistical Software*, 48(2), 1–36.

---

*See also: [03_SPSS_AMOS_Guide.md](./03_SPSS_AMOS_Guide.md) | [03_R_lavaan_Script.R](./03_R_lavaan_Script.R) | [03_SmartPLS_Guide.md](./03_SmartPLS_Guide.md)*
