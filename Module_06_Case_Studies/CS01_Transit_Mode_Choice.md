---
title: "CS01: Transit Mode Choice"
parent: "06 · Applied Case Studies"
nav_order: 1
---

# Case Study 01: Urban Transit Mode Choice
## A Theory of Planned Behavior (TPB) Application

> **Module 06 | Case Studies**
> *Course: Advanced Statistical Methods for Transportation & Behavioral Research*
> *Instructor: Mahbub Hassan, Chulalongkorn University*

---

## Research Context

**Research Question**: What psychological and attitudinal factors influence urban commuters' intention to use public transit in Bangkok?

**Theoretical Framework**: Theory of Planned Behavior (Ajzen, 1991)
```
Attitude toward Transit (ATT)  ─┐
Subjective Norm (SN)            ├──→ Behavioral Intention (BI) ──→ Mode Choice (MC)
Perceived Behavioral Control    ─┘
(PBC)
```

**Extended model** adds:
- Perceived Safety (PS) as antecedent to Attitude
- Service Quality (SQ) as antecedent to Attitude

```
PS ──┐
SQ ──┼──→ ATT ──┐
                ├──→ BI ──→ MC
SN ─────────────┤
PBC ────────────┘
```

---

## Step 1: Data Overview

**Dataset**: BUTS (Bangkok Urban Transportation Survey)
- n = 450 respondents
- 5 constructs × 3–5 items each = 20 items total
- Plus socio-demographic variables

**Constructs and Items**:

| Construct | Items | Scale | Source |
|-----------|-------|-------|--------|
| Perceived Safety (PS) | PS1–PS4 | 5-pt Likert | Adapted from Cheng et al. (2019) |
| Service Quality (SQ) | SQ1–SQ4 | 5-pt Likert | SERVQUAL adapted |
| Attitude (ATT) | ATT1–ATT3 | 5-pt Semantic Differential | Ajzen (2002) |
| Subjective Norm (SN) | SN1–SN3 | 5-pt Likert | Ajzen (1991) |
| PBC | PBC1–PBC3 | 5-pt Likert | Ajzen (1991) |
| Behavioral Intention (BI) | BI1–BI3 | 5-pt Likert | Ajzen (1991) |

---

## Step 2: Descriptive Statistics

### Sample Profile
```
Total: 450 respondents
Gender: Male 58.9% (n=265), Female 41.1% (n=185)
Age: Mean = 33.2 years (SD = 9.8)
Primary mode: Car 40.0%, Motorcycle 21.1%, Transit 28.9%, Walk/Cycle 10.0%
```

### Descriptive Statistics for Scale Items

| Construct | Item | Mean | SD | Skew | Kurt |
|-----------|------|------|----|------|------|
| Perceived Safety | PS1 | 3.42 | 0.98 | −0.31 | −0.42 |
| | PS2 | 3.18 | 1.05 | −0.18 | −0.65 |
| | PS3 | 2.95 | 1.12 | 0.12 | −0.78 |
| | PS4 | 3.21 | 1.01 | −0.25 | −0.51 |
| Service Quality | SQ1 | 3.05 | 1.08 | 0.05 | −0.71 |
| ... | ... | ... | ... | ... | ... |

All items: |Skew| < 2, |Kurt| < 7 — normality assumption tenable.

---

## Step 3: EFA Results

### Factorability
- KMO = 0.874 (Meritorious) ✓
- Bartlett's χ²(190) = 2847.3, p < .001 ✓

### Number of Factors
- Parallel analysis: 5 factors
- Consistent with theory (PS, SQ, ATT, SN/PBC, BI)

### Pattern Matrix (PAF + Oblimin)

| Item | F1: PS | F2: SQ | F3: ATT | F4: SN/PBC | F5: BI |
|------|--------|--------|---------|-----------|--------|
| PS1 | .78 | | | | |
| PS2 | .72 | | | | |
| ATT1 | | | .80 | | |
| BI1 | | | | | .82 |
| ... | | | | | |

Factor alphas: 0.84, 0.81, 0.87, 0.79, 0.89

---

## Step 4: CFA — Measurement Model

### Model Specification
```r
cfa_tpb_model <- '
  PS  =~ PS1 + PS2 + PS3 + PS4
  SQ  =~ SQ1 + SQ2 + SQ3 + SQ4
  ATT =~ ATT1 + ATT2 + ATT3
  SN  =~ SN1 + SN2 + SN3
  PBC =~ PBC1 + PBC2 + PBC3
  BI  =~ BI1 + BI2 + BI3
'
```

### Model Fit
| Index | Value | Threshold | Result |
|-------|-------|-----------|--------|
| χ²/df | 2.41 | ≤ 3.0 | ✓ |
| CFI | 0.958 | ≥ 0.90 | ✓ |
| TLI | 0.951 | ≥ 0.90 | ✓ |
| RMSEA | 0.056 [.049, .064] | ≤ 0.08 | ✓ |
| SRMR | 0.049 | ≤ 0.08 | ✓ |

### Convergent Validity

| Construct | α | CR | AVE | √AVE |
|-----------|---|----|----|------|
| PS | 0.856 | 0.872 | 0.578 | 0.760 |
| SQ | 0.823 | 0.861 | 0.608 | 0.780 |
| ATT | 0.874 | 0.882 | 0.713 | 0.845 |
| SN | 0.799 | 0.821 | 0.607 | 0.779 |
| PBC | 0.812 | 0.835 | 0.628 | 0.793 |
| BI | 0.891 | 0.918 | 0.736 | 0.858 |

All loadings ≥ 0.65. All AVE ≥ 0.50. All CR ≥ 0.80. ✓

### Discriminant Validity (HTMT)

| | PS | SQ | ATT | SN | PBC |
|--|---|----|-----|----|-----|
| SQ | 0.521 | | | | |
| ATT | 0.612 | 0.584 | | | |
| SN | 0.341 | 0.412 | 0.459 | | |
| PBC | 0.298 | 0.358 | 0.491 | 0.523 | |
| BI | 0.631 | 0.712 | 0.768 | 0.541 | 0.612 |

All HTMT < 0.85 ✓ — Discriminant validity established.

---

## Step 5: SEM — Structural Model

### Hypothesized Paths

| H | Path | β | SE | t | p | Supported? |
|---|------|---|-----|---|---|-----------|
| H1 | PS → ATT | 0.298 | 0.052 | 5.73 | <.001 | ✓ |
| H2 | SQ → ATT | 0.312 | 0.048 | 6.50 | <.001 | ✓ |
| H3 | ATT → BI | 0.421 | 0.055 | 7.65 | <.001 | ✓ |
| H4 | SN → BI | 0.189 | 0.044 | 4.30 | <.001 | ✓ |
| H5 | PBC → BI | 0.245 | 0.047 | 5.21 | <.001 | ✓ |
| H6 | BI → MC | 0.512 | 0.058 | 8.83 | <.001 | ✓ |

Model fit: χ²/df = 2.51, CFI = .952, TLI = .944, RMSEA = .059, SRMR = .053 ✓
R²(ATT) = 0.284, R²(BI) = 0.418, R²(MC) = 0.262

### Mediation Analysis (ATT mediating PS/SQ → BI)

| Path | Indirect β | 95% BCa CI | Conclusion |
|------|-----------|-----------|-----------|
| PS → ATT → BI | 0.125 | [0.081, 0.172] | Partial mediation ✓ |
| SQ → ATT → BI | 0.131 | [0.088, 0.179] | Partial mediation ✓ |

---

## Step 6: Discussion and Implications

### Key Findings
1. **Perceived Safety** and **Service Quality** indirectly influence behavioral intention through **Attitude** — improving safety perception and service quality enhances positive attitudes toward transit use.

2. **All three TPB components** (Attitude, Subjective Norm, PBC) significantly predict behavioral intention, with Attitude being the strongest predictor (β = 0.421).

3. **Behavioral Intention** is a strong predictor of actual mode choice (β = 0.512), validating the TPB framework in Bangkok context.

### Policy Implications for Transportation Agencies
- **Short-term**: Improve perceived safety at stops and on routes (lighting, security)
- **Medium-term**: Enhance service quality (punctuality, cleanliness, frequency)
- **Long-term**: Targeted campaigns to shift social norms toward transit use

---

## Step 7: Publication Reporting Template

**Sample Results Section:**

*Measurement Model*: CFA confirmed a six-factor model (χ²/df = 2.41, CFI = .958, TLI = .951, RMSEA = .056 [.049, .064], SRMR = .049). All factor loadings were significant (p < .001) and ranged from 0.65 to 0.86. Average variance extracted (AVE) exceeded 0.50 for all constructs, and composite reliability (CR) exceeded 0.82 for all constructs, supporting convergent validity. HTMT ratios were all below 0.85, supporting discriminant validity.

*Structural Model*: The structural model demonstrated acceptable fit (χ²/df = 2.51, CFI = .952, RMSEA = .059). Hypotheses H1–H6 were all supported (see Table X). The model explained 41.8% of variance in behavioral intention and 26.2% in actual mode choice.

---

## References

- Ajzen, I. (1991). The theory of planned behavior. *Organizational Behavior and Human Decision Processes*, 50(2), 179–211.
- Cheng, Y.-H., Chen, S.-Y., & Chen, P.-C. (2019). Examining the service quality of metro transit systems using an integrated approach. *Transportation Research Part A*, 119, 22–33.
- Hair, J. F., Black, W. C., Babin, B. J., & Anderson, R. E. (2019). *Multivariate Data Analysis* (8th ed.). Cengage.

---

*Next Case Study: [CS02 — Motorcycle Safety Behavior](./CS02_Motorcycle_Safety.md)*
