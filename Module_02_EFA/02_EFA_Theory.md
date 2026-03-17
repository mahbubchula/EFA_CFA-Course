---
title: "Theory"
parent: "02 · Exploratory Factor Analysis"
nav_order: 1
---

# 02 — Exploratory Factor Analysis: Complete Theory and Guide

> **Module 02 | Exploratory Factor Analysis**
> *Course: Advanced Statistical Methods for Transportation & Behavioral Research*
> *Instructor: Mahbub Hassan, Chulalongkorn University*

---

## 1. What is Exploratory Factor Analysis?

**Exploratory Factor Analysis (EFA)** is a statistical procedure used to identify the underlying **latent factor structure** in a set of observed variables (items). It is "exploratory" because you do not specify the structure in advance — you let the data reveal how items cluster.

### The Core Idea

```
Observed Items           Latent Factors

PS1: "I feel safe..."  ─┐
PS2: "Roads are safe"  ─┼──→  Factor 1: Perceived Safety
PS3: "Crime is low"    ─┘

SQ1: "Bus is on time"  ─┐
SQ2: "Bus is clean"    ─┼──→  Factor 2: Service Quality
SQ3: "Staff helpful"   ─┘

BI1: "I plan to use..."─┐
BI2: "I will use..."   ─┼──→  Factor 3: Behavioral Intention
BI3: "I intend to..."  ─┘
```

**Factor loadings** represent the correlation between each item and the factor. Higher loadings = stronger relationship.

---

## 2. EFA vs. Principal Component Analysis (PCA)

A critical distinction often confused:

| Criterion | EFA (Factor Analysis) | PCA (Component Analysis) |
|-----------|----------------------|--------------------------|
| **Purpose** | Identify latent factors | Reduce data dimensionality |
| **Model** | Items explained by latent factors + unique variance | Items fully explained by components |
| **Variance** | Common variance only | Total variance (common + unique) |
| **Assumption** | Latent factors exist and cause items | No causal assumption |
| **Use in research** | Construct validation, scale development | Data reduction, index creation |
| **Preferred for** | Behavioral/survey research | Composite scores, engineering indices |

**Recommendation for behavioral/transportation survey research**: Use **Principal Axis Factoring (PAF)** or **Maximum Likelihood (ML)** extraction — NOT PCA — when your goal is to identify latent psychological or behavioral constructs.

PCA is appropriate when you want a composite score (e.g., a built environment index from multiple physical measurements).

---

## 3. The EFA Model

For item *j* and factor *k*:

```
Xj = λj1 F1 + λj2 F2 + ... + λjk Fk + δj

Where:
  Xj   = observed item j (standardized)
  λjk  = factor loading of item j on factor k
  Fk   = common factor k
  δj   = unique variance (specific + error)
```

**Communality (h²)**: Proportion of item variance explained by common factors:
```
h²j = λj1² + λj2² + ... + λjk²
```

Low communality (< 0.30) suggests an item does not share much variance with the common factors — consider removing it.

---

## 4. EFA Assumptions and Prerequisites

### 4.1 Sample Size
| Criterion | Threshold | Notes |
|-----------|-----------|-------|
| Minimum N | N ≥ 100 | Absolute minimum |
| Recommended | N ≥ 200 | Stable factor loadings |
| Items:respondents ratio | 1:5 to 1:10 | Per item in EFA |
| Comrey & Lee (1992) | N ≥ 300 | Good |
| | N ≥ 500 | Very good |

For a 20-item survey: minimum N = 100–200; recommended N ≥ 200.

### 4.2 Scale Level
Variables should be **continuous or treated as interval-level**. Likert scales with 5+ response options are generally treated as interval for EFA.

### 4.3 Factorability (Is FA appropriate?)

**Kaiser-Meyer-Olkin (KMO) Measure of Sampling Adequacy:**
```
        Σ Σ rij²
KMO = ──────────────────────
       Σ Σ rij² + Σ Σ aij²
```
Where rij = off-diagonal correlation, aij = partial correlation

| KMO Value | Interpretation |
|-----------|---------------|
| 0.90+ | Marvelous |
| 0.80–0.89 | Meritorious |
| 0.70–0.79 | Middling |
| 0.60–0.69 | Mediocre |
| 0.50–0.59 | Miserable |
| < 0.50 | Unacceptable — do NOT proceed |

**Bartlett's Test of Sphericity:**
Tests H₀: correlation matrix = identity matrix (items are uncorrelated).
- **p < 0.05**: Reject H₀ → significant intercorrelations exist → EFA is appropriate
- **p ≥ 0.05**: Items too uncorrelated → EFA is not appropriate

### 4.4 No Extreme Multicollinearity
- Determinant of correlation matrix > 0.00001 (SPSS checks this automatically)
- If determinant ≈ 0: some items are near-perfectly correlated → remove one from each pair

### 4.5 No Excessive Missing Data
< 5% missing per item; impute if needed (see Module 01)

---

## 5. Factor Extraction Methods

### 5.1 Principal Axis Factoring (PAF)
- Estimates **common variance** only (places communality estimates on diagonal)
- **Best choice** for behavioral research with latent constructs
- Iteratively refines communality estimates

### 5.2 Maximum Likelihood (ML)
- Statistically optimal when data are multivariate normal
- Allows chi-square goodness-of-fit test
- Sensitive to non-normality
- Use when normality is established; yields fit statistics

### 5.3 Principal Components Analysis (PCA)
- Not truly EFA (accounts for total variance)
- Appropriate for data reduction
- Produces slightly higher loadings than PAF

**Our recommendation**: Use **PAF** for most behavioral/transportation research. Use **ML** when you need fit statistics.

---

## 6. Determining the Number of Factors

Using **multiple criteria** is strongly recommended:

### 6.1 Kaiser Criterion (Eigenvalue > 1)
- Extract factors with eigenvalue > 1.0
- Simple but **tends to over-extract** (especially with many items)
- Use as initial guide only

### 6.2 Scree Plot (Cattell, 1966)
- Plot eigenvalues in descending order
- Look for "elbow" (point where slope flattens)
- Extract factors above the elbow
- **Subjective** — use with parallel analysis

### 6.3 Parallel Analysis (Horn, 1965) — BEST METHOD
- Compares actual eigenvalues to eigenvalues from random data matrices
- Extract factors where actual eigenvalue > random eigenvalue
- Most accurate method for determining factor count
- Available in R (`psych::fa.parallel`) — not standard in SPSS

### 6.4 Interpretability
- The extracted factors should be **theoretically meaningful**
- If a factor has only 1–2 items, it is unstable
- Minimum 3 items per factor recommended

**Decision rule**: Parallel analysis determines the number; confirm with scree plot and theoretical interpretation.

---

## 7. Factor Rotation

After extraction, factors are rotated to achieve **simple structure** (each item loads highly on one factor, low on others), making interpretation easier.

### 7.1 Orthogonal Rotation (Factors are UNCORRELATED)

**Varimax** (most common orthogonal method):
- Maximizes variance of squared loadings within factors
- Simple, widely understood
- Use when factors are theoretically independent

**When to use**: Factors representing truly independent dimensions (rare in behavioral research)

### 7.2 Oblique Rotation (Factors ARE CORRELATED) ← Recommended for behavioral research

**Direct Oblimin** (most common oblique method):
- Allows factors to correlate
- More realistic for behavioral constructs (e.g., Safety and Service Quality likely correlate)
- Produces *pattern matrix* (direct effect) and *structure matrix* (total correlation)

**Promax**:
- Faster alternative to Oblimin
- Slightly less precise but useful for large datasets

**Which matrix to report with oblique rotation?**
→ Report the **Pattern Matrix** (loadings after accounting for factor correlations)
→ Also report the **factor correlation matrix** (Phi matrix)

**Decision guide:**
```
Are your factors expected to correlate? (Almost always YES in behavioral research)
    YES → Use Direct Oblimin (or Promax)
    NO  → Use Varimax
```

---

## 8. Interpreting the Pattern Matrix

### 8.1 Factor Loading Thresholds

| Loading | Interpretation |
|---------|---------------|
| ≥ 0.71 | Excellent |
| ≥ 0.63 | Very good |
| ≥ 0.55 | Good |
| ≥ 0.45 | Fair |
| ≥ 0.32 | Minimum (often used as cutoff) |

**Practical cutoff**: ≥ 0.40 is the most common threshold in transportation and behavioral research. Items with loading < 0.40 are usually dropped.

### 8.2 Cross-Loading Problem

An item that loads ≥ 0.30 (or ≥ 0.32) on TWO or more factors:

```
Example:
            Factor 1   Factor 2
Safety1       0.72       0.12    ✓ Clear loading on Factor 1
Safety2       0.65       0.08    ✓ Clear
Service1      0.15       0.71    ✓ Clear loading on Factor 2
Ambiguous1    0.52       0.44    ✗ Cross-loading — problematic!
```

**What to do with cross-loading items?**
1. Check the item wording — is it truly ambiguous?
2. If difference < 0.10 between highest and second loadings → remove item
3. Consider theoretical alignment to make a decision

### 8.3 Communalities

Items with communality < 0.30 contribute little to the factor solution:

```
Item     Communality    Decision
PS1        0.71         ✓ Keep
PS2        0.68         ✓ Keep
PS3        0.52         ✓ Keep
PS4        0.24         ✗ Low — consider removing
```

---

## 9. Step-by-Step EFA Workflow

```
Step 1: Prepare data (Module 01 complete)
        ↓
Step 2: Check factorability
        → KMO ≥ 0.60
        → Bartlett's p < 0.05
        → Determinant > 0.00001
        ↓
Step 3: Run EFA (PAF extraction, no rotation first)
        → Examine eigenvalues
        → Examine scree plot
        → Run parallel analysis
        ↓
Step 4: Decide number of factors (parallel analysis + scree + interpretability)
        ↓
Step 5: Re-run EFA with specified number of factors
        → Use Oblimin rotation (if factors are expected to correlate)
        ↓
Step 6: Examine pattern matrix
        → Identify items with loadings < 0.40 → remove
        → Identify cross-loading items → remove or reassign
        → Check communalities (< 0.30 → consider removing)
        ↓
Step 7: Re-run EFA with retained items
        → Repeat until clean solution
        ↓
Step 8: Name factors based on item content
        ↓
Step 9: Compute Cronbach's alpha for each factor
        ↓
Step 10: Prepare EFA results table for publication
         ↓
Step 11: Proceed to CFA with DIFFERENT sample (or randomly split)
```

---

## 10. Reporting EFA Results

### Publication Table Template

**Table X. Exploratory Factor Analysis — Pattern Matrix**

| Item | Description | F1: Safety | F2: Quality | F3: Intention | h² |
|------|------------|-----------|-------------|--------------|-----|
| PS1 | I feel safe using transit | **0.78** | 0.11 | 0.05 | 0.65 |
| PS2 | Roads I travel are safe | **0.72** | 0.08 | 0.12 | 0.57 |
| PS3 | Feel protected from crime | **0.65** | 0.15 | 0.09 | 0.51 |
| PS4 | Traffic behavior is safe | **0.61** | 0.22 | 0.08 | 0.49 |
| SQ1 | Transit arrives on time | 0.14 | **0.74** | 0.07 | 0.62 |
| SQ2 | Transit is clean | 0.08 | **0.79** | 0.11 | 0.68 |
| SQ3 | Staff are helpful | 0.18 | **0.68** | 0.15 | 0.55 |
| BI1 | I plan to use transit | 0.09 | 0.12 | **0.82** | 0.71 |
| BI2 | I will use transit next week | 0.11 | 0.08 | **0.76** | 0.63 |
| BI3 | I intend to use more | 0.15 | 0.19 | **0.71** | 0.58 |
| **Eigenvalue** | | 3.82 | 2.95 | 2.41 | |
| **% Variance** | | 38.2% | 29.5% | 24.1% | |
| **Cumulative %** | | 38.2% | 67.7% | 91.8% | |
| **Cronbach's α** | | 0.84 | 0.81 | 0.87 | |

*Note*. Extraction: Principal Axis Factoring; Rotation: Direct Oblimin.
Factor loadings ≥ 0.40 are bolded. n = 450.
Factor correlation matrix: F1-F2 = 0.38, F1-F3 = 0.42, F2-F3 = 0.45.

---

## 11. Common EFA Mistakes to Avoid

| Mistake | Problem | Solution |
|---------|---------|---------|
| Using PCA instead of PAF | PCA doesn't model latent variables properly | Use PAF or ML extraction |
| Using Varimax by default | Most behavioral constructs correlate | Use Oblimin; check factor correlations |
| Ignoring parallel analysis | Eigenvalue > 1 over-extracts | Always run parallel analysis |
| Reporting structure matrix with oblique | Pattern matrix shows direct effects | Report pattern matrix for oblique solutions |
| Not reporting item removal decisions | Lacks transparency | Document why each item was removed |
| Using EFA sample for CFA | Capitalization on chance | Split sample or collect new data |

---

## 12. EFA in Transportation Research — Example Applications

### Example 1: Road Safety Behavior Scale (Accident Research)
- 25 initial items on risk perception, safety attitudes, compliance
- EFA revealed 4 factors: Risk Perception, Safety Motivation, Rule Compliance, Peer Influence
- Reduced to 18 items for CFA and SEM

### Example 2: Transit Service Quality (Survey Research)
- 20 items adapted from SERVQUAL
- EFA in Bangkok context revealed 4 factors vs. SERVQUAL's 5
- Local cultural factors merged "responsiveness" and "empathy" into one factor

### Example 3: Motorcycle Safety Attitudes (Behavioral Research)
- New 22-item scale developed
- EFA revealed 3 clear factors: Personal Invulnerability, Risk Normalization, Safety Compliance
- Used for subsequent CFA and PMT-based SEM

---

## References

- Brown, T. A. (2015). *Confirmatory Factor Analysis for Applied Research* (2nd ed.). Guilford.
- Cattell, R. B. (1966). The scree test for the number of factors. *Multivariate Behavioral Research*, 1(2), 245–276.
- Comrey, A. L., & Lee, H. B. (1992). *A First Course in Factor Analysis* (2nd ed.). Erlbaum.
- Costello, A. B., & Osborne, J. (2005). Best practices in exploratory factor analysis: Four recommendations for getting the most from your analysis. *Practical Assessment, Research & Evaluation*, 10(7), 1–9.
- Hair, J. F., Black, W. C., Babin, B. J., & Anderson, R. E. (2019). *Multivariate Data Analysis* (8th ed.). Cengage.
- Horn, J. L. (1965). A rationale and test for the number of factors in factor analysis. *Psychometrika*, 30, 179–185.
- Lorenzo-Seva, U., & Ferrando, P. J. (2006). FACTOR: A computer program to fit the exploratory factor analysis model. *Behavior Research Methods*, 38(1), 88–91.

---

*See also: [02_SPSS_Guide.md](./02_SPSS_Guide.md) | [02_R_Script.R](./02_R_Script.R)*
