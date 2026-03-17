# Advanced Statistical Methods for Transportation & Behavioral Research
### Exploratory Factor Analysis · Confirmatory Factor Analysis · CB-SEM · Regression Analysis

<p align="center">
  <img src="https://img.shields.io/badge/Status-Active-brightgreen?style=for-the-badge" alt="Status">
  <img src="https://img.shields.io/badge/Level-Graduate%20%7C%20Advanced%20Undergraduate-blue?style=for-the-badge" alt="Level">
  <img src="https://img.shields.io/badge/Software-SPSS%20%7C%20R%20%7C%20SmartPLS%204.0-orange?style=for-the-badge" alt="Software">
  <img src="https://img.shields.io/badge/License-MIT-lightgrey?style=for-the-badge" alt="License">
</p>

---

## About This Course

This course provides a **comprehensive, hands-on training** in advanced quantitative methods used in transportation engineering, behavioral research, accident analysis, and travel survey research. Students will master the full analytical pipeline — from descriptive statistics to structural equation modeling — using **SPSS**, **R**, and **SmartPLS 4.0**.

**Why this course?**
Transportation and behavioral research increasingly relies on latent construct measurement, complex survey data, and multi-variable models. This course bridges the gap between statistical theory and practical application in real-world research contexts.

---

## Instructor

| | |
|---|---|
| **Name** | Dr. Mahbub Hassan |
| **Affiliation** | Department of Civil Engineering, Faculty of Engineering, Chulalongkorn University, Bangkok, Thailand |
| **Email** | mahbub.hassan@ieee.org |
| **GitHub** | [@mahbubchula](https://github.com/mahbubchula) |

---

## Course Modules

| # | Module | Topics | Software |
|---|--------|---------|----------|
| 00 | [Introduction & Foundations](./Module_00_Introduction/) | Research design, measurement theory, latent variables, scale development | — |
| 01 | [Descriptive Statistics](./Module_01_Descriptive_Statistics/) | Central tendency, dispersion, normality, visualization, reliability | SPSS · R |
| 02 | [Exploratory Factor Analysis (EFA)](./Module_02_EFA/) | Factor extraction, rotation methods, interpretation, item reduction | SPSS · R |
| 03 | [Confirmatory Factor Analysis (CFA)](./Module_03_CFA/) | Model specification, fit indices, reliability/validity, measurement invariance | SPSS AMOS · R (lavaan) · SmartPLS |
| 04 | [Covariance-Based SEM (CB-SEM)](./Module_04_CB_SEM/) | Path models, full SEM, mediation/moderation, model comparison | SPSS AMOS · R (lavaan) · SmartPLS 4.0 |
| 05 | [Regression Analysis](./Module_05_Regression/) | Linear, multiple, logistic, ordinal regression; diagnostics | SPSS · R |
| 06 | [Case Studies](./Module_06_Case_Studies/) | Transportation mode choice, road safety, traveler behavior, survey research | SPSS · R · SmartPLS |

---

## Learning Outcomes

Upon completing this course, students will be able to:

1. **Design** rigorous quantitative surveys for transportation and behavioral research
2. **Perform** descriptive statistics and assess data quality
3. **Conduct** Exploratory Factor Analysis to identify underlying constructs
4. **Specify and test** measurement models using Confirmatory Factor Analysis
5. **Build and evaluate** structural equation models using CB-SEM
6. **Apply** regression techniques appropriate for transportation data
7. **Interpret and report** results following publication standards (APA/journal style)
8. **Use** SPSS, R, and SmartPLS 4.0 proficiently for all analyses

---

## Prerequisites

- Basic statistics (descriptive stats, hypothesis testing, correlation)
- Familiarity with survey research or data collection
- No advanced programming knowledge required (R scripts are fully annotated)

---

## Software Requirements

| Software | Version | Purpose | Cost |
|----------|---------|---------|------|
| **IBM SPSS Statistics** | 25+ | Descriptive stats, EFA, Regression | Licensed (university) |
| **SPSS AMOS** | 25+ | CFA, CB-SEM | Licensed (university) |
| **R** | 4.3+ | All analyses | Free / Open Source |
| **RStudio** | Latest | R IDE | Free |
| **SmartPLS** | 4.0 | PLS-SEM, CFA | Free (academic) |

See [Resources/Software_Installation_Guide.md](./Resources/Software_Installation_Guide.md) for installation instructions.

---

## Repository Structure

```
EFA_CFA_Course/
├── Module_00_Introduction/        # Foundations, research design, measurement
├── Module_01_Descriptive_Statistics/  # Descriptive stats, normality, reliability
├── Module_02_EFA/                 # Exploratory Factor Analysis
├── Module_03_CFA/                 # Confirmatory Factor Analysis
├── Module_04_CB_SEM/              # Covariance-Based Structural Equation Modeling
├── Module_05_Regression/          # Regression Analysis
├── Module_06_Case_Studies/        # Applied case studies
├── Datasets/                      # Sample datasets with codebooks
├── Resources/                     # References, glossary, software guides
└── README.md                      # This file
```

---

## How to Use This Course

**Recommended progression:**

```
Module 00 → Module 01 → Module 02 → Module 03 → Module 04
                                                    ↓
                     Module 06 (Case Studies) ← Module 05
```

Each module contains:
- 📖 **Lecture Notes** — Theory, concepts, and rationale
- 🔬 **SPSS Guide** — Step-by-step screenshots and instructions
- 💻 **R Script** — Fully annotated, ready-to-run code
- 📊 **SmartPLS Guide** — Where applicable
- 📝 **Exercises** — Practice problems with real-world datasets
- 📚 **References** — Key papers and textbooks

---

## Quick Start with the Sample Dataset

All modules use a common dataset: **Bangkok Urban Transportation Survey (BUTS)**
→ Download: [`Datasets/BUTS_main.csv`](./Datasets/BUTS_main.csv)
→ Codebook: [`Datasets/BUTS_codebook.md`](./Datasets/BUTS_codebook.md)

The dataset includes 450 respondents and covers:
- Travel behavior and mode choice
- Perceived safety, service quality, and environmental attitudes
- Socio-demographic variables

---

## Citation

If you use materials from this course, please cite:

```bibtex
@misc{hassan2025efacfa,
  author       = {Hassan, Mahbub},
  title        = {Advanced Statistical Methods for Transportation \& Behavioral Research:
                  EFA, CFA, CB-SEM, and Regression Analysis},
  year         = {2025},
  publisher    = {GitHub},
  institution  = {Chulalongkorn University},
  howpublished = {\url{https://github.com/mahbubchula/EFA_CFA-Course}},
}
```

---

## License

This course material is licensed under the [MIT License](./LICENSE).
© 2025 Mahbub Hassan, Chulalongkorn University

---

*Department of Civil Engineering · Faculty of Engineering · Chulalongkorn University · Bangkok, Thailand*
