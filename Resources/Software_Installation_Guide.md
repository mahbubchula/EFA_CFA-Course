---
title: "Software Installation"
nav_order: 9
---

# Software Installation Guide

> **Course: Advanced Statistical Methods for Transportation & Behavioral Research**
> *Instructor: Mahbub Hassan, Chulalongkorn University*

---

## 1. R and RStudio

### Step 1: Install R
1. Go to: https://cran.r-project.org/
2. Click **Download R for Windows** (or your OS)
3. Click **base** → Download the latest version (R 4.3.0+)
4. Run the installer with default settings

### Step 2: Install RStudio
1. Go to: https://posit.co/download/rstudio-desktop/
2. Download **RStudio Desktop (Free)**
3. Install with default settings

### Step 3: Install Required R Packages
Open RStudio and run:

```r
# Core packages for this course
install.packages(c(
  # Data manipulation & visualization
  "tidyverse",
  "ggplot2",
  "corrplot",

  # Psychometric & factor analysis
  "psych",
  "GPArotation",
  "nFactors",

  # SEM / CFA
  "lavaan",
  "semPlot",
  "semTools",
  "lavaanPlot",

  # Regression
  "car",
  "lmtest",
  "MASS",
  "nnet",
  "ordinal",
  "effects",

  # Missing data
  "mice",
  "naniar",

  # Multivariate normality
  "MVN",

  # Reporting
  "broom",
  "performance",
  "flextable",
  "knitr"
))
```

Estimated install time: 5–10 minutes.

---

## 2. IBM SPSS Statistics

### Availability at Chulalongkorn University
- SPSS is available through the university's site license
- Contact CU IT or your department for access
- Alternatively: SPSS 30-day trial available at ibm.com

### Recommended Version
SPSS Statistics 25 or later (SPSS 27+ preferred for full features)

### SPSS AMOS (for CFA/SEM)
- AMOS is a separate add-on to SPSS
- Available with SPSS subscription or standalone
- Used in Module 03 and 04

---

## 3. SmartPLS 4.0

### Download
1. Go to: https://www.smartpls.com/
2. Click **Download SmartPLS 4**
3. Register for a **free academic license** (requires university email)

### Academic License
- Free for academic/research use
- Full features available
- Requires periodic renewal (annual)

### System Requirements
- Windows 7/10/11 or macOS
- Java Runtime Environment (JRE) 11+
- RAM: 4 GB minimum (8 GB recommended for large models)

---

## 4. Setting Up Your Working Directory

### For R
```r
# Set working directory to course folder
setwd("E:/06_GitHub_Repo/03_Archive/EFA_CFA_Course")

# Or use RStudio Projects (recommended)
# File → New Project → Existing Directory → Browse to course folder
```

### For SPSS
When running SPSS syntax, adjust file paths:
```spss
* Change this path to your actual course folder
CD 'E:\06_GitHub_Repo\03_Archive\EFA_CFA_Course'.
```

---

## 5. Verify Installation

Run this R code to verify all key packages work:

```r
# Test all critical packages
test_packages <- function() {
  pkgs <- c("psych", "lavaan", "semPlot", "semTools",
            "GPArotation", "tidyverse", "car", "MASS")
  results <- sapply(pkgs, function(p) {
    tryCatch({
      library(p, character.only = TRUE)
      cat("✓", p, "\n")
      TRUE
    }, error = function(e) {
      cat("✗", p, "— FAILED:", e$message, "\n")
      FALSE
    })
  })
  cat("\n", sum(results), "/", length(results), "packages loaded successfully\n")
}

test_packages()
```
