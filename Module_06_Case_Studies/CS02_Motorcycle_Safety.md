---
title: "CS02: Motorcycle Safety"
parent: "06 · Applied Case Studies"
nav_order: 1
---

# Case Study 02: Motorcycle Safety Behavior
## Protection Motivation Theory + Ordinal Crash Severity Analysis

> **Module 06 | Case Studies**
> *Course: Advanced Statistical Methods for Transportation & Behavioral Research*
> *Instructor: Mahbub Hassan, Chulalongkorn University*

---

## Research Context

**Domain**: Road accident research, behavioral safety

**Research Questions**:
1. What psychological factors predict motorcycle safety behavior (helmet use, speed compliance)?
2. What road, environmental, and behavioral factors predict crash severity?

**Theoretical Frameworks**:
- **Protection Motivation Theory (PMT)**: Predicts safety behavior from threat and coping appraisals
- **Ordinal Regression**: For crash severity (ordered outcome: PDO → Minor → Serious → Fatal)

### PMT Model:
```
Threat Appraisal:
  Perceived Severity    ─┐
  Perceived Vulnerability─┼──→ Protection Motivation → Safety Behavior
                          │
Coping Appraisal:         │
  Self-Efficacy          ─┤
  Response Efficacy      ─┘
  Response Costs        ─── (negative path)
```

---

## Part A: PMT-Based SEM for Safety Behavior

### Research Design
- **Population**: Motorcycle riders in Bangkok
- **Sample**: n = 380 riders (recruited at gas stations and residential areas)
- **Instrument**: 30-item survey adapted from PMT scales
- **Outcome**: Motorcycle Safety Behavior (composite: helmet use + speed + safe following distance)

### Analytical Steps

**Step 1: EFA** → Confirmed 5-factor PMT structure
**Step 2: CFA** → Measurement model validated
**Step 3: SEM** → PMT structural model tested

### SEM Results Summary

| Hypothesis | Path | β | p | Supported? |
|-----------|------|---|---|-----------|
| H1 | Threat Severity → Threat Appraisal | 0.412 | <.001 | ✓ |
| H2 | Vulnerability → Threat Appraisal | 0.389 | <.001 | ✓ |
| H3 | Self-Efficacy → Coping Appraisal | 0.521 | <.001 | ✓ |
| H4 | Response Efficacy → Coping Appraisal | 0.478 | <.001 | ✓ |
| H5 | Response Costs → Coping Appraisal | −0.231 | <.001 | ✓ |
| H6 | Threat Appraisal → Protection Motivation | 0.341 | <.001 | ✓ |
| H7 | Coping Appraisal → Protection Motivation | 0.512 | <.001 | ✓ |
| H8 | Protection Motivation → Safety Behavior | 0.448 | <.001 | ✓ |

Model fit: χ²/df = 2.28, CFI = .961, TLI = .955, RMSEA = .058, SRMR = .052 ✓

**Key finding**: Coping appraisal (β = 0.512) is a stronger predictor of protection motivation than threat appraisal (β = 0.341), suggesting safety interventions should focus on self-efficacy and perceived effectiveness of safety equipment rather than merely raising fear.

---

## Part B: Crash Severity Analysis — Ordinal Logistic Regression

### Data
- **Source**: Police crash records (Bangkok Metropolitan Region, 3 years)
- **Sample**: 1,842 motorcycle crashes
- **Outcome**: Crash Severity (1=PDO, 2=Minor Injury, 3=Serious Injury, 4=Fatal)
- **Predictors**: Road characteristics, environmental factors, rider behavior, vehicle factors

### Descriptive Statistics

| Severity | n | % |
|---------|---|---|
| PDO (Property damage only) | 921 | 50.0% |
| Minor injury | 552 | 30.0% |
| Serious injury | 276 | 15.0% |
| Fatal | 93 | 5.0% |

### Ordinal Logistic Regression Results

```r
# R Code
library(MASS)
crash_model <- polr(Severity ~ SpeedLimit + RoadType + TimeOfDay +
                               RiderAge + Helmet + AlcoholInvolved +
                               Weather + LightCondition,
                    data = crash_data, Hess = TRUE, method = "logistic")
```

**Table: Ordinal Regression Results — Motorcycle Crash Severity Predictors**

| Predictor | B | OR | 95% CI | p |
|-----------|---|-----|--------|---|
| Speed limit (ref: ≤40km/h) | | | | |
| 60 km/h | 0.41 | 1.51 | [1.22, 1.87] | <.001 |
| 80 km/h | 0.78 | 2.18 | [1.74, 2.73] | <.001 |
| 100+ km/h | 1.25 | 3.49 | [2.71, 4.50] | <.001 |
| Road type: Expressway (ref: Local) | 0.62 | 1.86 | [1.41, 2.45] | <.001 |
| Night (ref: Daytime) | 0.54 | 1.72 | [1.38, 2.14] | <.001 |
| No helmet (ref: Helmet) | 1.18 | 3.25 | [2.58, 4.09] | <.001 |
| Alcohol involved (ref: None) | 0.87 | 2.39 | [1.82, 3.13] | <.001 |
| Rain (ref: Dry) | 0.33 | 1.39 | [1.09, 1.77] | .008 |
| Rider age (ref: 26-35) | | | | |
| 15-25 | 0.38 | 1.46 | [1.18, 1.81] | .001 |
| 56+ | 0.52 | 1.68 | [1.22, 2.31] | .002 |

**Proportional odds assumption**: Brant test χ²(64) = 71.8, p = .231 → Assumption not violated ✓

**Key findings**:
1. **Helmet non-use** is the strongest modifiable risk factor (OR = 3.25): riders not wearing helmets are 3.25 times more likely to experience a higher severity category
2. **Alcohol involvement** (OR = 2.39) and **high speed limits** (OR up to 3.49) are also major factors
3. Young (15–25) and old (56+) riders have elevated severity risk compared to middle-aged riders

---

## Part C: Multi-Level Analysis (Optional Extension)

If crash data is nested within road segments, use multi-level ordinal regression:

```r
library(ordinal)
mlm_model <- clmm(Severity ~ SpeedLimit + NoHelmet + Alcohol + Night +
                   (1 | RoadSegmentID),  # Random intercept per road segment
                  data = crash_data,
                  link = "logistic")
```

This accounts for the fact that multiple crashes on the same road segment are not independent.

---

## Summary of Methods Used in This Case Study

| Task | Method | Software |
|------|--------|---------|
| Scale validation | EFA + CFA | R (psych, lavaan) / AMOS |
| PMT model testing | CB-SEM | R (lavaan) / AMOS |
| Crash severity | Ordinal logistic regression | R (MASS::polr) / SPSS |
| Multi-level | Mixed ordinal | R (ordinal::clmm) |

---

## References

- Floyd, D. L., Prentice-Dunn, S., & Rogers, R. W. (2000). A meta-analysis of research on protection motivation theory. *Journal of Applied Social Psychology*, 30(2), 407–429.
- Lord, D., & Mannering, F. (2010). The statistical analysis of crash-frequency data. *Transportation Research Part A*, 44(5), 291–305.
- Moudon, A. V., et al. (2011). Exposure to the road environment and bicyclists' severity of injury. *Transportation Research Record*, 2247, 54–62.
- Rogers, R. W. (1975). A protection motivation theory of fear appeals and attitude change. *Journal of Psychology*, 91(1), 93–114.

---

*Next: [CS03 — Autonomous Vehicle Acceptance](./CS03_AV_Acceptance.md)*
