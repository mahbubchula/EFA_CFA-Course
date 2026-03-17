# 03 — CFA in SPSS AMOS: Step-by-Step Guide

> **Module 03 | Confirmatory Factor Analysis**
> *Course: Advanced Statistical Methods for Transportation & Behavioral Research*
> *Instructor: Mahbub Hassan, Chulalongkorn University*

---

## What is AMOS?

IBM SPSS AMOS (Analysis of MOment Structures) is a graphical SEM software that comes with SPSS. It allows you to draw path diagrams visually and estimate CFA and SEM models. AMOS is widely used in transportation and behavioral research publications.

---

## Step 1: Launch AMOS and Open Data

1. Open SPSS → **File → Open → Data** → Load `BUTS_main.sav`
2. In SPSS, go to: **Analyze → IBM SPSS Amos**
   *(or open AMOS Graphics directly from Programs)*
3. In AMOS: **File → Data Files** → Select your SPSS .sav file → **OK**

---

## Step 2: Draw the CFA Model

### 2a: Drawing Latent Variables (Ovals/Ellipses)
1. Click the **oval tool** (left toolbar) — for latent variables
2. Draw 4 ovals on the canvas, labeled: **PS**, **SQ**, **EA**, **BI**
   - Right-click each oval → **Object Properties** → **Text** tab → Type the name

### 2b: Drawing Observed Variables (Rectangles)
1. Click the **rectangle tool** — for observed items
2. Draw rectangles for each item:
   - For PS: draw PS1, PS2, PS3, PS4
   - For SQ: draw SQ1, SQ2, SQ3, SQ4
   - For EA: draw EA1, EA2, EA3, EA4
   - For BI: draw BI1, BI2, BI3

**Faster alternative**: Use **Plugins → Draw Indicators** after placing the latent variable.

### 2c: Adding Error Terms
Each indicator needs an error term:
1. Select all indicators for one factor
2. Click **"Add unique variable"** button (toolbar) — or press `U` key
3. Error terms (small circles labeled e1, e2, etc.) will appear automatically

### 2d: Drawing Arrows (Paths)
1. Click the **single-headed arrow tool** (→)
2. Draw from each latent variable to its indicators:
   - PS → PS1, PS → PS2, PS → PS3, PS → PS4
   - SQ → SQ1, SQ → SQ2, SQ → SQ3, SQ → SQ4
   - EA → EA1, EA → EA2, EA → EA3, EA → EA4
   - BI → BI1, BI → BI2, BI → BI3

### 2e: Factor Covariances (Double-headed arrows)
1. Click the **double-headed arrow tool** (↔)
2. Draw double arrows between ALL pairs of latent factors:
   - PS ↔ SQ
   - PS ↔ EA
   - PS ↔ BI
   - SQ ↔ EA
   - SQ ↔ BI
   - EA ↔ BI

### 2f: Scale Setting
AMOS requires each latent variable to have a fixed scale:
1. Right-click the path from **PS → PS1**
2. **Object Properties** → **Parameters** tab
3. Set **Regression weight** to **1** (and keep "unstandardized")
4. Repeat for the first indicator of each latent factor (SQ1, EA1, BI1)

---

## Step 3: Assign Variable Names to Rectangles

1. Double-click on each rectangle
2. **Object Properties** → **Text** tab
3. In **Variable name**, select from dropdown (must match SPSS variable names exactly)

---

## Step 4: Configure Analysis Properties

### 4a: Open Analysis Properties
`View → Analysis Properties` (or Ctrl+A)

### 4b: Estimation Tab
- Estimation method: **Maximum Likelihood** (default)
- ☑ **Estimate means and intercepts** (if testing scalar invariance)

### 4c: Output Tab
Check all of the following:
- ☑ **Minimization history**
- ☑ **Standardized estimates**
- ☑ **Squared multiple correlations** (= item R² = communality in CFA)
- ☑ **Sample moments**
- ☑ **Implied moments**
- ☑ **Residual moments**
- ☑ **Modification indices**
- ☑ **Indirect, direct, total effects**

Click **Close**.

---

## Step 5: Run the Analysis

Click the **"Calculate Estimates"** button (blue play button ▶)
or go to `Model-Fit → Calculate Estimates`

If successful, parameter estimates appear on the diagram.

---

## Step 6: View and Interpret Output

### 6.1 Fit Indices
In AMOS Graphics: Click **View Text** → **Model Fit**

```
Model Fit Summary

CMIN
    Model    NPAR    CMIN      DF       P       CMIN/DF
    Default   46    243.5     84    .000       2.899

Baseline Comparisons
    Model    NFI    RFI    IFI    TLI    CFI
    Default  .954   .941   .972   .963   .971

RMSEA
    Model    RMSEA    LO 90    HI 90    PCLOSE
    Default   .065     .055     .074      .082

SRMR
    Model    SRMR
    Default   .051
```

**Interpretation**: χ²/df = 2.899 (≤ 3.0 ✓), CFI = 0.971 (≥ 0.95 ✓),
TLI = 0.963 (≥ 0.95 ✓), RMSEA = 0.065 (≤ 0.08 ✓), SRMR = 0.051 (≤ 0.08 ✓)
→ **Model fit is good** ✓

### 6.2 Standardized Factor Loadings
Click **View Text** → **Estimates** → **Standardized Regression Weights**

```
Standardized Regression Weights (Group: Default)
            Estimate
PS1 ← PS     .782
PS2 ← PS     .741
PS3 ← PS     .762
PS4 ← PS     .724
SQ1 ← SQ     .815
SQ2 ← SQ     .824
...
```

All loadings should be ≥ 0.50 (ideally ≥ 0.70).

### 6.3 Modification Indices
Click **View Text** → **Modification Indices**

```
Modification Indices — Covariances:
         M.I.    Par Change
e1 ↔ e2   11.4     .043    ← PS1 and PS2 errors (similar wording?)
e7 ↔ e8    8.2     .038    ← Consider if > 10
```

**Action**: Only free error covariances if:
1. MI > 10
2. There is a clear theoretical justification (e.g., two items with nearly identical wording)

---

## Step 7: AMOS Output for AVE and CR Calculation

AMOS does not automatically compute AVE or CR. Extract standardized loadings and compute manually:

**CR Formula**:
```
CR = (Σλ)² / [(Σλ)² + Σ(1 - λ²)]
```

**AVE Formula**:
```
AVE = Σλ² / [Σλ² + Σ(1 - λ²)]
```

**Example (PS construct)**:
```
Loadings: λ1=.782, λ2=.741, λ3=.762, λ4=.724

Σλ = .782 + .741 + .762 + .724 = 3.009
Σλ² = .611 + .549 + .581 + .524 = 2.265
Σ(1-λ²) = .389 + .451 + .419 + .476 = 1.735

CR  = (3.009)² / [(3.009)² + 1.735] = 9.054 / (9.054 + 1.735) = 0.839
AVE = 2.265 / (2.265 + 1.735) = 2.265 / 4.000 = 0.566
```

→ CR = 0.839 (≥ 0.70 ✓), AVE = 0.566 (≥ 0.50 ✓) — Convergent validity supported

---

## Step 8: Multi-Group CFA (Measurement Invariance)

### 8a: Add Groups
`Analyze → Manage Groups`
- Add Group 1: "Male" → Add Group 2: "Female"
- In Data Files: For each group, specify the filtering variable/file

### 8b: Test Models Sequentially

**Model 1: Configural** — No constraints (different estimates per group)
`Model Fit → Manage Models` → Model 1: name "Configural", no constraints

**Model 2: Metric** — Constrain loadings
In Manage Models → Model 2: "Metric"
Constraints: Equal loadings (λ constrained equal across groups)
- Right-click each loading → Object Properties → Parameter tab → Assign matching labels

**Model 3: Scalar** — Constrain loadings + intercepts
Model 3: "Scalar", add equal intercept constraints

### 8c: Compare Models
`View Text → Model Fit` → Compare χ²:
- ΔCFI ≤ 0.010: Invariance holds
- Significant Δχ²: May indicate non-invariance (check partial invariance)

---

## Step 9: AMOS SPSS Syntax (Path Analysis via Syntax)

AMOS can also be controlled via R (using the `semPlot` or `lavaan` packages for equivalent results), or using AMOS Basic (VBA-like syntax within AMOS).

For production use, the lavaan R script (Module 03: 03_R_lavaan_Script.R) is recommended as it provides more flexible output and reproducibility.

---

## AMOS Troubleshooting

| Issue | Cause | Solution |
|-------|-------|---------|
| "Model not identified" | Missing scale constraint | Fix first loading of each factor to 1.0 |
| "Nonpositive definite matrix" | Correlated errors not specified | Check data; add error covariances if needed |
| Very poor fit | Misspecified model | Check modification indices; review theoretical structure |
| "Variable not found" | Variable name mismatch | Check spelling and case in Object Properties |
| Estimates not converging | Model too complex or bad start values | Simplify model; check for very small loadings |

---

*See also: [03_CFA_Theory.md](./03_CFA_Theory.md) | [03_R_lavaan_Script.R](./03_R_lavaan_Script.R) | [03_SmartPLS_Guide.md](./03_SmartPLS_Guide.md)*
