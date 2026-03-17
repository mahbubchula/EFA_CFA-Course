---
title: "02 · Exploratory Factor Analysis"
nav_order: 4
has_children: true
---

# Module 02: Exploratory Factor Analysis (EFA)

## Overview

Exploratory Factor Analysis (EFA) is used to **discover the underlying factor structure** of a set of observed variables. It is the critical first step when developing new scales or when the factor structure of existing instruments has not been confirmed in your population.

In transportation and behavioral research, EFA helps you:
- Identify how survey items group together into latent constructs
- Reduce a large set of items to a manageable set of factors
- Explore dimensionality before confirmatory testing

## Learning Objectives

- Explain the purpose and logic of EFA
- Check all EFA assumptions (sample size, factorability, normality)
- Choose appropriate extraction and rotation methods
- Interpret factor loadings and determine item retention
- Name factors based on theoretical meaning
- Conduct and report EFA using SPSS and R

## Contents

| File | Description |
|------|-------------|
| [02_EFA_Theory.md](./02_EFA_Theory.md) | Complete EFA theory: assumptions, extraction, rotation, interpretation |
| [02_SPSS_Guide.md](./02_SPSS_Guide.md) | Step-by-step SPSS EFA walkthrough |
| [02_R_Script.R](./02_R_Script.R) | Fully annotated R script for EFA |
| [02_Exercises.md](./02_Exercises.md) | Practice problems with guidance |

## Key Concepts

- **Factorability**: KMO ≥ 0.60; Bartlett's test p < 0.05
- **Factor Extraction**: Principal Axis Factoring (PAF) recommended for latent variables; PCA for data reduction
- **Number of Factors**: Scree plot + parallel analysis + eigenvalue > 1 (Kaiser criterion)
- **Rotation**: Oblimin (oblique) when factors are expected to correlate; Varimax (orthogonal) when independent
- **Factor Loadings**: Retain items with loading ≥ 0.40 (ideally ≥ 0.50)
- **Cross-loadings**: Items loading ≥ 0.30 on two factors → problematic

---

*Previous: [Module 01](../Module_01_Descriptive_Statistics/) | Next: [Module 03 — CFA](../Module_03_CFA/)*
