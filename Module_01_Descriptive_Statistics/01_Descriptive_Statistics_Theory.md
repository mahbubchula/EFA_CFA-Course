---
title: "Theory"
parent: "01 · Descriptive Statistics"
nav_order: 1
---

# 01 — Descriptive Statistics & Data Preparation: Theory & Practice

> **Module 01 | Descriptive Statistics**
> *Course: Advanced Statistical Methods for Transportation & Behavioral Research*
> *Instructor: Mahbub Hassan, Chulalongkorn University*

---

## 1. Why Descriptive Statistics Matter

Descriptive statistics are not just a "preliminary step" — they are critical for:
1. **Understanding your data** before any modeling
2. **Detecting data quality problems** (outliers, impossible values, missing data)
3. **Checking assumptions** required by advanced methods
4. **Providing context** for readers in publications
5. **Informing methodological decisions** (e.g., whether to use parametric or nonparametric tests)

In transportation research, a poorly prepared dataset leads to misleading models. Reviewers and editors increasingly check descriptive statistics carefully.

---

## 2. Measures of Central Tendency

### 2.1 Mean (Arithmetic Average)
```
X̄ = (Σxi) / n
```
- Most commonly reported
- **Sensitive to outliers**
- Appropriate for interval/ratio data with normal distribution

### 2.2 Median
- Middle value when data is sorted
- **Robust to outliers**
- Preferred for skewed distributions (e.g., income, travel time)

### 2.3 Mode
- Most frequently occurring value
- Useful for nominal/categorical data and Likert scales
- A distribution can be unimodal, bimodal, or multimodal

### 2.4 Comparison Example
Suppose daily travel time (minutes) for 7 respondents:
```
Data: 15, 20, 22, 25, 30, 35, 120

Mean   = (15+20+22+25+30+35+120)/7 = 267/7 = 38.1 min  ← Distorted by outlier
Median = 25 min                                          ← More representative
```

**Practical guideline**: Always report both mean and median for continuous variables. If they differ substantially, the distribution is skewed.

---

## 3. Measures of Dispersion

### 3.1 Standard Deviation (SD) and Variance

```
Variance = S² = Σ(xi - X̄)² / (n - 1)
SD = S = √[Σ(xi - X̄)² / (n - 1)]
```

- **SD** is in the same units as the original variable
- **Coefficient of Variation** = (SD / Mean) × 100 → relative variability

### 3.2 Range
```
Range = Maximum - Minimum
```
Simple but sensitive to extreme values.

### 3.3 Interquartile Range (IQR)
```
IQR = Q3 - Q1
```
Robust measure; forms the basis of box plots.

### 3.4 Standard Error of the Mean (SEM)
```
SEM = SD / √n
```
Indicates precision of the mean estimate — reported in tables when comparing groups.

---

## 4. Shape of Distribution

### 4.1 Skewness
Measures asymmetry:
```
Skewness > 0: Right/positive skew (long tail on right, e.g., income, travel distance)
Skewness < 0: Left/negative skew (long tail on left)
Skewness = 0: Symmetric (normal)
```

**Thresholds for normality assumption:**
- |Skewness| < 2 is generally acceptable for SEM/regression
- |Skewness| < 1 is ideal
- George & Mallery (2010): |Skewness| ≤ 2 and |Kurtosis| ≤ 7 acceptable

### 4.2 Kurtosis
Measures tail heaviness:
```
Excess Kurtosis = 0:     Normal (mesokurtic)
Excess Kurtosis > 0:     Leptokurtic (heavy tails, peaked) — common in Likert data
Excess Kurtosis < 0:     Platykurtic (light tails, flat)
```

**Reporting**: Always report skewness and kurtosis (excess kurtosis) for all survey items.

---

## 5. Normality Assessment

### 5.1 Why It Matters
Many parametric methods (regression, ANOVA, ML estimation in SEM) assume **multivariate normality**. For Likert scale items with sufficient sample size (n ≥ 200), mild non-normality is generally tolerable.

### 5.2 Visual Methods (Always use first!)

**Histogram**: Plot frequency distribution against a normal curve overlay
**Q-Q Plot (Quantile-Quantile)**: Points should fall on diagonal line if normal
**Box Plot**: Identify outliers and skew visually

### 5.3 Statistical Tests

| Test | Best for | Notes |
|------|---------|-------|
| **Shapiro-Wilk** | n < 50 | Most powerful for small samples |
| **Kolmogorov-Smirnov (K-S)** | n ≥ 50 | Lilliefors correction recommended |
| **Anderson-Darling** | General | More sensitive in tails |

**⚠️ Caution**: With large samples (n ≥ 300), even tiny deviations from normality yield significant K-S/S-W results. Always combine with visual inspection and skewness/kurtosis examination.

**Practical recommendation for SEM/factor analysis:**
- Examine skewness and kurtosis
- Use Mardia's multivariate kurtosis test (in R or AMOS)
- If non-normal: use Satorra-Bentler robust ML or use bootstrapping

---

## 6. Missing Value Analysis

### 6.1 Types of Missing Data

| Type | Mechanism | Example | Remedy |
|------|-----------|---------|--------|
| **MCAR** (Missing Completely At Random) | No pattern | Random skip | Listwise deletion is unbiased |
| **MAR** (Missing At Random) | Missingness depends on other observed variables | Older respondents skip income | Multiple imputation |
| **MNAR** (Missing Not At Random) | Missingness depends on unobserved values | High earners skip income | Difficult; sensitivity analysis |

### 6.2 How Much Missing Data is Acceptable?

| Percentage Missing | Recommendation |
|-------------------|---------------|
| < 5% per item | Usually safe to ignore (listwise or mean substitution) |
| 5–10% | Use multiple imputation |
| > 10% | Investigate cause; consider item removal |

### 6.3 Missing Data Techniques

**Listwise Deletion**: Remove cases with any missing values
- Simple, unbiased under MCAR
- Can reduce sample size substantially

**Mean/Median Substitution**: Replace missing with mean or median
- Simple but reduces variance; not recommended for > 5% missing

**Multiple Imputation (MI)**: Best practice
- Creates multiple complete datasets
- Analyzes each, then pools results
- Available in SPSS (Multiple Imputation procedure) and R (`mice` package)

**SPSS**: `Analyze → Multiple Imputation → Impute Missing Data Values`
**R**: `library(mice); imp <- mice(data, m=5, method="pmm")`

---

## 7. Outlier Detection

### 7.1 Univariate Outliers
Using z-scores: |z| > 3.0 flagged as potential outlier
Using IQR rule: values < Q1 − 1.5×IQR or > Q3 + 1.5×IQR

### 7.2 Multivariate Outliers: Mahalanobis Distance

**Mahalanobis distance (D²)** measures how far a case is from the multivariate centroid.

```
D² = (x - μ)ᵀ Σ⁻¹ (x - μ)
```

**Decision rule**: Compare D² to chi-square distribution with df = number of variables.
Cases with p < 0.001 (on chi-square) are potential multivariate outliers.

**In SPSS**: Regression → Save → Mahalanobis distance
**In R**: `mahalanobis(data, colMeans(data), cov(data))`

**Important**: Outliers in transportation research often represent meaningful extreme behavior (e.g., very high car users, extreme commuters). Investigate before removing.

---

## 8. Sample Characteristics Table

Every publication should begin with a demographic/sample description table.

**Example Table 1: Sample Characteristics (n = 450)**

| Variable | Category | Frequency | Percentage |
|----------|----------|-----------|-----------|
| **Gender** | Male | 265 | 58.9% |
| | Female | 185 | 41.1% |
| **Age** | 18–25 | 95 | 21.1% |
| | 26–35 | 178 | 39.6% |
| | 36–45 | 112 | 24.9% |
| | 46–55 | 45 | 10.0% |
| | 56+ | 20 | 4.4% |
| **Primary Mode** | Car | 180 | 40.0% |
| | Motorcycle | 95 | 21.1% |
| | Public Transit | 130 | 28.9% |
| | Walking/Cycling | 45 | 10.0% |
| **Monthly Income (THB)** | < 15,000 | 85 | 18.9% |
| | 15,000–30,000 | 195 | 43.3% |
| | 30,001–50,000 | 115 | 25.6% |
| | > 50,000 | 55 | 12.2% |

---

## 9. Descriptive Statistics for Likert Items

**Example Table 2: Descriptive Statistics for Survey Items**

| Item | Description | Mean | SD | Skew | Kurt |
|------|------------|------|----|------|------|
| **Perceived Safety** | | | | | |
| PS1 | "I feel safe using public transit" | 3.42 | 0.98 | −0.31 | −0.42 |
| PS2 | "The roads I travel are safe" | 3.18 | 1.05 | −0.18 | −0.65 |
| PS3 | "I feel protected from crime at stops" | 2.95 | 1.12 | 0.12 | −0.78 |
| **Service Quality** | | | | | |
| SQ1 | "Transit arrives on time" | 3.05 | 1.08 | 0.05 | −0.71 |
| SQ2 | "Transit is clean and comfortable" | 3.21 | 1.01 | −0.22 | −0.54 |

**Reporting guidance**: Report mean, SD, skewness, and kurtosis for all scale items. Note: |Skew| < 2 and |Kurt| < 7 supports normality assumption.

---

## 10. Inter-item Correlation Matrix

Before factor analysis, examine inter-item correlations:
- **Too low** (< 0.30): items may not share a common factor
- **Too high** (> 0.90): items may be redundant (multicollinearity)
- **Ideal range**: 0.30 – 0.70

---

## 11. Reliability Analysis: Cronbach's Alpha

**Steps in SPSS:**
1. `Analyze → Scale → Reliability Analysis`
2. Move items to `Items` box
3. Click `Statistics → Item-total statistics, Inter-item correlations`
4. Model: Alpha
5. Click `OK`

**Key outputs to report:**
- Cronbach's α (overall)
- Corrected item-total correlation for each item (should be ≥ 0.30)
- "Alpha if item deleted" — flag items where deletion would substantially increase α

**Decision rule**: If removing an item increases α by > 0.05 and the item has a poor corrected item-total correlation (< 0.30), consider removing it.

---

## 12. Summary Checklist ✓

Before proceeding to EFA, verify:

- [ ] Sample size assessed (n ≥ 5 per item; minimum n = 100, ideally n ≥ 200)
- [ ] Missing values addressed (< 5% or imputed)
- [ ] Outliers examined (univariate z-scores; multivariate Mahalanobis D²)
- [ ] Normality assessed (skewness, kurtosis, histograms, Q-Q plots)
- [ ] Descriptive statistics table prepared
- [ ] Inter-item correlations examined (0.30–0.70 range)
- [ ] Cronbach's α computed for each subscale (α ≥ 0.70)
- [ ] Corrected item-total correlations ≥ 0.30 for all retained items

---

## References

- Field, A. (2024). *Discovering Statistics Using IBM SPSS Statistics* (6th ed.). Sage.
- George, D., & Mallery, P. (2019). *IBM SPSS Statistics 26 Step by Step* (16th ed.). Routledge.
- Hair, J. F., Black, W. C., Babin, B. J., & Anderson, R. E. (2019). *Multivariate Data Analysis* (8th ed.). Cengage.
- Little, R. J. A., & Rubin, D. B. (2020). *Statistical Analysis with Missing Data* (3rd ed.). Wiley.
- Tabachnick, B. G., & Fidell, L. S. (2019). *Using Multivariate Statistics* (7th ed.). Pearson.

---

*See also: [01_SPSS_Guide.md](./01_SPSS_Guide.md) | [01_R_Script.R](./01_R_Script.R) | [01_Exercises.md](./01_Exercises.md)*
