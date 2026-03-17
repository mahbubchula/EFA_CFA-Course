# 01 — Descriptive Statistics in SPSS: Step-by-Step Guide

> **Module 01 | Descriptive Statistics**
> *Course: Advanced Statistical Methods for Transportation & Behavioral Research*
> *Instructor: Mahbub Hassan, Chulalongkorn University*

---

## Dataset Used

All examples use the **Bangkok Urban Transportation Survey (BUTS)** dataset.
→ File: `../Datasets/BUTS_main.csv` (import into SPSS as `.sav`)

---

## Step 1: Opening and Importing Data

### Option A: Open existing SPSS .sav file
`File → Open → Data` → Select file → Click `Open`

### Option B: Import from CSV
`File → Import Data → CSV Data`
1. Browse to `BUTS_main.csv`
2. Check "Variable names included at top of file"
3. Click `Next` → verify variable types
4. Click `Finish`

### Checking Variable Properties
`Variable View` tab:
- Set appropriate `Measure` type: Nominal, Ordinal, or Scale
- Set `Label` for each variable (full description)
- Set `Values` for categorical variables (e.g., 1=Male, 2=Female)
- Set `Missing` values if applicable

---

## Step 2: Frequencies for Categorical Variables

**Purpose**: Describe sample demographics (gender, age group, mode choice)

### Menu Path:
`Analyze → Descriptive Statistics → Frequencies`

### Steps:
1. Move categorical variables to `Variable(s)` box: `Gender`, `AgeGroup`, `PrimaryMode`, `IncomeGroup`
2. Click `Charts`
   - Select `Bar charts`
   - Click `Continue`
3. Click `Statistics`
   - Check: `Mean`, `Median`, `Mode`, `Std. deviation`, `Range`
   - Click `Continue`
4. Click `OK`

### Interpreting Output:
```
Gender
               Frequency  Percent  Valid Percent  Cumulative Percent
Male           265        58.9     58.9           58.9
Female         185        41.1     41.1           100.0
Total          450        100.0    100.0
```

---

## Step 3: Descriptive Statistics for Scale Variables

**Purpose**: Summarize Likert scale items — mean, SD, skewness, kurtosis

### Menu Path:
`Analyze → Descriptive Statistics → Descriptives`

### Steps:
1. Move all scale items (PS1–PS5, SQ1–SQ5, etc.) to `Variable(s)` box
2. Click `Options`
   - Check: `Mean`, `Std. deviation`, `Minimum`, `Maximum`, `Skewness`, `Kurtosis`
   - Click `Continue`
3. Click `OK`

### Expected Output — Example:
```
                    N    Min  Max   Mean  Std. Dev.  Skewness  Kurtosis
PS1 (Feel safe...)  450   1    5    3.42   0.98      -.31      -.42
PS2 (Roads safe...) 450   1    5    3.18   1.05      -.18      -.65
SQ1 (On time...)    450   1    5    3.05   1.08       .05      -.71
```

**Decision**: Items with |Skewness| > 2 or |Kurtosis| > 7 may violate normality assumption.

---

## Step 4: Explore — Detailed Normality Tests

**Purpose**: Formal normality testing plus box plots and histograms

### Menu Path:
`Analyze → Descriptive Statistics → Explore`

### Steps:
1. Move scale items to `Dependent List`
2. Move `Gender` (or other grouping variable) to `Factor List` (optional)
3. Click `Plots`
   - Check: `Normality plots with tests`
   - Check: `Histogram`
   - Check: `Stem-and-leaf`
   - Click `Continue`
4. Click `Statistics`
   - Check: `Descriptives`, `Outliers`
   - Click `Continue`
5. Click `OK`

### Interpreting Tests of Normality:
```
                    Kolmogorov-Smirnov      Shapiro-Wilk
                    Statistic  df   Sig.   Statistic  df   Sig.
PS1                 .089      450  .000    .968      450  .000
```

**Note**: With n = 450, significance is expected. Focus on:
- Histograms (visual bell curve?)
- Normal Q-Q plots (do points follow the diagonal?)
- Skewness/Kurtosis within acceptable range

---

## Step 5: Missing Value Analysis

### Menu Path:
`Analyze → Missing Value Analysis`

### Steps:
1. Move all variables to `Quantitative Variables`
2. Click `Estimation → EM` (for missing pattern)
3. Click `Descriptives → Univariate statistics`
4. Click `OK`

### Output: Missing Value Summary
```
Variable    N     Missing     % Missing
PS1         450     0         0.0%
PS2         448     2         0.4%
SQ1         445     5         1.1%
Income      415    35         7.8%    ← Needs attention
```

**Decision**: For `Income` with 7.8% missing → use Multiple Imputation.

### Multiple Imputation:
`Analyze → Multiple Imputation → Impute Missing Data Values`
1. Select variables with > 5% missing
2. Method: `Fully Conditional Specification (FCS)`
3. Number of imputations: 5
4. Click `OK`

---

## Step 6: Outlier Detection — Mahalanobis Distance

**Purpose**: Find multivariate outliers across all scale items

### Menu Path:
`Analyze → Regression → Linear`

### Steps:
1. Set any scale item as `Dependent`
2. Move all other scale items to `Independent(s)`
3. Click `Save`
   - Check `Mahalanobis` under Distances
   - Click `Continue`
4. Click `OK`

### Interpreting Results:
A new variable `MAH_1` appears in Data View.

Evaluate against chi-square critical value:
- df = number of predictor variables
- Significance level = 0.001

**In SPSS**: `Transform → Compute Variable`
```
p_mah = 1 - CDF.CHISQ(MAH_1, df)
```
Cases with `p_mah < 0.001` are potential multivariate outliers.

---

## Step 7: Correlation Matrix

**Purpose**: Examine inter-item relationships before factor analysis

### Menu Path:
`Analyze → Correlate → Bivariate`

### Steps:
1. Move all scale items to `Variables`
2. Correlation Coefficients: `Pearson`
3. Test of Significance: `Two-tailed`
4. Check `Flag significant correlations`
5. Click `OK`

### What to Look For:
- ✓ Correlations 0.30–0.70 within a construct: Good
- ✗ Correlations < 0.30: Items may not belong to same factor
- ✗ Correlations > 0.90: Items may be redundant (consider removing one)

---

## Step 8: Reliability Analysis — Cronbach's Alpha

**Purpose**: Assess internal consistency of each scale/subscale

### Menu Path:
`Analyze → Scale → Reliability Analysis`

### Steps:
1. Move items for ONE construct to `Items` box (e.g., PS1, PS2, PS3, PS4, PS5)
2. Model: `Alpha`
3. Click `Statistics`
   - Check: `Item-total statistics`
   - Check: `Inter-item correlations and covariances`
   - Check: `Scale` and `Scale if item deleted`
   - Click `Continue`
4. Click `OK`
5. **Repeat for each construct separately**

### Interpreting Output:
```
Reliability Statistics
Cronbach's Alpha    N of Items
.856                5

Item-Total Statistics
        Scale Mean    Corrected Item-    Cronbach's Alpha
        if Item Del.  Total Correlation  if Item Deleted
PS1     13.74         .672               .826
PS2     13.98         .701               .818
PS3     14.21         .631               .840
PS4     13.85         .688               .822
PS5     13.62         .544               .859  ← Weaker, but still > 0.30
```

**Decision**:
- α = 0.856 → Good reliability
- PS5 has the lowest corrected item-total correlation (0.544), but it's above 0.30
- Removing PS5 would raise α to 0.859 — marginal gain; keep PS5

---

## Step 9: Creating a Publication-Ready Summary Table

Use `File → Export → Excel` or manually construct in Word/Excel.

**Template — Table 1: Descriptive Statistics and Reliability**

| Construct | Item | Item Description | Mean | SD | α |
|-----------|------|-----------------|------|----|---|
| **Perceived Safety** (PS) | PS1 | I feel safe using public transit | 3.42 | 0.98 | **0.856** |
| | PS2 | The roads I travel are safe | 3.18 | 1.05 | |
| | PS3 | I feel protected from crime | 2.95 | 1.12 | |
| **Service Quality** (SQ) | SQ1 | Transit arrives on time | 3.05 | 1.08 | **0.823** |
| | SQ2 | Transit is clean & comfortable | 3.21 | 1.01 | |

Note. n = 450. All items measured on 5-point Likert scale (1 = Strongly Disagree to 5 = Strongly Agree).

---

## SPSS Syntax (Equivalent Commands)

You can run all analyses using SPSS syntax. Save and reuse:

```spss
* ======================================================
* MODULE 01: DESCRIPTIVE STATISTICS — SPSS SYNTAX
* Course: EFA, CFA, and CB-SEM in Transportation Research
* Instructor: Mahbub Hassan, Chulalongkorn University
* ======================================================

* Step 1: Import data
GET DATA
  /TYPE=TXT
  /FILE='E:\06_GitHub_Repo\03_Archive\EFA_CFA_Course\Datasets\BUTS_main.csv'
  /DELCASE=LINE
  /DELIMITERS=","
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
  RespondentID A8
  Gender F1.0
  AgeGroup F1.0
  PrimaryMode F1.0
  PS1 F3.1
  PS2 F3.1
  PS3 F3.1
  PS4 F3.1
  PS5 F3.1
  SQ1 F3.1
  SQ2 F3.1
  SQ3 F3.1
  SQ4 F3.1
  BI1 F3.1
  BI2 F3.1
  BI3 F3.1.
CACHE.
EXECUTE.

* Step 2: Frequencies for categorical variables
FREQUENCIES VARIABLES=Gender AgeGroup PrimaryMode IncomeGroup
  /BARCHART PERCENT
  /ORDER=ANALYSIS.

* Step 3: Descriptive statistics
DESCRIPTIVES VARIABLES=PS1 PS2 PS3 PS4 PS5 SQ1 SQ2 SQ3 SQ4 BI1 BI2 BI3
  /STATISTICS=MEAN STDDEV MIN MAX SKEWNESS KURTOSIS.

* Step 4: Normality tests via Explore
EXAMINE VARIABLES=PS1 PS2 PS3 PS4 PS5 SQ1 SQ2 SQ3 SQ4
  /PLOT BOXPLOT HISTOGRAM NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

* Step 5: Correlation matrix
CORRELATIONS
  /VARIABLES=PS1 PS2 PS3 PS4 PS5 SQ1 SQ2 SQ3 SQ4 BI1 BI2 BI3
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

* Step 6: Mahalanobis distance (runs regression to save distances)
REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN
  /DEPENDENT PS1
  /METHOD=ENTER PS2 PS3 PS4 PS5 SQ1 SQ2 SQ3 SQ4 BI1 BI2 BI3
  /SAVE MAHAL.

* Step 7: Reliability analysis — Perceived Safety scale
RELIABILITY
  /VARIABLES=PS1 PS2 PS3 PS4 PS5
  /SCALE('Perceived Safety') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE CORR
  /SUMMARY=TOTAL.

* Step 8: Reliability analysis — Service Quality scale
RELIABILITY
  /VARIABLES=SQ1 SQ2 SQ3 SQ4
  /SCALE('Service Quality') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE CORR
  /SUMMARY=TOTAL.

* Step 9: Reliability analysis — Behavioral Intention scale
RELIABILITY
  /VARIABLES=BI1 BI2 BI3
  /SCALE('Behavioral Intention') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE CORR
  /SUMMARY=TOTAL.
```

---

*See also: [01_R_Script.R](./01_R_Script.R) | [01_Descriptive_Statistics_Theory.md](./01_Descriptive_Statistics_Theory.md)*
