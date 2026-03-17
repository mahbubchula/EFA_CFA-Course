---
title: "03 · Confirmatory Factor Analysis"
nav_order: 5
has_children: true
---

# Module 03: Confirmatory Factor Analysis (CFA)

## Overview

Confirmatory Factor Analysis (CFA) tests whether a **pre-specified factor structure** fits the observed data. Unlike EFA, you define which items belong to which factors before running the analysis — based on theory or previous EFA results. CFA is a form of **Structural Equation Modeling (SEM)** focused exclusively on the measurement model.

CFA is essential for:
- Validating your measurement instrument before building a structural model
- Assessing construct validity (convergent and discriminant)
- Testing measurement invariance across groups (e.g., comparing Thai and Malaysian travelers)
- Satisfying reviewer requirements for SEM publications

## Learning Objectives

- Specify CFA models with correct measurement model syntax
- Assess and interpret model fit indices (CFI, TLI, RMSEA, SRMR)
- Evaluate convergent validity (AVE, factor loadings, CR)
- Evaluate discriminant validity (HTMT ratio, Fornell-Larcker criterion)
- Modify models using modification indices (responsibly)
- Test measurement invariance across groups
- Implement CFA using SPSS AMOS, R (`lavaan`), and SmartPLS 4.0

## Contents

| File | Description |
|------|-------------|
| [03_CFA_Theory.md](./03_CFA_Theory.md) | Complete theory: model specification, fit, validity, invariance |
| [03_SPSS_AMOS_Guide.md](./03_SPSS_AMOS_Guide.md) | Step-by-step AMOS instructions |
| [03_R_lavaan_Script.R](./03_R_lavaan_Script.R) | Fully annotated R/lavaan script |
| [03_SmartPLS_Guide.md](./03_SmartPLS_Guide.md) | CFA in SmartPLS 4.0 |
| [03_Exercises.md](./03_Exercises.md) | Practice exercises |

## Key Fit Indices

| Index | Acceptable | Good |
|-------|-----------|------|
| χ²/df | ≤ 3.0 | ≤ 2.0 |
| CFI | ≥ 0.90 | ≥ 0.95 |
| TLI | ≥ 0.90 | ≥ 0.95 |
| RMSEA | ≤ 0.08 | ≤ 0.06 |
| SRMR | ≤ 0.08 | ≤ 0.06 |

---

*Previous: [Module 02 — EFA](../Module_02_EFA/) | Next: [Module 04 — CB-SEM](../Module_04_CB_SEM/)*
