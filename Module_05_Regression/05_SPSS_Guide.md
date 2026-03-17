---
title: "05 · SPSS Guide"
parent: "05 · Regression Analysis"
nav_order: 2
---

# SPSS Guide — Regression Analysis
{: .no_toc }

**Module 05 · Regression Analysis**
{: .label .label-green }

## Table of Contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 1. Overview

This guide provides step-by-step instructions for running all major regression types in IBM SPSS Statistics (version 25+). All examples use the **BUTS dataset** and transportation research applications.

---

## 2. Preparing Your Data in SPSS

### 2.1 Loading the BUTS Dataset

1. `File → Open → Data` → select `BUTS_main.csv`
2. In the Text Import Wizard:
   - Delimited, First row has variable names: ✅
   - Delimiter: Comma
   - Click **Finish**

### 2.2 Variable Types

Verify variable types in the **Variable View** tab:

| Variable | Type | Measure |
|----------|------|---------|
| ps1–ps4 | Numeric | Scale |
| bi1–bi3 | Numeric | Scale |
| ab1–ab4 | Numeric | Scale |
| gender | Numeric | Nominal (0=Female, 1=Male) |
| age_group | Numeric | Ordinal |
| income | Numeric | Ordinal |
| mode_choice | Numeric | Nominal |
| crash_severity | Numeric | Ordinal |

### 2.3 Computing Composite Scores

Before regression, compute mean scores for each latent construct:

`Transform → Compute Variable`

| Target Variable | Numeric Expression |
|-----------------|-------------------|
| PS_mean | `MEAN(ps1, ps2, ps3, ps4)` |
| SQ_mean | `MEAN(sq1, sq2, sq3, sq4)` |
| EA_mean | `MEAN(ea1, ea2, ea3, ea4)` |
| BI_mean | `MEAN(bi1, bi2, bi3)` |
| AB_mean | `MEAN(ab1, ab2, ab3, ab4)` |

Click **OK** after each computation. New variables appear in the dataset.

---

## 3. Simple Linear Regression

**Research question**: Does Perceived Safety predict Behavioral Intention?

### Menu Path
`Analyze → Regression → Linear`

### Setup
1. **Dependent**: `BI_mean`
2. **Independent(s)**: `PS_mean`
3. Click **Statistics** → check:
   - ✅ Estimates
   - ✅ Confidence intervals (95%)
   - ✅ Model fit
   - ✅ R squared change
   - ✅ Descriptives
   - ✅ Collinearity diagnostics
4. Click **Plots** → check:
   - ✅ Normal probability plot (PNORM)
   - ✅ Histogram of residuals
   - Move `*ZRESID` to Y-axis, `*ZPRED` to X-axis (scatterplot)
5. Click **OK**

### Key Output to Report

**Model Summary**
```
R     R²     Adj R²    Std. Error
.623  .388    .387      .512
```

**ANOVA**
```
         SS        df    MS        F        p
Regr.    72.41     1     72.41   275.8   .000
Resid.   114.4     448   0.255
Total    186.8     449
```

**Coefficients**
```
              B      Std.E   Beta    t      p     95% CI
(Constant)   .892    .182           4.90  .000  [.534, 1.250]
PS_mean      .668    .040    .623   16.61  .000  [.589, .747]
```

**Interpretation**:
> "For every 1-unit increase in Perceived Safety, Behavioral Intention increases by 0.668 units (β = .623, t = 16.61, p < .001). Perceived Safety explains 38.8% of the variance in Behavioral Intention (R² = .388)."

---

## 4. Multiple Linear Regression

**Research question**: Do PS, SQ, and EA together predict BI?

### Menu Path
`Analyze → Regression → Linear`

### Setup (Enter Method)
1. **Dependent**: `BI_mean`
2. **Independent(s)**: `PS_mean`, `SQ_mean`, `EA_mean`
3. **Method**: Enter (simultaneous)
4. Same diagnostics as simple regression

### Hierarchical Regression (Block Entry)

To test incremental prediction:

1. **Block 1**: `PS_mean` → click **Next**
2. **Block 2**: `SQ_mean`, `EA_mean`
3. Click **Statistics** → ✅ R squared change

**R² Change Table**:
```
Model  R²      Adj R²   R² Change   F Change   df1  df2   p
1      .388    .387      .388        275.8      1    448  .000
2      .432    .430      .044         17.3      2    446  .000
```

> "Adding SQ and EA to the model containing PS resulted in a significant increase in R² (ΔR² = .044, ΔF(2, 446) = 17.3, p < .001)."

### Assumption Checks

After running regression, check:

**1. Multicollinearity (Tolerance and VIF)**
```
Variable    Tolerance    VIF
PS_mean     .647         1.545
SQ_mean     .603         1.658
EA_mean     .671         1.490
```
VIF < 5 → no multicollinearity ✓

**2. Normality of Residuals**
Check the histogram and normal P-P plot: residuals should approximate a bell curve / straight diagonal line.

**3. Homoscedasticity**
In the residual scatterplot (ZPRED vs ZRESID): points should be randomly scattered around zero, with no fan shape.

**4. Influential Cases (Casewise Diagnostics)**
Click **Save** → check ✅ Standardized residuals (Mahalanobis distance, Cook's D)

Cases with |standardized residual| > 3.0 may be outliers.

---

## 5. Binary Logistic Regression

**Research question**: What factors predict transit use choice (car vs. transit)?

The `mode_choice` variable: 0 = private car, 1 = public transit

### Menu Path
`Analyze → Regression → Binary Logistic`

### Setup
1. **Dependent**: `mode_choice` (binary: 0/1)
2. **Covariates**: `PS_mean`, `SQ_mean`, `EA_mean`, `income`, `age_group`
3. **Method**: Enter
4. Click **Categorical** → move `income` and `age_group` to Categorical Covariates (reference category: Last)
5. Click **Options** → check:
   - ✅ Classification plots
   - ✅ Hosmer-Lemeshow goodness of fit
   - ✅ Casewise listing of residuals (outliers outside 2 SD)
   - ✅ CI for exp(B): 95%
   - ✅ Iteration history
6. Click **OK**

### Key Output

**Omnibus Tests of Model Coefficients**
```
        χ²       df    p
Step    89.4     7     .000
Block   89.4     7     .000
Model   89.4     7     .000
```
Significant χ² → model better than null ✓

**Hosmer and Lemeshow Test**
```
χ² = 6.842    df = 8    p = .554
```
Non-significant (p > .05) → good model fit ✓

**Model Summary**
```
-2 Log likelihood   Cox & Snell R²   Nagelkerke R²
  521.3              .181             .241
```

**Variables in the Equation**
```
                B       SE     Wald    df    p      Exp(B)   95% CI
PS_mean       .784    .142    30.47   1    .000    2.190   [1.660, 2.890]
SQ_mean       .632    .135    21.89   1    .000    1.882   [1.446, 2.450]
EA_mean       .418    .128    10.65   1    .001    1.519   [1.185, 1.947]
income(1)     .391    .189     4.27   1    .039    1.478   [1.021, 2.139]
income(2)     .742    .201    13.62   1    .000    2.100   [1.416, 3.113]
age_group(1) -.284    .211     1.81   1    .179     .753   [.498, 1.138]
Constant    -3.842    .512    56.24   1    .000     .021
```

**Interpretation of Exp(B) = Odds Ratio**:
> "For each 1-unit increase in Perceived Safety, the odds of choosing public transit increase by a factor of 2.190 (OR = 2.190, 95% CI [1.660, 2.890], p < .001), holding all other variables constant."

**Classification Table**
```
                   Predicted
Observed        Car    Transit    % Correct
Car             212     44          82.8%
Transit          31    163          84.0%
Overall Correct                     83.3%
```

---

## 6. Multinomial Logistic Regression

**Research question**: What factors predict mode choice (car vs. motorcycle vs. transit vs. walk)?

`mode_choice`: 0=car, 1=motorcycle, 2=transit, 3=walk

### Menu Path
`Analyze → Regression → Multinomial Logistic`

### Setup
1. **Dependent**: `mode_choice`
2. **Factors** (categorical): `gender`, `income`, `age_group`
3. **Covariates** (continuous): `PS_mean`, `SQ_mean`, `EA_mean`
4. **Reference Category**: First (or specify Custom = car = 0)
5. Click **Statistics** → check:
   - ✅ Case processing summary
   - ✅ Pseudo R²
   - ✅ Step summary
   - ✅ Model fitting information
   - ✅ Likelihood ratio tests
   - ✅ Parameter estimates (with CI)
   - ✅ Classification table
6. Click **OK**

### Key Output

**Model Fitting Information**
```
Model      -2 Log Likelihood    χ²       df    p
Intercept   862.4
Final       724.8              137.6    21    .000
```

**Pseudo R-Square**
```
Cox and Snell   .262
Nagelkerke      .280
McFadden        .160
```

**Likelihood Ratio Tests** (tests each predictor's contribution)
```
Effect      χ²      df    p
Intercept   —       —     —
PS_mean     48.7    3     .000
SQ_mean     31.2    3     .000
EA_mean     22.4    3     .000
gender       8.9    3     .031
income      15.8    6     .015
age_group   12.4    6     .053
```

**Parameter Estimates** (compared to reference category = car):

The output shows separate sets of coefficients for:
- Motorcycle vs. Car (reference)
- Transit vs. Car
- Walk vs. Car

Look for B (unstandardized coefficient) and Exp(B) (risk ratio) in each comparison.

---

## 7. Ordinal Logistic Regression

**Research question**: What factors predict crash severity (minor/moderate/severe/fatal)?

### Menu Path
`Analyze → Regression → Ordinal`

### Setup
1. **Dependent**: `crash_severity` (1=minor, 2=moderate, 3=severe, 4=fatal)
2. **Factors**: `age_group`, `gender`, `seatbelt_use`, `road_type`
3. **Covariates**: `speed_z`, `alcohol_z` (standardized continuous variables)
4. Click **Output** → check:
   - ✅ Estimates
   - ✅ Goodness-of-Fit
   - ✅ Test of Parallel Lines
5. Click **Location** — ensure all covariates are in the Location box
6. Click **OK**

### Key Output

**Model Fitting Information**
```
Model      -2 Log Likelihood    χ²       df    p
Intercept   648.2
Final       561.4              86.8     8     .000
```

**Goodness-of-Fit**
```
           χ²      df    p
Pearson    428.6   427   .465
Deviance   421.3   427   .555
```
Non-significant → good fit ✓

**Test of Parallel Lines** (Proportional Odds Assumption)
```
Model            -2 Log Likelihood    χ²      df    p
Null (equal)      561.4
General (unequal) 548.7              12.7    16   .695
```
Non-significant (p = .695) → proportional odds assumption met ✓

**Parameter Estimates**
```
                  Estimate   SE      Wald    df    p      95% CI
Threshold  [Sev=1]  -2.841   .312   82.9    1    .000
           [Sev=2]  -0.824   .273    9.1    1    .003
           [Sev=3]   1.643   .289   32.3    1    .000
speed_z              0.782   .094   69.2    1    .000   [.598, .966]
alcohol_z            0.641   .101   40.3    1    .000   [.443, .839]
age_group(1)        -0.284   .198    2.1    1    .149
age_group(2)        -0.612   .201    9.3    1    .002
```

**Interpretation of Ordinal Regression Coefficients**:
> "Higher speed (β = 0.782, p < .001) is associated with increased odds of higher crash severity. For each 1 SD increase in speed, the log-odds of being in a higher crash severity category increase by 0.782."

**Converting to Odds Ratio**: exp(0.782) = 2.186
> "Each 1 SD increase in speed more than doubles the odds of being in a higher crash severity category (OR = 2.19, 95% CI [1.82, 2.63])."

---

## 8. Poisson and Negative Binomial Regression

**Research question**: What factors predict the number of road accidents per intersection per year?

### Menu Path
`Analyze → Generalized Linear Models → Generalized Linear Models`

### Setup for Poisson Regression
1. **Type of Model tab** → select **Poisson loglinear**
2. **Response tab** → Dependent: `crash_count`
3. **Predictors tab**:
   - Factors: `road_type`, `signal_control`
   - Covariates: `traffic_volume`, `speed_limit`
4. **Model tab** → add main effects
5. **Statistics tab** → check:
   - ✅ Parameter estimates
   - ✅ Confidence intervals (95%)
   - ✅ Goodness of fit statistics
6. **EM Means tab** → add road_type for marginal means
7. Click **OK**

### Checking for Overdispersion

After Poisson, check the **Goodness of Fit** table:
```
                Value    df    Value/df
Deviance        587.4   445     1.320
Pearson Chi²    601.2   445     1.351
```

If **Pearson χ²/df > 1.5**, data may be overdispersed → use **Negative Binomial**.

### Setup for Negative Binomial Regression

Repeat steps above but select: **Type of Model → Negative binomial with log link**

Negative Binomial adds a dispersion parameter to handle overdispersion:
```
(Negative binomial) Dispersion parameter k = 2.41
```

A significant k indicates overdispersion; the negative binomial model is more appropriate.

### Incidence Rate Ratios (IRR)

Exponentiate the coefficients (exp(B)) to get IRRs:

```
                B        SE     Wald    p      exp(B) = IRR
(Intercept)   1.842    .214             .000
traffic_vol   0.412    .058   50.5     .000   1.510
speed_limit   0.284    .071   16.0     .000   1.329
road_type=2   0.631    .142   19.7     .000   1.879
```

**Interpretation**:
> "Road segments with higher speed limits show 32.9% more crashes per year (IRR = 1.329, p < .001), holding traffic volume and road type constant."

---

## 9. Saving Regression Diagnostics

For any regression, go to the `Save` button in the dialog and check:

| Diagnostic | Use |
|-----------|-----|
| Predicted values (Unstandardized) | Residual analysis |
| Residuals (Studentized) | Outlier detection |
| Mahalanobis distance | Multivariate outliers |
| Cook's distance | Influential cases |
| Leverage values (hat matrix) | High-leverage points |

Criterion: Cook's D > 1.0 = potentially influential; leverage > 2(k+1)/n = high leverage.

---

## 10. Quick Reference — SPSS Regression Menu Paths

| Regression Type | SPSS Path |
|----------------|----------|
| Simple / Multiple Linear | `Analyze → Regression → Linear` |
| Binary Logistic | `Analyze → Regression → Binary Logistic` |
| Multinomial Logistic | `Analyze → Regression → Multinomial Logistic` |
| Ordinal (Proportional Odds) | `Analyze → Regression → Ordinal` |
| Poisson / Negative Binomial | `Analyze → Generalized Linear Models → Generalized Linear Models` |
| Curve Estimation | `Analyze → Regression → Curve Estimation` |
| 2SLS / Instrumental Variables | `Analyze → Regression → 2-Stage Least Squares` |

---

## 11. Reporting Checklist

Before submitting your regression results:

**Linear Regression**
- [ ] Report R, R², adjusted R², F-test with df and p
- [ ] Report standardized (β) and unstandardized (B) coefficients
- [ ] Report 95% confidence intervals for B
- [ ] Report VIF/Tolerance for all predictors
- [ ] Check and report assumption violations

**Logistic Regression**
- [ ] Report Nagelkerke R² (and Cox & Snell R²)
- [ ] Report Hosmer-Lemeshow test result
- [ ] Report Exp(B) = odds ratios with 95% CI
- [ ] Report overall classification accuracy
- [ ] Report omnibus model chi-square

**Ordinal Regression**
- [ ] Report test of parallel lines
- [ ] Report goodness-of-fit statistics
- [ ] Report threshold and location parameters
- [ ] Interpret direction of effect correctly

---

*[← Back to Module 05 Overview](./README.md)*
