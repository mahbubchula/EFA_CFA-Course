---
title: "04 · Exercises"
parent: "04 · Covariance-Based SEM"
nav_order: 5
---

# Module 04 — Exercises: Covariance-Based SEM
{: .no_toc }

**Module 04 · Covariance-Based SEM**
{: .label .label-purple }

---

## Instructions

Use the **BUTS dataset** (`BUTS_main.csv`) for all exercises. Complete each exercise using both software packages (AMOS or R/lavaan, and SmartPLS 4.0) where indicated.

{: .note }
> Before starting these exercises, ensure you have completed Module 03 (CFA) and have a well-fitting measurement model.

---

## Exercise 1 — Draw the Structural Model (AMOS or R/lavaan)

**Objective**: Specify and estimate a structural equation model.

**Instructions**:

1. Starting from your Module 03 CFA measurement model, add the following structural paths:
   - `PerceivedSafety → BehavioralIntention`
   - `ServiceQuality → BehavioralIntention`
   - `EnvAttitude → BehavioralIntention`
   - `BehavioralIntention → ActualBehavior`

2. Estimate the model and record all fit indices.

3. Complete this table:

| Fit Index | Value | Criterion | Met? |
|-----------|-------|-----------|------|
| χ²/df | | < 3.0 | |
| CFI | | > .95 | |
| TLI | | > .95 | |
| RMSEA | | < .06 | |
| SRMR | | < .08 | |

4. How does the structural model fit compare to the CFA measurement model fit? Why might there be a difference?

**Expected output**: Path diagram with standardized coefficients, model fit summary table.

---

## Exercise 2 — Interpret Path Coefficients

**Objective**: Report and interpret structural path coefficients.

**Instructions**:

Using your Exercise 1 model output, complete the following hypothesis testing table:

| Hypothesis | Path | β | SE | CR/t | p-value | Supported? |
|-----------|------|---|----|------|---------|-----------|
| H1 | PS → BI | | | | | |
| H2 | SQ → BI | | | | | |
| H3 | EA → BI | | | | | |
| H4 | BI → AB | | | | | |

**Questions**:

a) Which predictor has the strongest effect on Behavioral Intention? Interpret the meaning of this path in the context of urban transportation behavior.

b) What percentage of variance in Behavioral Intention is explained by the three predictors (PS, SQ, EA)? Report and interpret the R² value.

c) Write a paragraph summarizing the structural results in the style of an academic journal paper.

---

## Exercise 3 — Direct Effect on Actual Behavior

**Objective**: Test alternative model specifications.

**Instructions**:

1. Add a direct path from `PerceivedSafety → ActualBehavior` to your model.

2. Re-estimate the model. Record the results:

| Path | β | SE | p-value |
|------|---|----|---------|
| PS → AB (direct) | | | |
| BI → AB | | | |

3. Compare the model fit of:
   - Model A: without PS → AB direct path
   - Model B: with PS → AB direct path

| | Model A | Model B | Δ |
|-|---------|---------|---|
| χ² | | | |
| df | | | |
| CFI | | | |
| RMSEA | | | |
| AIC | | | |

4. Based on chi-square difference test (Δχ², Δdf = 1), is adding the direct path justified? Use criterion: significant if Δχ² > 3.84 (p < .05).

---

## Exercise 4 — Mediation Analysis

**Objective**: Test for mediation using bootstrapping.

**Instructions**:

Using Model B from Exercise 3 (with PS → BI → AB path), test whether `BehavioralIntention` mediates the effect of each antecedent on `ActualBehavior`.

1. Run bootstrapping with 2000 samples (or 5000 in SmartPLS).

2. Complete the mediation table:

| Indirect Path | β_indirect | 95% BCa CI | p-value | Mediation Type |
|--------------|-----------|-----------|---------|----------------|
| PS → BI → AB | | [, ] | | |
| SQ → BI → AB | | [, ] | | |
| EA → BI → AB | | [, ] | | |

3. Determine the mediation type for each path:
   - **No mediation**: indirect effect not significant
   - **Full mediation**: indirect significant, direct not significant (or no direct path)
   - **Partial mediation**: both indirect and direct significant

4. Write a results paragraph for the mediation findings following Baron & Kenny (1986) criteria AND the bootstrapping approach.

---

## Exercise 5 — Model Comparison (CB-SEM vs. PLS-SEM)

**Objective**: Understand the differences between CB-SEM and PLS-SEM approaches.

**Instructions**:

1. Estimate the same structural model (Exercise 1) in SmartPLS 4.0 using PLS-SEM.

2. Complete the comparison table:

| Results | CB-SEM (lavaan/AMOS) | PLS-SEM (SmartPLS) |
|---------|---------------------|-------------------|
| **Measurement Model** | | |
| AVE (mean across constructs) | | |
| CR (mean across constructs) | | |
| **Structural Model** | | |
| β: PS → BI | | |
| β: SQ → BI | | |
| β: EA → BI | | |
| β: BI → AB | | |
| R² (BI) | | |
| R² (AB) | | |
| **Model Fit** | | |
| CFI / — | | |
| RMSEA / SRMR | | |

3. Discussion questions:
   a) Are the path coefficients similar or different between the two approaches? Why?
   b) CB-SEM provides CFI and RMSEA — PLS-SEM provides R² and Q². Why is this difference consistent with the philosophical differences between the two approaches?
   c) Under what circumstances would you recommend PLS-SEM over CB-SEM for transportation research?

---

## Exercise 6 — Multi-Group Analysis (Advanced)

**Objective**: Test whether the structural model is invariant across groups.

**Instructions**:

1. Split the BUTS dataset by gender (or generate two groups using the `gender` variable).

2. In R/lavaan, estimate the multi-group model:

```r
# Configural model (no constraints)
fit_configural <- cfa(model, data = BUTS_data,
                      group = "gender")

# Metric model (equal loadings)
fit_metric <- cfa(model, data = BUTS_data,
                  group = "gender",
                  group.equal = "loadings")

# Scalar model (equal loadings + intercepts)
fit_scalar <- cfa(model, data = BUTS_data,
                  group = "gender",
                  group.equal = c("loadings", "intercepts"))
```

3. Use `lavTestScore()` and `compareFit()` to compare models.

4. Complete the invariance table:

| Model | CFI | RMSEA | ΔCFI | ΔRMSEA | Invariance? |
|-------|-----|-------|------|--------|------------|
| Configural | | | — | — | — |
| Metric | | | | | |
| Scalar | | | | | |

5. **Criterion**: Metric invariance is supported if ΔCFI < .010 and ΔRMSEA < .015.

6. Can you meaningfully compare path coefficients across male and female groups? Justify your answer.

---

## Exercise 7 — Write-Up Practice

**Objective**: Practice writing a publication-quality SEM results section.

**Instructions**:

Based on your Exercise 1–4 results, write a complete **Results section** for a mock journal paper titled:

*"Understanding Urban Transit Use Intentions: A Structural Equation Modeling Approach"*

Your results section should include:
1. **Measurement model assessment** (1 paragraph + Table showing loadings, α, CR, AVE, HTMT)
2. **Structural model results** (1–2 paragraphs + path diagram/table)
3. **Mediation analysis** (1 paragraph + table of indirect effects)

**Word count**: Aim for 400–600 words.

**Evaluation criteria**:
- [ ] Correct reporting of all fit indices
- [ ] β, SE, t/CR, p-value reported for all paths
- [ ] R² values discussed
- [ ] Mediation correctly classified (partial/full)
- [ ] APA citation of software (AMOS, lavaan, SmartPLS)
- [ ] Academic writing tone

---

## Answer Hints

{: .note }
> These are approximate expected values from the BUTS dataset. Your exact values may vary slightly depending on missing data handling.

**Exercise 1 — Expected Fit**:
- CFI ≈ .975–.985
- RMSEA ≈ .020–.035
- SRMR ≈ .040–.055

**Exercise 2 — Expected Paths (standardized)**:
- PS → BI: β ≈ .28–.35
- SQ → BI: β ≈ .25–.32
- EA → BI: β ≈ .22–.28
- BI → AB: β ≈ .45–.55

**Exercise 4 — Expected Indirect Effects**:
- PS → BI → AB: β ≈ .13–.18 (significant)
- SQ → BI → AB: β ≈ .12–.17 (significant)
- EA → BI → AB: β ≈ .10–.15 (significant)

---

*[← Back to Module 04 Overview](./README.md)*
