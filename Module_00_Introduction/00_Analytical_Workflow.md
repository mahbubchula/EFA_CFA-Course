# 00 — The Complete Analytical Workflow

> **Module 00 | Introduction & Foundations**
> *Course: Advanced Statistical Methods for Transportation & Behavioral Research*
> *Instructor: Dr. Mahbub Hassan, Chulalongkorn University*

---

## The Full Analytical Pipeline

This diagram shows exactly where each technique fits and why the order matters:

```
╔══════════════════════════════════════════════════════════════════════╗
║          COMPLETE ANALYTICAL WORKFLOW FOR SURVEY RESEARCH            ║
╚══════════════════════════════════════════════════════════════════════╝

PHASE 1: DESIGN & DATA COLLECTION
┌─────────────────────────────────────────────────────────────────────┐
│  Research Questions & Hypotheses                                     │
│  ↓                                                                   │
│  Literature Review → Conceptual Framework                           │
│  ↓                                                                   │
│  Survey Instrument Design (items from validated scales or new)      │
│  ↓                                                                   │
│  Pilot Study (n = 30–50) → Item Analysis → Revise                  │
│  ↓                                                                   │
│  Full Data Collection (n ≥ 200 for SEM)                             │
└─────────────────────────────────────────────────────────────────────┘
                          ↓
PHASE 2: DATA PREPARATION                              [Module 01]
┌─────────────────────────────────────────────────────────────────────┐
│  Data Entry & Coding                                                 │
│  Missing Value Analysis                                              │
│  Outlier Detection (univariate & multivariate)                      │
│  Normality Testing                                                   │
│  Descriptive Statistics & Frequencies                               │
│  Reliability Assessment (Cronbach's α)                              │
└─────────────────────────────────────────────────────────────────────┘
                          ↓
PHASE 3: FACTOR STRUCTURE (NEW SCALE / EXPLORATORY)    [Module 02]
┌─────────────────────────────────────────────────────────────────────┐
│  Exploratory Factor Analysis (EFA)                                  │
│  → KMO & Bartlett's Test                                            │
│  → Factor Extraction (PCA or common factor)                         │
│  → Factor Rotation (Oblimin / Varimax)                              │
│  → Item Retention Decisions                                         │
│  → Naming Factors                                                   │
└─────────────────────────────────────────────────────────────────────┘
                          ↓
PHASE 4: MEASUREMENT MODEL VALIDATION                  [Module 03]
┌─────────────────────────────────────────────────────────────────────┐
│  Confirmatory Factor Analysis (CFA)                                 │
│  → Model Specification                                              │
│  → Model Fit Assessment (CFI, TLI, RMSEA, SRMR)                   │
│  → Convergent Validity (AVE ≥ 0.50, loadings ≥ 0.50)              │
│  → Discriminant Validity (HTMT < 0.85)                             │
│  → Composite Reliability (CR ≥ 0.70)                               │
│  → Measurement Invariance (if comparing groups)                    │
└─────────────────────────────────────────────────────────────────────┘
                          ↓
PHASE 5: STRUCTURAL MODEL                              [Module 04 & 05]
┌─────────────────────────────────────────────────────────────────────┐
│  Option A: CB-SEM (AMOS / lavaan)                                   │
│  → Full model with latent variables                                 │
│  → Direct, indirect, total effects                                  │
│  → Mediation analysis                                               │
│  → Moderation / Interaction effects                                 │
│                                                                      │
│  Option B: Regression Analysis                                       │
│  → Linear regression (continuous outcome)                           │
│  → Logistic regression (binary outcome)                             │
│  → Ordinal regression (ordered categories)                          │
│  → Path analysis (observed variables only)                          │
└─────────────────────────────────────────────────────────────────────┘
                          ↓
PHASE 6: REPORTING & DISSEMINATION
┌─────────────────────────────────────────────────────────────────────┐
│  Tables: Factor loadings, fit indices, path coefficients, R²        │
│  Figures: Path diagram, measurement model diagram                   │
│  Interpretation: Practical significance + effect sizes              │
│  Manuscript preparation (journal requirements)                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## When to Use Which Method

### Decision Tree

```
START: What is your research question?
        ↓
Is the outcome variable continuous?
    YES → Linear Regression, SEM path model
    NO  → Is it binary? → Logistic Regression
          Is it ordered? → Ordinal Regression
        ↓
Do you have latent (unobserved) constructs?
    NO → Multiple Regression, Path Analysis
    YES ↓
Are you exploring factor structure (new scale)?
    YES → Start with EFA (Module 02)
    NO  ↓
Are you validating a known factor structure?
    YES → CFA (Module 03)
        ↓
Do you want to test relationships between constructs?
    YES → CB-SEM (Module 04)
        ↓
Is your model large and complex with many constructs?
    YES → Consider SmartPLS (PLS-SEM) for prediction
    NO  → AMOS or lavaan for theory testing
```

---

## CB-SEM vs. PLS-SEM: Quick Comparison

| Criterion | CB-SEM (AMOS/lavaan) | PLS-SEM (SmartPLS) |
|-----------|---------------------|---------------------|
| **Objective** | Theory confirmation | Prediction & exploration |
| **Sample size** | Larger (≥ 200) | Can work with smaller samples |
| **Distribution** | Requires multivariate normality | Distribution-free |
| **Measurement model** | Reflective only (traditional) | Reflective and formative |
| **Fit indices** | Full set (CFI, RMSEA, etc.) | No global fit index (traditionally) |
| **Latent variable scores** | Not directly computed | Directly computed |
| **Common use** | Theory testing | Exploratory, prediction |
| **Recommended when** | Testing established theory | Building new theoretical models |

---

## Reporting Standards

### For Journal Submissions (Transportation Research / Accident Analysis)

**Measurement Model Table:**
| Construct | Item | Loading | CR | AVE | α |
|-----------|------|---------|-----|-----|---|

**Model Fit Summary:**
| Index | Value | Threshold | Result |
|-------|-------|-----------|--------|
| χ²/df | | ≤ 3.0 | |
| CFI | | ≥ 0.90 | |
| TLI | | ≥ 0.90 | |
| RMSEA | | ≤ 0.08 | |
| SRMR | | ≤ 0.08 | |

**Structural Path Table:**
| Hypothesis | Path | β | SE | t-value | p-value | Supported? |
|-----------|------|---|-----|---------|---------|-----------|

---

*Next: [Module 01 — Descriptive Statistics](../Module_01_Descriptive_Statistics/)*
