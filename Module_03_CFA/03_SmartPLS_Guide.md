# 03 — CFA in SmartPLS 4.0: Step-by-Step Guide

> **Module 03 | Confirmatory Factor Analysis**
> *Course: Advanced Statistical Methods for Transportation & Behavioral Research*
> *Instructor: Dr. Mahbub Hassan, Chulalongkorn University*

---

## SmartPLS and CFA

SmartPLS 4.0 uses **Partial Least Squares (PLS)** estimation. While it's primarily a PLS-SEM tool, it offers:
- **Reflective measurement model assessment** (equivalent to CFA in the PLS framework)
- **PLSc (Consistent PLS)** — corrects PLS estimates to approximate CB-SEM results

**Important distinction**: SmartPLS's "CFA" is technically PLS-based, not ML-based like AMOS/lavaan. However, PLSc produces similar results and is increasingly accepted in journals.

---

## Step 1: Create a New Project

1. Open SmartPLS 4.0
2. **File → New Project** → Name: `BUTS_CFA`
3. **Import Data**: Click `Import Data` → Browse to `BUTS_main.csv` → Open
4. Verify data import: check variable names and row count

---

## Step 2: Create the Path Model

### 2a: Create a New Model
Right-click on project → **New Model** → Name: `Measurement_Model_CFA`

### 2b: Draw Latent Variables
1. Double-click on empty canvas to add a latent variable
2. Name it `PS` (Perceived Safety)
3. Repeat for `SQ`, `EA`, `BI`

### 2c: Assign Indicators
1. Select latent variable `PS`
2. From the **Indicator panel** (left), drag items to the model:
   - Drag `PS1`, `PS2`, `PS3`, `PS4` to connect to `PS`
3. Repeat for other constructs:
   - SQ ← SQ1, SQ2, SQ3, SQ4
   - EA ← EA1, EA2, EA3, EA4
   - BI ← BI1, BI2, BI3

### 2d: Set All Constructs as Reflective
Right-click each construct → **Reflective** (default should be reflective)
*(Formative would be used for index constructs)*

---

## Step 3: Configure Algorithm Settings

### For PLS-SEM (standard):
`Calculate → PLS-SEM Algorithm`
- Maximum iterations: 300
- Stop criterion: 10⁻⁷
- Weighting scheme: **Path weighting** (recommended)
- Significance level: 0.05

### For PLSc (Consistent PLS — closer to CB-SEM):
`Calculate → PLSc Algorithm`
- Same settings
- PLSc corrects for attenuation bias in PLS estimates

---

## Step 4: Run Bootstrapping for Significance Tests

`Calculate → Bootstrapping`
- Subsamples: **5000** (recommended for stable results)
- Confidence interval method: **BCa bootstrap** (bias-corrected and accelerated)
- Significance level: **0.05**
- Check: `Parallel processing` (for speed)
- Click **Start Calculation**

---

## Step 5: Evaluate Measurement Model

### 5.1 Open Results
After calculation: Click **Measurement Model** tab in results

### 5.2 Outer Loadings (Factor Loadings)
Navigate to: `Results → Measurement Model → Outer Loadings`

| Item | Loading | t-value | p-value | Decision |
|------|---------|---------|---------|---------|
| PS1 → PS | 0.782 | 15.2 | <0.001 | ✓ Retain |
| PS2 → PS | 0.741 | 14.1 | <0.001 | ✓ Retain |
| PS3 → PS | 0.762 | 14.6 | <0.001 | ✓ Retain |
| PS4 → PS | 0.724 | 13.7 | <0.001 | ✓ Retain |

**Criterion**: Outer loading ≥ 0.70 (strongly preferred); ≥ 0.50 acceptable

Items with loading 0.40–0.69: Consider removing if removing increases AVE without substantially reducing CR.
Items with loading < 0.40: Remove

### 5.3 Internal Consistency Reliability
Navigate to: `Results → Measurement Model → Reliability`

| Construct | Cronbach's α | rho_A | CR (rho_C) | AVE |
|-----------|-------------|-------|-----------|-----|
| PS | 0.856 | 0.861 | 0.872 | 0.578 |
| SQ | 0.823 | 0.829 | 0.861 | 0.608 |
| EA | 0.871 | 0.875 | 0.903 | 0.625 |
| BI | 0.891 | 0.895 | 0.918 | 0.736 |

**Criteria**:
- Cronbach's α ≥ 0.70
- **rho_A ≥ 0.70** (SmartPLS-specific reliability)
- CR (rho_C) ≥ 0.70
- **AVE ≥ 0.50**

**Note on SmartPLS reliability measures**:
- `rho_A` (Dijkstra-Henseler's rho_A): More accurate than α for PLS models
- `rho_C` (composite reliability) = traditional CR formula
- Prefer reporting rho_A and rho_C alongside AVE

### 5.4 Convergent Validity Summary

✓ All loadings ≥ 0.50
✓ All AVE ≥ 0.50
✓ All CR ≥ 0.70

→ **Convergent validity is established**

---

## Step 6: Discriminant Validity in SmartPLS 4.0

### 6.1 HTMT (Heterotrait-Monotrait Ratio)

Navigate to: `Results → Discriminant Validity → HTMT`

| | PS | SQ | EA | BI |
|--|---|----|----|----|
| PS | | | | |
| SQ | **0.521** | | | |
| EA | **0.412** | **0.471** | | |
| BI | **0.631** | **0.712** | **0.583** | |

**Criterion**: All HTMT values < 0.85

**Confidence intervals**: Check SmartPLS's bootstrapped 95% CI for HTMT:
- CI should not include 1.0 for discriminant validity to be supported

### 6.2 Fornell-Larcker Criterion

Navigate to: `Results → Discriminant Validity → Fornell-Larcker`

| | PS | SQ | EA | BI |
|--|---|----|----|----|
| **PS** | **0.760** | | | |
| **SQ** | 0.381 | **0.780** | | |
| **EA** | 0.312 | 0.358 | **0.790** | |
| **BI** | 0.421 | 0.518 | 0.407 | **0.858** |

**Criterion**: Diagonal (√AVE) > all off-diagonal values in same row/column

### 6.3 Cross-Loadings

Navigate to: `Results → Discriminant Validity → Cross-Loadings`

| | PS | SQ | EA | BI |
|--|---|----|----|----|
| PS1 | **0.782** | 0.299 | 0.241 | 0.318 |
| PS2 | **0.741** | 0.281 | 0.218 | 0.299 |
| SQ1 | 0.312 | **0.815** | 0.278 | 0.341 |
| ... | | | | |

**Criterion**: Each item's loading on its own construct should exceed all cross-loadings.

---

## Step 7: SmartPLS CFA vs. lavaan CFA — Key Differences

| Aspect | SmartPLS 4.0 | lavaan (R) |
|--------|-------------|------------|
| Estimation | PLS / PLSc | ML, MLR, WLSMV |
| Fit indices | Limited (SRMR for PLSc) | Full set (CFI, TLI, RMSEA, SRMR) |
| Factor loadings | PLS weights | ML loadings |
| Reliability | rho_A, rho_C | CR, α |
| Validity | HTMT, Fornell-Larcker, cross-loadings | Same |
| Normality requirement | None | Required for ML |
| Preferred for | Prediction, exploration | Theory testing |

**Recommendation**: Use **lavaan** for CFA and CB-SEM when theory testing is the goal (most journal submissions). Use **SmartPLS** for PLS-SEM and prediction-focused research.

---

## Step 8: Saving and Reporting SmartPLS Results

### Export Tables:
`Results → Export Results` → Select output tables → Save as Excel

### Report template from SmartPLS:
`Report → Generate Report` → Creates a Word/PDF report with all output

### What to report (for journal submission):
1. Measurement model: outer loadings (loadings), α, rho_A, rho_C, AVE
2. HTMT matrix
3. Path coefficients and t-values (in structural model)
4. R² for endogenous constructs
5. f² effect sizes
6. Model fit: SRMR (for PLSc; should be < 0.08)

---

## Quick Reference: SmartPLS 4.0 Navigation

| Task | Location |
|------|---------|
| Import data | File → Import Data |
| Run PLS algorithm | Calculate → PLS-SEM Algorithm |
| Run bootstrapping | Calculate → Bootstrapping |
| Outer loadings | Results → Measurement Model → Outer Loadings |
| Reliability (α, CR, AVE) | Results → Measurement Model → Reliability |
| HTMT | Results → Discriminant Validity → HTMT |
| Fornell-Larcker | Results → Discriminant Validity → Fornell-Larcker |
| Path coefficients | Results → Structural Model → Path Coefficients |
| Indirect effects | Results → Structural Model → Specific Indirect Effects |
| Generate report | Report → Generate Report |

---

*See also: [03_CFA_Theory.md](./03_CFA_Theory.md) | [03_R_lavaan_Script.R](./03_R_lavaan_Script.R) | [03_SPSS_AMOS_Guide.md](./03_SPSS_AMOS_Guide.md)*
