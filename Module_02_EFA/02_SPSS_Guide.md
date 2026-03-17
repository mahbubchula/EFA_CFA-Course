# 02 — Exploratory Factor Analysis in SPSS: Step-by-Step Guide

> **Module 02 | Exploratory Factor Analysis**
> *Course: Advanced Statistical Methods for Transportation & Behavioral Research*
> *Instructor: Mahbub Hassan, Chulalongkorn University*

---

## Dataset
Use: `../Datasets/BUTS_main.csv` (load into SPSS)

---

## Step 1: Preliminary Check — Correlation Matrix

Before EFA, visually examine the correlation matrix.

### Menu Path:
`Analyze → Correlate → Bivariate`

Add all scale items (PS1–PS5, SQ1–SQ4, EA1–EA4, BI1–BI3, AB1–AB3)
Check: Pearson, Two-tailed, Flag significant correlations.

**What to look for**: Most correlations should be 0.30–0.70 within expected constructs.

---

## Step 2: Run EFA — Principal Axis Factoring with Oblimin Rotation

### Menu Path:
`Analyze → Dimension Reduction → Factor`

### 2a: Variable Selection
1. Move all scale items (PS1–AB3) to the `Variables` box

### 2b: Descriptives
Click **`Descriptives`**:
- ✓ **Initial solution**
- ✓ **KMO and Bartlett's test of sphericity**
- ✓ **Reproduced** (see residuals)
- ✓ **Anti-image** (diagonal = item-level MSA)
- Click **Continue**

### 2c: Extraction
Click **`Extraction`**:
- Method: **Principal axis factoring** ← Critical choice
- Analyze: **Correlation matrix**
- Display: ✓ **Unrotated factor solution**, ✓ **Scree plot**
- Extract: Select **Fixed number of factors** OR **Based on Eigenvalue > 1** for first run
- Maximum Iterations: **100**
- Click **Continue**

**First run**: Extract based on Eigenvalue > 1 to see initial structure.
**Second run**: Specify exact number (after parallel analysis in R).

### 2d: Rotation
Click **`Rotation`**:
- Method: **Direct Oblimin** ← Recommended for correlated factors
  - Delta: **0** (default; negative values produce more orthogonal solution)
- Display: ✓ **Rotated solution**, ✓ **Loading plot(s)**
- Maximum Iterations: **100**
- Click **Continue**

### 2e: Factor Scores (Optional)
Click **`Scores`**:
- ✓ **Save as variables** (if you need factor scores for later analysis)
- Method: **Regression**
- Click **Continue**

### 2f: Options
Click **`Options`**:
- ✓ **Exclude cases listwise**
- ✓ **Suppress absolute values less than**: **0.40**
  (hides loadings < 0.40 for cleaner pattern matrix display)
- Click **Continue**

### 2g: Run
Click **`OK`**

---

## Step 3: Interpreting SPSS EFA Output

### 3.1 KMO and Bartlett's Test

```
KMO and Bartlett's Test
Kaiser-Meyer-Olkin Measure of Sampling Adequacy.    .874
Bartlett's Test of Sphericity
    Approx. Chi-Square                             2847.3
    df                                              190
    Sig.                                           .000
```

**Interpretation**:
- KMO = 0.874 → Meritorious → ✓ Proceed with EFA
- Bartlett's p = .000 → Reject H₀ → Items are significantly correlated → ✓ EFA appropriate

### 3.2 Anti-Image Correlation Matrix
- Diagonal values = **Measures of Sampling Adequacy (MSA)** for each item
- **All MSA values should be ≥ 0.50**
- Items with MSA < 0.50 should be removed and EFA re-run

```
Anti-Image Matrices (diagonal only)
PS1  .891   ✓
PS2  .874   ✓
SQ1  .862   ✓
AB3  .432   ✗ Remove! Re-run EFA after removing.
```

### 3.3 Communalities

```
Communalities
         Initial   Extraction
PS1       .544       .612
PS2       .518       .578
PS3       .471       .523
SQ1       .532       .591
SQ2       .489       .547
BI1       .601       .672
BI2       .578       .641
AB3       .218       .241   ← Low — consider removing
```

**Decision**: Items with **extraction communality < 0.30** explain little common variance → remove.

### 3.4 Total Variance Explained

```
Total Variance Explained
Factor    Eigenvalue    % Variance    Cumulative %
1          5.82          38.8           38.8
2          2.91          19.4           58.2
3          2.08          13.9           72.1
4          0.95           6.3           78.4
5          0.81           5.4           83.8
...
```

**Interpretation**:
- Factors 1–3 have eigenvalue > 1 → Kaiser criterion suggests 3 factors
- 3 factors explain 72.1% of total variance → ✓ Good (aim for > 60%)
- Always confirm with scree plot and parallel analysis (run in R)

### 3.5 Scree Plot
- X-axis: Factor number
- Y-axis: Eigenvalue
- **Look for the "elbow"** — the point where the line bends sharply
- Extract factors to the LEFT of the elbow

### 3.6 Pattern Matrix (Main Output — Report This!)

```
Pattern Matrix (loadings < 0.40 suppressed)

              Factor 1   Factor 2   Factor 3
              (Safety)   (Quality)  (Intention)
PS1            .781
PS2            .723
PS3            .654
PS4            .611
SQ1                        .742
SQ2                        .789
SQ3                        .674
SQ4                        .651
BI1                                   .822
BI2                                   .761
BI3                                   .714

Extraction Method: Principal Axis Factoring
Rotation Method: Oblimin with Kaiser Normalization
```

**This is what you report in your paper.**

### 3.7 Structure Matrix (Do NOT report — for interpretation only)
The structure matrix shows the total (direct + indirect) correlation between items and factors. With oblique rotation, the pattern matrix is the correct one to report.

### 3.8 Factor Correlation Matrix (Report this!)

```
Factor Correlation Matrix
        Factor 1   Factor 2   Factor 3
Factor 1  1.000
Factor 2   .382     1.000
Factor 3   .421      .448      1.000
```

**Interpretation**: Factors 1–3 correlate moderately (0.38–0.45), confirming that oblique rotation was appropriate. If factors were uncorrelated, Varimax would have been better.

---

## Step 4: Assess and Refine the EFA Solution

### Decision Process for Each Item:

1. **Item loads < 0.40 on all factors** → Remove
2. **Item cross-loads (≥ 0.30 difference < 0.10 between top two factors)** → Remove or reassign
3. **Item communality < 0.30** → Remove
4. **Factor with < 3 items after removals** → Reconsider factor structure; may need to retain items or collapse factor with nearest conceptual factor

### After Removing Problematic Items:
**Re-run EFA** with retained items. Repeat until you have a clean solution.

---

## Step 5: SPSS Syntax for EFA

```spss
* ======================================================
* MODULE 02: EXPLORATORY FACTOR ANALYSIS — SPSS SYNTAX
* Course: EFA, CFA, and CB-SEM in Transportation Research
* Instructor: Mahbub Hassan, Chulalongkorn University
* ======================================================

* Step 1: KMO, Bartlett's, and initial EFA (eigenvalue > 1)
FACTOR
  /VARIABLES PS1 PS2 PS3 PS4 PS5 SQ1 SQ2 SQ3 SQ4 EA1 EA2 EA3 EA4 BI1 BI2 BI3 AB1 AB2 AB3
  /MISSING LISTWISE
  /ANALYSIS PS1 PS2 PS3 PS4 PS5 SQ1 SQ2 SQ3 SQ4 EA1 EA2 EA3 EA4 BI1 BI2 BI3 AB1 AB2 AB3
  /PRINT UNIVARIATE INITIAL EXTRACTION ROTATION KMO AIC REPR
  /FORMAT SORT BLANK(.40)
  /PLOT EIGEN
  /CRITERIA FACTORS(1) ITERATE(100)
  /EXTRACTION PAF
  /CRITERIA ITERATE(100)
  /ROTATION OBLIMIN
  /SAVE REG(ALL)
  /METHOD=CORRELATION.

* Step 2: Run EFA with specified number of factors (e.g., 4 factors)
* Change FACTORS(4) to your parallel analysis result
FACTOR
  /VARIABLES PS1 PS2 PS3 PS4 SQ1 SQ2 SQ3 SQ4 EA1 EA2 EA3 EA4 BI1 BI2 BI3
  /MISSING LISTWISE
  /ANALYSIS PS1 PS2 PS3 PS4 SQ1 SQ2 SQ3 SQ4 EA1 EA2 EA3 EA4 BI1 BI2 BI3
  /PRINT INITIAL EXTRACTION ROTATION KMO AIC REPR
  /FORMAT SORT BLANK(.40)
  /PLOT EIGEN
  /CRITERIA FACTORS(4) ITERATE(100)
  /EXTRACTION PAF
  /CRITERIA ITERATE(100)
  /ROTATION OBLIMIN
  /METHOD=CORRELATION.

* Note: Replace variable list with items retained after removing
*       low communality and cross-loading items.
```

---

## Step 6: Building the EFA Results Table

Organize your pattern matrix into a publication-ready table.

**Table Template for Transportation Journal:**

```
Table X. Results of Exploratory Factor Analysis (Pattern Matrix)

                                                    Factor Loadings
Item   Description                               F1      F2      F3      F4     h²
─────────────────────────────────────────────────────────────────────────────────
Factor 1: Perceived Safety (α = .856)
PS1    I feel safe using public transit          .78                            .65
PS2    The roads I travel daily are safe         .72                            .57
PS3    I feel protected from crime at stops      .65                            .51
PS4    Traffic behavior makes me feel safe       .61                            .49

Factor 2: Service Quality (α = .823)
SQ1    Transit arrives on schedule                       .74                   .62
SQ2    Transit vehicles are clean                        .79                   .68
SQ3    Transit staff are helpful                         .68                   .55
SQ4    Service frequency is adequate                     .65                   .52

Factor 3: Environmental Attitude (α = .871)
EA1    I prefer eco-friendly travel options                      .80           .71
EA2    I am concerned about vehicle emissions                    .76           .63
EA3    I try to reduce my carbon footprint                       .72           .58
EA4    Public transit helps protect the environment              .69           .55

Factor 4: Behavioral Intention (α = .891)
BI1    I plan to use public transit more                                .84    .74
BI2    I intend to reduce private car use                               .79    .68
BI3    I will choose transit over car next month                        .72    .61

Eigenvalue                                      3.82    2.95    2.48    2.21
% Variance explained                           25.5%   19.7%   16.5%   14.7%
Cumulative % variance                          25.5%   45.2%   61.7%   76.4%
─────────────────────────────────────────────────────────────────────────────────
Factor intercorrelations
F1-F2: .38    F1-F3: .31    F1-F4: .42
F2-F3: .29    F2-F4: .45    F3-F4: .51
─────────────────────────────────────────────────────────────────────────────────
Note. n = 450. Extraction: Principal Axis Factoring; Rotation: Direct Oblimin.
Loadings < .40 suppressed. h² = communality.
```

---

## Common SPSS EFA Issues and Solutions

| Issue | Likely Cause | Solution |
|-------|-------------|---------|
| "Matrix is not positive definite" | Near-perfect multicollinearity | Remove highly correlated items (r > .90) |
| "Convergence not achieved" | Too many factors or items | Increase iterations; reduce variables |
| KMO < 0.60 | Items don't share common variance | Remove low MSA items (from anti-image); revisit item content |
| Bartlett's p > 0.05 | Correlations too low | Items may measure truly different things; reconsider |
| Many cross-loadings | Ambiguous items or too many factors | Reduce factors; remove problematic items |

---

*See also: [02_R_Script.R](./02_R_Script.R) | [02_EFA_Theory.md](./02_EFA_Theory.md)*
