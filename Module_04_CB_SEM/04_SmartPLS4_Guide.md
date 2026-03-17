---
title: "04 · SmartPLS 4 Guide"
parent: "04 · Covariance-Based SEM"
nav_order: 4
---

# SmartPLS 4.0 Guide — PLS-SEM
{: .no_toc }

**Module 04 · Covariance-Based SEM**
{: .label .label-purple }

## Table of Contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 1. PLS-SEM vs. CB-SEM — Choosing the Right Approach

SmartPLS 4.0 implements **Partial Least Squares SEM (PLS-SEM)**, which is fundamentally different from covariance-based SEM (AMOS, lavaan). Understanding the difference is critical for choosing the right method.

| Criterion | CB-SEM (AMOS/lavaan) | PLS-SEM (SmartPLS) |
|-----------|---------------------|-------------------|
| **Objective** | Theory confirmation | Prediction & exploration |
| **Estimation** | Maximum Likelihood | Iterative least squares |
| **Sample size** | N ≥ 200 recommended | Works with N ≥ 30 |
| **Distributional assumptions** | Multivariate normality | Distribution-free |
| **Construct type** | Reflective (primarily) | Reflective AND formative |
| **Model complexity** | Moderate | Handles complex models |
| **Fit indices** | Global fit (CFI, RMSEA) | No traditional fit indices |
| **Theory testing** | Strong | Moderate |
| **Prediction** | Weak | Strong |
| **Common in** | Psychology, management, transport | Marketing, IS, innovation |

{: .important }
> **Rule of thumb:** Use CB-SEM when your primary goal is theory testing and model fit assessment. Use PLS-SEM when your constructs are formative, sample is small (< 200), or prediction is the primary goal.

---

## 2. Installing and Launching SmartPLS 4.0

### Download
Go to [www.smartpls.com](https://www.smartpls.com) → Download SmartPLS 4.0 → Install

SmartPLS 4.0 is available as:
- **Free student version**: limited to 100 observations and 12 constructs
- **Professional license**: full features

### First Launch
1. Open SmartPLS 4.0
2. Create a new project: **File → New Project** → name it `BUTS_PLS_SEM`
3. The SmartPLS interface has three panels:
   - **Left**: Project explorer (models, data)
   - **Center**: Path model canvas
   - **Right**: Results/output

---

## 3. Importing Your Data

1. In the Project Explorer → right-click **Data** → **Import Data File**
2. Browse to `BUTS_main.csv`
3. SmartPLS will preview the data — verify column headers match variable names
4. Set **Missing Value Indicator** = `NA` or blank
5. Click **Finish**

SmartPLS automatically handles:
- Scale detection (numeric variables)
- Missing values (mean replacement by default — or use listwise deletion)

{: .note }
> Use `BUTS_main.csv` directly. SmartPLS reads CSV files. Ensure headers are on row 1.

---

## 4. Building the Path Model

### 4.1 Create a New Path Model

Right-click on **Models** in Project Explorer → **Add Path Model** → name it `BUTS_Reflective_Model`

### 4.2 Add Latent Variables (Constructs)

Double-click on the canvas to add a latent variable circle. Add five constructs:
- `PerceivedSafety`
- `ServiceQuality`
- `EnvAttitude`
- `BehavioralIntention`
- `ActualBehavior`

**Rename**: Double-click a construct circle → type the name

### 4.3 Assign Indicators to Constructs

1. Click on a construct circle to select it
2. Click the **Assign Indicators** button (or right-click → Assign Indicators)
3. From the variable list, select the relevant items:

| Construct | Indicators |
|-----------|-----------|
| PerceivedSafety | ps1, ps2, ps3, ps4 |
| ServiceQuality | sq1, sq2, sq3, sq4 |
| EnvAttitude | ea1, ea2, ea3, ea4 |
| BehavioralIntention | bi1, bi2, bi3 |
| ActualBehavior | ab1, ab2, ab3, ab4 |

4. Click **OK** after each assignment

Indicators appear as small squares connected to the construct circle by lines (outer model).

### 4.4 Set Construct Type (Reflective vs. Formative)

Right-click each construct → **Properties**:
- Mode A = **Reflective** (for all BUTS constructs — they're Likert scales)
- Mode B = **Formative** (for composite/index constructs)

{: .important }
> Reflective constructs assume that the latent variable **causes** the indicators. Formative constructs assume that the indicators **cause/define** the construct. All BUTS constructs are reflective.

### 4.5 Draw Structural Paths

Click on a construct → drag to another construct to draw a structural path (single-headed arrow):
- PerceivedSafety → BehavioralIntention
- ServiceQuality → BehavioralIntention
- EnvAttitude → BehavioralIntention
- BehavioralIntention → ActualBehavior
- PerceivedSafety → ActualBehavior (direct effect)

---

## 5. Running PLS-SEM Algorithm

### 5.1 Configure the Algorithm

Menu: **Calculate → PLS-SEM Algorithm** (or click the play button)

Settings:
- **Weighting scheme**: Path weighting (recommended for predictive models)
- **Maximum iterations**: 300
- **Stop criterion**: 10⁻⁷
- **Initial weights**: +1

Click **Start Calculation**.

### 5.2 Reviewing the Model Results

After calculation, SmartPLS displays results directly on the path diagram:
- **Numbers on paths** = path coefficients (β)
- **Numbers inside constructs** = R² values
- **Numbers on outer model arrows** = outer loadings (λ)

---

## 6. Assessing the Measurement Model (Reflective)

Before interpreting structural paths, always assess the outer (measurement) model first.

### 6.1 Indicator Reliability (Outer Loadings)

Navigate to: **PLS-SEM Algorithm Results → Outer Loadings**

**Criterion**: All outer loadings > **0.70** (minimum 0.40 for exploratory work)

```
Construct           Item    Outer Loading
PerceivedSafety     ps1     0.762
                    ps2     0.791
                    ps3     0.825
                    ps4     0.778
ServiceQuality      sq1     0.741
                    ...
```

Remove items with loadings below 0.40 (after checking effect on AVE and CR).

### 6.2 Internal Consistency Reliability

Navigate to: **PLS-SEM Algorithm Results → Reliability**

| Measure | Criterion | Your Value |
|---------|-----------|-----------|
| Cronbach's α | > 0.70 | ≥ 0.75 ✓ |
| Composite Reliability (CR) | > 0.70 | ≥ 0.80 ✓ |
| rho_A | > 0.70 | ≥ 0.78 ✓ |

{: .note }
> SmartPLS 4.0 reports three reliability measures: Cronbach's α, CR (also called Dijkstra-Henseler's ρ_C), and rho_A. Report all three.

### 6.3 Convergent Validity (AVE)

Navigate to: **PLS-SEM Algorithm Results → Convergent Validity**

**Criterion**: AVE > **0.50** for all constructs

```
Construct               AVE
PerceivedSafety         0.613
ServiceQuality          0.581
EnvAttitude             0.594
BehavioralIntention     0.628
ActualBehavior          0.601
```

All AVE > 0.50 → convergent validity confirmed ✓

### 6.4 Discriminant Validity

SmartPLS 4.0 provides **three methods** for discriminant validity:

#### a) Fornell-Larcker Criterion
Navigate to: **Discriminant Validity → Fornell-Larcker Criterion**

The diagonal (√AVE) should exceed off-diagonal (correlations):
```
                PS     SQ     EA     BI     AB
PS           [0.783]
SQ            0.612  [0.762]
EA            0.534   0.578  [0.771]
BI            0.681   0.647   0.612  [0.792]
AB            0.623   0.571   0.548   0.701  [0.775]
```

#### b) Cross-Loadings
Navigate to: **Discriminant Validity → Cross Loadings**

Each indicator should load highest on its own construct.

#### c) HTMT (Recommended)
Navigate to: **Discriminant Validity → HTMT**

**Criterion**: HTMT < **0.90** (or < 0.85 for conceptually similar constructs)

```
              PS     SQ     EA     BI
SQ           0.742
EA           0.664  0.703
BI           0.812  0.792  0.748
AB           0.753  0.698  0.662  0.836
```

All HTMT < 0.90 → discriminant validity confirmed ✓

{: .important }
> Hair et al. (2022) recommend using **HTMT** as the primary discriminant validity criterion in PLS-SEM. The Fornell-Larcker criterion is less sensitive to poor discriminant validity.

---

## 7. Assessing the Structural Model

Once measurement model quality is confirmed, evaluate the structural (inner) model.

### 7.1 Check for Collinearity (VIF)

Navigate to: **PLS-SEM Algorithm Results → Inner VIF Values**

**Criterion**: VIF < **5.0** (conservative: < 3.3)

```
Predictor            VIF
PS → BI             1.842
SQ → BI             1.774
EA → BI             1.698
BI → AB             1.524
PS → AB             1.842
```

All VIF < 3.3 → no collinearity issues ✓

### 7.2 R² — Coefficient of Determination

Navigate to: **PLS-SEM Algorithm Results → R² and Adjusted R²**

```
Construct           R²      Adjusted R²    Interpretation
BehavioralIntention .421    .417           Moderate
ActualBehavior      .362    .358           Moderate
```

| R² Level | Threshold (Hair et al.) |
|----------|------------------------|
| Substantial | ≥ 0.75 |
| Moderate | ≥ 0.50 |
| Weak | ≥ 0.25 |

### 7.3 Effect Size f²

Measures each predictor's contribution to R²:

```
Path                f²      Interpretation
PS → BI            0.112    Small-Medium
SQ → BI            0.097    Small
EA → BI            0.082    Small
BI → AB            0.248    Medium
PS → AB            0.051    Small
```

| f² | Effect Size |
|----|------------|
| 0.02 | Small |
| 0.15 | Medium |
| 0.35 | Large |

### 7.4 Predictive Relevance Q² (Blindfolding)

Navigate to: **Calculate → Blindfolding**
- Omission distance D = 7 (default)
- Click **Start Calculation**

Navigate to: **Construct Crossvalidated Redundancy**

**Criterion**: Q² > **0** indicates predictive relevance

```
Construct           Q²
BehavioralIntention .241
ActualBehavior      .197
```

Both Q² > 0 → model has predictive relevance ✓

---

## 8. Bootstrapping for Significance Testing

PLS-SEM is a non-parametric method, so significance testing uses bootstrapping (not t-tables).

### 8.1 Configure Bootstrapping

Menu: **Calculate → Bootstrapping**

Settings:
- **Subsamples**: 5000 (minimum 2000)
- **Significance level**: 0.05 (two-tailed)
- **Confidence interval method**: BCa (Bias-Corrected and Accelerated) — recommended

Click **Start Calculation**.

### 8.2 Structural Path Results

Navigate to: **Bootstrapping Results → Path Coefficients**

```
Path          Original β   Mean β   SD      t-stat   p-value   2.5%    97.5%   Decision
PS → BI         0.318      0.319   0.049    6.490    0.000    0.224    0.413    Supported
SQ → BI         0.291      0.292   0.052    5.596    0.000    0.190    0.394    Supported
EA → BI         0.248      0.249   0.050    4.960    0.000    0.152    0.347    Supported
BI → AB         0.503      0.505   0.043   11.698    0.000    0.419    0.587    Supported
PS → AB         0.182      0.183   0.053    3.434    0.001    0.077    0.284    Supported
```

---

## 9. Mediation Analysis in SmartPLS 4.0

### 9.1 Specific Indirect Effects

Navigate to: **Bootstrapping Results → Specific Indirect Effects**

```
Path               Indirect β   SD      t-stat   p-value   95% BCa CI
PS → BI → AB         0.160      0.029    5.517    0.000    [0.103, 0.218]
SQ → BI → AB         0.146      0.028    5.214    0.000    [0.092, 0.203]
EA → BI → AB         0.125      0.026    4.808    0.000    [0.074, 0.177]
```

### 9.2 Total Effects

Navigate to: **Bootstrapping Results → Total Effects**

```
Path               Total β   p-value
PS → AB             0.342    0.000    (direct .182 + indirect .160)
SQ → AB             0.146    0.000
EA → AB             0.125    0.000
```

### 9.3 Determining Mediation Type

For PS → BI → AB:
- Direct effect (PS→AB): β = .182, p < .001 → **significant**
- Indirect effect (via BI): β = .160, p < .001 → **significant**
- → **Partial mediation** (both paths significant)

For SQ → BI → AB:
- Direct effect of SQ→AB: not in model (no direct path)
- Indirect effect: β = .146, p < .001 → **significant**
- → **Full mediation** (no direct path, indirect significant)

---

## 10. Model Fit in PLS-SEM

Unlike CB-SEM, PLS-SEM traditionally lacked global fit indices. SmartPLS 4.0 now provides:

Navigate to: **PLS-SEM Algorithm Results → Model Fit**

| Index | Value | Criterion | Status |
|-------|-------|-----------|--------|
| SRMR | 0.058 | < 0.08 | ✓ Acceptable |
| d_ULS | 1.842 | — | — |
| d_G | 0.621 | — | — |
| NFI | 0.921 | > 0.90 | ✓ Acceptable |
| Chi² | — | — | — |

{: .note }
> SRMR is the primary fit index in PLS-SEM. Values < 0.08 indicate acceptable fit; < 0.05 is good fit.

---

## 11. PLSpredict — Predictive Power Assessment

SmartPLS 4.0 includes PLSpredict for out-of-sample prediction:

Menu: **Calculate → PLSpredict**
- k-fold cross-validation: 10 folds (default)
- Repetitions: 10

Navigate to: **PLSpredict Results → Construct Level**

Compare PLS model RMSE vs. naïve benchmark (linear model LM):
- If **PLS RMSE < LM RMSE** for most indicators → model has predictive power

---

## 12. Saving and Reporting

### Save Project
`File → Save` (saves as `.splsm` project file)

{: .note }
> The `.splsm` project file is automatically excluded from git tracking (see `.gitignore`).

### Copy Path Diagram
Right-click on canvas → **Copy to Clipboard** → paste into Word

### Export Results to Excel
Most result tables can be exported: right-click on result table → **Export to Excel/CSV**

---

## 13. Reporting PLS-SEM Results (APA Style)

### Measurement Model Table

> **Table X.** Measurement Model Results

| Construct | Item | Loading | α | CR | AVE |
|-----------|------|---------|---|-----|-----|
| Perceived Safety (PS) | ps1 | .762 | .821 | .869 | .613 |
| | ps2 | .791 | | | |
| | ps3 | .825 | | | |
| | ps4 | .778 | | | |

### Structural Model Results

> "PLS-SEM was conducted using SmartPLS 4.0 (Ringle et al., 2024). The measurement model demonstrated adequate reliability (all CR > .80, α > .75) and validity (all AVE > .50, HTMT < .90). Bootstrapping with 5,000 subsamples was used to assess path significance. The structural model explained 42.1% of variance in Behavioral Intention (R² = .421) and 36.2% in Actual Behavior (R² = .362). All five hypothesized paths were supported (p < .001)."

---

## 14. Key References

- Hair, J. F., Risher, J. J., Sarstedt, M., & Ringle, C. M. (2019). When to use and how to report results of PLS-SEM. *European Business Review*, 31(1), 2–24.
- Hair, J. F., Henseler, J., Dijkstra, T. K., & Sarstedt, M. (2014). Common beliefs and reality about partial least squares. *Organizational Research Methods*, 17(2), 182–209.
- Henseler, J., Ringle, C. M., & Sarstedt, M. (2015). A new criterion for assessing discriminant validity in variance-based structural equation modeling. *Journal of the Academy of Marketing Science*, 43(1), 115–135.
- Ringle, C. M., Wende, S., & Becker, J.-M. (2024). SmartPLS 4. *SmartPLS GmbH*. [www.smartpls.com](https://www.smartpls.com)

---

*[← Back to Module 04 Overview](./README.md)*
