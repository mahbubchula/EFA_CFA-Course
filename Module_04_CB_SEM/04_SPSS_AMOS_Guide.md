---
title: "04 · AMOS Guide"
parent: "04 · Covariance-Based SEM"
nav_order: 2
---

# SPSS AMOS Guide — Covariance-Based SEM
{: .no_toc }

**Module 04 · Covariance-Based SEM**
{: .label .label-purple }

## Table of Contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 1. Introduction to SPSS AMOS

SPSS AMOS (Analysis of Moment Structures) is a graphical SEM software tightly integrated with SPSS. It allows you to draw path diagrams directly and estimate full structural equation models. AMOS uses **maximum likelihood (ML)** estimation and provides global fit indices (CFI, TLI, RMSEA, SRMR) alongside path coefficients.

### When to use AMOS
- You have established your measurement model via CFA (Module 03)
- You want to test causal paths between latent constructs
- You need mediation or moderation analysis
- Your sample is ≥ 200 and data is approximately multivariate normal

### AMOS vs. R/lavaan
| Feature | AMOS | R/lavaan |
|---------|------|----------|
| Interface | Graphical drag-and-drop | Syntax-based |
| Learning curve | Lower for beginners | Higher, more flexible |
| Bootstrapping | Built-in | Built-in |
| Measurement invariance | Via multiple-group | Via lavaan commands |
| Cost | Requires SPSS license | Free, open source |
| Reproducibility | Limited (GUI) | Full script reproducibility |

---

## 2. Preparing Your Data

Before opening AMOS, prepare your SPSS `.sav` file:

1. Open SPSS → Load `BUTS_main.csv` or the `.sav` file
2. Recode missing values (use `Transform → Recode` or listwise deletion for small MCAR %)
3. Check variable names — AMOS uses SPSS variable names directly
4. Verify scale: all items should be numeric (1–5 Likert)

{: .note }
> AMOS reads `.sav` files directly. If using `.csv`, first import into SPSS, set variable types, and save as `.sav`.

---

## 3. Opening AMOS Graphics

**Path:** `Start → IBM SPSS Statistics → IBM SPSS AMOS → AMOS Graphics`

Or from inside SPSS: `Analyze → IBM SPSS Amos`

The AMOS Graphics window has three main areas:
- **Drawing canvas** (center): where you draw path diagrams
- **Toolbar** (left): drawing tools, shapes, arrows
- **Menu bar** (top): File, Edit, View, Diagram, Analyze, Tools

---

## 4. Two-Step Approach in AMOS

Following Anderson & Gerbing (1988), always run SEM in two steps:

**Step 1: Measurement Model (CFA)** — confirm all constructs fit well
**Step 2: Structural Model** — add paths between latent constructs

### Step 1: Draw the CFA/Measurement Model

#### 4.1 Draw Latent Variables (Circles/Ovals)

1. Click the **oval tool** (circle icon) in the toolbar
2. Draw 5 ovals on the canvas — one per construct:
   - `PerceivedSafety` (PS)
   - `ServiceQuality` (SQ)
   - `EnvAttitude` (EA)
   - `BehavioralIntention` (BI)
   - `ActualBehavior` (AB)

{: .note }
> Tip: Hold Shift while dragging to draw perfect circles. Use Ctrl+D to duplicate an oval.

#### 4.2 Add Observed Variables (Rectangles)

1. Click the **rectangle tool** in the toolbar
2. Draw rectangles for each indicator:

| Construct | Indicators |
|-----------|-----------|
| PS | ps1, ps2, ps3, ps4 |
| SQ | sq1, sq2, sq3, sq4 |
| EA | ea1, ea2, ea3, ea4 |
| BI | bi1, bi2, bi3 |
| AB | ab1, ab2, ab3, ab4 |

{: .important }
> Right-click each rectangle → **Object Properties** → in the "Variable name" dropdown, select the matching SPSS variable. This links the rectangle to your data.

#### 4.3 Draw Factor Loadings (Single-headed arrows)

1. Click the **single-headed arrow** tool
2. Draw arrows **from** each latent variable (oval) **to** each of its indicators (rectangles)
3. Each arrow = a factor loading (λ)

#### 4.4 Add Error Terms

1. Click **"Add a unique variable"** button (rectangle with a smaller rectangle attached) OR
2. Menu: `Diagram → Draw Unique Variable`
3. Click on each observed variable rectangle — AMOS automatically adds an error term (small circle with an arrow pointing to the rectangle)

**Name error terms**: Right-click each error circle → Object Properties → Variable name → `e1`, `e2`, ... `e19`

#### 4.5 Draw Factor Covariances (Double-headed arrows)

For the CFA measurement model, all latent constructs should covary freely:

1. Click the **double-headed curved arrow** tool
2. Draw curved arrows between each pair of latent variables (PS↔SQ, PS↔EA, PS↔BI, PS↔AB, SQ↔EA, etc.)

You need 10 covariance arrows total (5×4/2 = 10 pairs).

#### 4.6 Fix the Scale of Latent Variables

Each latent variable needs a scale. Fix one loading per construct to 1.0:

1. Right-click the arrow from a latent variable to its **first** indicator
2. → Object Properties → **Parameters** tab
3. Set **Regression weight** = `1`
4. Click OK

Do this for: PS→ps1, SQ→sq1, EA→ea1, BI→bi1, AB→ab1

---

## 5. Connecting AMOS to Your Data

1. Menu: **File → Data Files**
2. Click **File Name** → browse to your `BUTS_main.sav` file
3. Click **OK**

Verify: AMOS shows the dataset path and n=450 at the bottom.

---

## 6. Running the Measurement Model

### 6.1 Set Analysis Properties

Menu: **View → Analysis Properties** (or Ctrl+A)

Under the **Output** tab, check:
- ✅ Minimization history
- ✅ Standardized estimates
- ✅ Squared multiple correlations
- ✅ Residual moments
- ✅ Modification indices (set threshold = 4.0)
- ✅ Indirect, direct and total effects

Under the **Bootstrap** tab:
- ✅ Perform bootstrap (set 2000 samples for mediation analysis later)
- ✅ Percentile confidence intervals
- ✅ Bias-corrected confidence intervals

### 6.2 Estimate the Model

Menu: **Analyze → Calculate Estimates** (or F9 key)

AMOS will run ML estimation. Watch the status bar — it should say "Model converged normally."

{: .warning }
> If AMOS reports "Not positive definite" or "Model not identified": check that all latent variables have a fixed loading, all error terms are named, and no paths are missing.

### 6.3 View the Results

Menu: **View → Text Output** (or Ctrl+T)

**Key sections to check:**

#### Model Fit Summary

```
Model        CMIN     df    p     CMIN/df   CFI    TLI    RMSEA   SRMR
Default      147.3    142   .371   1.038    .998   .997   .012    .041
Saturated    0        0
Independence 3842.1   171   .000
```

**Acceptable fit criteria:**
| Index | Acceptable | Good |
|-------|-----------|------|
| CMIN/df | < 3.0 | < 2.0 |
| CFI | > .90 | > .95 |
| TLI | > .90 | > .95 |
| RMSEA | < .08 | < .05 |
| SRMR | < .08 | < .05 |

#### Standardized Factor Loadings

Navigate to: **Estimates → Scalars → Standardized Regression Weights**

```
         Estimate   S.E.    C.R.    p
ps1 <--- PS   .742   .038   19.53   ***
ps2 <--- PS   .768   .036   21.30   ***
ps3 <--- PS   .801   .034   23.57   ***
ps4 <--- PS   .756   .037   20.43   ***
```

All loadings should be > .50 and significant (p < .05).

---

## 7. Checking AVE, CR, and HTMT

AMOS does not calculate AVE, CR, or HTMT automatically. Export to Excel and calculate manually, or use the AMOS built-in Master Validity Tool plugin (if available).

**Manual formulas** (using standardized loadings λ):

```
AVE  = Σ(λ²) / n
CR   = [Σλ]² / ([Σλ]² + Σ(1-λ²))
HTMT = mean of cross-loadings / sqrt(AVE_A × AVE_B)
```

{: .note }
> See Module 03 — CFA Theory for the full validity assessment checklist.

---

## 8. Modifying the Measurement Model

If fit is poor, check **Modification Indices** (MI):

Navigate to: **Estimates → Modification Indices → Covariances**

Large MI values (> 10) suggest that freeing a parameter would improve fit substantially.

**Common modifications:**
- Correlated error terms between items of the same construct (e.g., `e1 ↔ e2` for ps1–ps2) — only if theoretically justifiable
- Remove items with loadings < .50

{: .warning }
> Never blindly add all modification indices. Each modification must have theoretical justification and should be reported in your paper.

---

## 9. Step 2 — Drawing the Structural Model

Once the measurement model fits well, add **structural paths** between latent constructs.

### 9.1 BUTS Theoretical Model

For the BUTS dataset, we test a model based on the Theory of Planned Behavior:

```
PS  →  BI     (Perceived Safety positively predicts Behavioral Intention)
SQ  →  BI     (Service Quality positively predicts BI)
EA  →  BI     (Environmental Attitude positively predicts BI)
BI  →  AB     (BI predicts Actual Behavior)
PS  →  AB     (Direct effect of PS on AB)
```

### 9.2 Draw Structural Paths

1. Remove some double-headed arrows (those representing hypothesized directional relationships)
2. Use **single-headed arrows** to draw:
   - PS → BI
   - SQ → BI
   - EA → BI
   - BI → AB
   - PS → AB (to test direct effect)

3. Add a **disturbance term** (error in equation) to each endogenous latent variable (BI and AB):
   - Menu: `Diagram → Draw Unique Variable` → click on BI oval → name it `d1`
   - Repeat for AB → name it `d2`

{: .important }
> Endogenous variables (those with incoming arrows) need disturbance terms. Exogenous variables (PS, SQ, EA — with no structural paths pointing to them) keep their covariance arrows.

### 9.3 Re-run the Structural Model

`Analyze → Calculate Estimates`

Compare fit indices of structural model vs. measurement model. The structural model fit is usually slightly worse (due to imposed constraints on paths).

---

## 10. Interpreting Structural Results

### 10.1 Path Coefficients

Navigate to: **Estimates → Scalars → Standardized Regression Weights**

```
         Estimate   S.E.   C.R.     p    Decision
BI <--- PS   .312   .048   6.50    ***   Supported (H1)
BI <--- SQ   .287   .051   5.63    ***   Supported (H2)
BI <--- EA   .241   .049   4.92    ***   Supported (H3)
AB <--- BI   .498   .043  11.58    ***   Supported (H4)
AB <--- PS   .178   .052   3.42    .001  Supported (H5)
```

**Interpretation criteria:**
| |β| | Strength |
|----|---------|
| < .10 | Negligible |
| .10–.29 | Small |
| .30–.49 | Moderate |
| ≥ .50 | Large |

### 10.2 R² Values (Squared Multiple Correlations)

Navigate to: **Estimates → Scalars → Squared Multiple Correlations**

```
BI    R² = .412    (PS, SQ, EA explain 41.2% of BI variance)
AB    R² = .358    (BI and PS explain 35.8% of AB variance)
```

---

## 11. Mediation Analysis in AMOS

To test whether BI mediates the relationship between PS and AB:

### 11.1 Re-run with Bootstrapping

1. **View → Analysis Properties → Bootstrap tab**
2. ✅ Perform bootstrap: **2000** samples
3. ✅ Bias-corrected confidence intervals
4. ✅ Indirect effects

`Analyze → Calculate Estimates`

### 11.2 View Indirect Effects

Navigate to: **Estimates → Matrices → Standardized Indirect Effects**

The PS→AB indirect effect (through BI) appears in this matrix.

Navigate to: **Estimates → Matrices → Bias-Corrected Percentile Method → Indirect Effects**

```
              PS      SQ      EA
AB    BI   .155    .143    .120
            95% CI [.108, .209]   p < .001
```

**Reporting template:**
> "The indirect effect of Perceived Safety on Actual Behavior through Behavioral Intention was β = .155 (95% BCa CI [.108, .209], p < .001), indicating significant partial mediation."

---

## 12. Multiple Group Analysis (Measurement Invariance)

To compare the model across groups (e.g., male vs. female):

1. **Analyze → Manage Groups**
2. Add groups: "Male" and "Female"
3. For each group, connect the same model to a separate data file (filtered) or use group variable

### Invariance Sequence

| Model | Constraints | df | ΔCFI |
|-------|------------|-----|------|
| Configural | No constraints | — | — |
| Metric | Factor loadings equal | + 14 | < .010 |
| Scalar | Loadings + intercepts equal | + 14 | < .010 |
| Strict | + Error variances equal | + 19 | < .010 |

Metric invariance (ΔCFI < .010) is the minimum required for comparing path coefficients across groups.

---

## 13. Saving and Exporting Results

### Save the AMOS Path Diagram
`File → Save As → name it "BUTS_SEM_Final.amw"`

### Copy Path Diagram to Word
Right-click on the canvas → **Copy (Enhanced Metafile)** → paste into Word/PowerPoint

### Export Output to Text
`File → Print → print to PDF` OR copy from the text output window

### Export to SPSS
The factor scores are not automatically saved; use R/lavaan for that purpose.

---

## 14. AMOS Checklist

Before reporting your AMOS SEM results:

- [ ] Two-step approach: CFA measurement model confirmed first
- [ ] All loadings > .50, all significant
- [ ] AVE > .50 and CR > .70 for all constructs
- [ ] HTMT < .90 (< .85 for similar constructs)
- [ ] Structural model fit: CFI > .95, RMSEA < .06, SRMR < .08
- [ ] All hypothesized paths reported with β, SE, CR, p-value
- [ ] R² reported for all endogenous constructs
- [ ] Mediation tested with bootstrapping (2000+ samples)
- [ ] Modification indices checked and theoretically justified

---

## 15. Common AMOS Errors and Solutions

| Error | Likely Cause | Solution |
|-------|-------------|----------|
| "Not positive definite" | Missing data or incorrect constraints | Check data, use listwise deletion, verify all constraints |
| "Model is not identified" | Too many free parameters | Fix one loading per construct to 1 |
| "Parameter estimates appear unstable" | Small sample or collinearity | Check n, check construct correlations |
| "Convergence not reached" | Starting values problem | Increase iterations: View → Analysis Properties → Numerical → Max iterations = 1000 |
| Completely standardized loadings > 1.0 | Heywood case | Check for near-zero error variances, remove item |

---

## 16. Reporting Template (APA Style)

> "A two-step structural equation modeling approach (Anderson & Gerbing, 1988) was employed using IBM SPSS AMOS 24.0. In the first step, a confirmatory factor analysis measurement model was evaluated [CFA results]. In the second step, the structural model was estimated. The structural model demonstrated acceptable fit: χ²(168) = 198.4, p = .06, CFI = .978, TLI = .971, RMSEA = .024 (90% CI [.000, .038]), SRMR = .046. All hypothesized structural paths were statistically significant. The path coefficients and R² values are presented in Figure X and Table X."

---

*[← Back to Module 04 Overview](./README.md)*
