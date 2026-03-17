# 00 — Measurement Theory: Constructs, Indicators, and Scales

> **Module 00 | Introduction & Foundations**
> *Course: Advanced Statistical Methods for Transportation & Behavioral Research*
> *Instructor: Mahbub Hassan, Chulalongkorn University*

---

## 1. What is Measurement?

**Measurement** is the process of assigning numbers to objects or events according to rules. In behavioral and transportation research, we measure things that cannot be directly counted or weighed — attitudes, perceptions, intentions, and behavioral tendencies.

**The measurement challenge:**
```
We want to measure:    → "Attitude toward cycling"
But we can only see:   → Responses to 5 Likert-scale questions
```

Good measurement means the gap between what we want to measure and what we actually measure is minimized.

---

## 2. Classical Test Theory (CTT)

The foundation of measurement in social science is **Classical Test Theory**:

```
Observed Score (X) = True Score (T) + Error (E)
```

- **True Score (T)**: The "real" value of the construct for a person
- **Error (E)**: Random measurement error (e.g., misreading a question, fatigue)
- **Reliability** in CTT = the ratio of true score variance to observed score variance

**Implications:**
- Single items are unreliable (dominated by error)
- **Multiple items per construct** average out random error → more reliable

---

## 3. Reliability

Reliability refers to the **consistency** of measurement.

### 3.1 Types of Reliability
| Type | Definition | Common Index |
|------|-----------|-------------|
| **Internal Consistency** | Do items in a scale correlate? | Cronbach's α, McDonald's ω |
| **Test-Retest** | Same results at different times? | Pearson correlation |
| **Inter-Rater** | Same results across raters? | Cohen's Kappa, ICC |
| **Parallel Forms** | Same results from equivalent forms? | Pearson correlation |

### 3.2 Cronbach's Alpha (α)
The most widely used reliability index:

```
         k        ΣSi²
α = ―――――――― × (1 - ―――― )
       k - 1        St²
```

Where:
- k = number of items
- Si² = variance of item i
- St² = variance of total score

**Interpretation thresholds:**
| α value | Interpretation |
|---------|---------------|
| ≥ 0.90 | Excellent |
| 0.80–0.89 | Good |
| 0.70–0.79 | Acceptable |
| 0.60–0.69 | Questionable |
| < 0.60 | Poor (generally unacceptable) |

**Note**: α ≥ 0.70 is the standard threshold in most transportation research journals.

### 3.3 Composite Reliability (CR) — Preferred in CFA/SEM
```
            (Σλi)²
CR = ―――――――――――――――――
      (Σλi)² + Σ(1 - λi²)
```
Where λi = standardized factor loading of item i.

**CR ≥ 0.70** is acceptable; **CR ≥ 0.80** is good.

---

## 4. Validity

Validity refers to whether we are measuring **what we intend to measure**.

### 4.1 Types of Validity

#### Content Validity
- Do items adequately represent the content domain of the construct?
- Assessed through expert review and literature-based item generation
- Reported qualitatively; some use the **Content Validity Index (CVI)**

#### Construct Validity — Assessed in CFA
Consists of:

**a) Convergent Validity**
Items measuring the same construct should correlate highly.
```
Indicators:  AVE ≥ 0.50 (Average Variance Extracted)
             Factor loadings ≥ 0.50 (ideally ≥ 0.70)
             CR ≥ 0.70
```

**b) Discriminant Validity**
Constructs measuring different things should NOT correlate too highly.
```
Traditional criterion:  √AVE > inter-construct correlation
HTMT criterion:         HTMT ratio < 0.85 (Henseler et al., 2015)
                        (preferred modern approach)
```

**c) Nomological Validity**
Does the construct relate to other constructs as theory predicts?
Assessed through SEM — hypothesized paths should be significant.

#### Criterion Validity
- **Concurrent**: Does the measure correlate with an established measure now?
- **Predictive**: Does the measure predict future outcomes?

---

## 5. Average Variance Extracted (AVE)

AVE measures the average variance in indicators explained by a construct:

```
         Σλi²
AVE = ―――――――――――――
      Σλi² + Σ(1 - λi²)
```

**AVE ≥ 0.50** means the construct explains more than half the variance in its indicators — a sign of good convergent validity.

| Criterion | Threshold | What it tests |
|-----------|-----------|---------------|
| **Factor loading** | ≥ 0.50 (ideally ≥ 0.70) | Item-level convergent validity |
| **AVE** | ≥ 0.50 | Construct-level convergent validity |
| **CR** | ≥ 0.70 | Internal consistency |
| **HTMT** | < 0.85 | Discriminant validity |

---

## 6. Reflective vs. Formative Measurement Models

This is one of the most important distinctions in factor analysis and SEM.

### 6.1 Reflective Model (Most Common)

```
                    ┌── Item 1 (+ error)
Latent Construct ───┼── Item 2 (+ error)
                    └── Item 3 (+ error)
```

- **Direction of causality**: Construct → Indicators
- **Assumption**: All indicators reflect the same underlying construct
- **Key property**: Items are interchangeable; removing one should not change the construct
- **Examples**:
  - Attitude toward cycling (ATT1, ATT2, ATT3 all reflect attitude)
  - Service quality perception
  - Trust in autonomous vehicles

### 6.2 Formative Model

```
Item 1 ──┐
Item 2 ──┼── Latent Construct
Item 3 ──┘
```

- **Direction of causality**: Indicators → Construct
- **Assumption**: Items collectively *define* or *cause* the construct
- **Key property**: Items may not correlate; removing one changes the construct
- **Examples**:
  - Socioeconomic status (income + education + occupation → SES)
  - Transportation disadvantage index
  - Built environment index (density + diversity + design)

**⚠️ Common Mistake**: Most researchers incorrectly model formative constructs as reflective. Always justify your choice based on theory.

### 6.3 How to Decide: Reflective or Formative?

Ask these questions:

| Question | Reflective | Formative |
|---------|-----------|-----------|
| Do items share a common theme? | Yes | Not necessarily |
| Can items be dropped without changing the construct? | Yes | No |
| Do items covary? | Yes (they should) | Not necessarily |
| Is the construct *manifested* in items or *composed* of items? | Manifested | Composed |

---

## 7. Scale Development Process

Building a valid and reliable scale for your research:

```
Step 1: Define the construct conceptually (literature review)
        ↓
Step 2: Generate items (literature, existing scales, expert interviews)
        ↓
Step 3: Expert review (content validity)
        ↓
Step 4: Pilot testing (n ≈ 30–50)
        ↓
Step 5: Item analysis (corrected item-total correlations, α)
        ↓
Step 6: Exploratory Factor Analysis — EFA (n ≈ 150–200)
        ↓
Step 7: Confirmatory Factor Analysis — CFA (new sample, n ≥ 200)
        ↓
Step 8: Assess reliability (α, CR) and validity (AVE, HTMT)
        ↓
Step 9: Use scale in structural model (SEM / regression)
```

---

## 8. Scales Commonly Used in Transportation Research

| Scale | Original Source | Application |
|-------|----------------|-------------|
| Perceived safety (road) | Perceived Safety Scale | Road safety, motorcycle research |
| Attitudes toward modes | Various | Mode choice modeling |
| Service quality (SERVQUAL) | Parasuraman et al. (1988) | Transit quality of service |
| Technology Acceptance (TAM) | Davis (1989) | AV, ride-hailing, navigation apps |
| Risk perception | Various | Accident behavior, speeding |
| Environmental attitude | Various | Green travel, car reduction |
| Subjective norms | Ajzen (1991) | Helmet/seatbelt use, mode choice |

---

## 9. Common Measurement Pitfalls

### 9.1 Common Method Variance (CMV)
When both predictor and outcome are measured from the same person, same time, same method — inflated correlations.

**Remedies:**
- Temporal separation (collect predictor and outcome at different times)
- Procedural remedies: ensure anonymity, use different scale formats
- Statistical test: Harman's single-factor test (EFA), marker variable technique

### 9.2 Social Desirability Bias
Respondents answer in socially acceptable ways.

**Remedies:**
- Assure anonymity
- Use indirect questions
- Include social desirability scale (e.g., Marlowe-Crowne)

### 9.3 Response Acquiescence (Yes-saying)
Tendency to agree regardless of content.

**Remedies:**
- Include reverse-coded items
- Check inter-item correlations for suspicious patterns

---

## 10. Summary

| Concept | Key Point |
|---------|----------|
| Classical Test Theory | Observed = True + Error |
| Reliability | Consistency; α ≥ 0.70 |
| Validity | Measuring what you intend |
| Convergent Validity | AVE ≥ 0.50, loadings ≥ 0.50 |
| Discriminant Validity | HTMT < 0.85 |
| Reflective vs. Formative | Theory-driven choice |
| Scale development | 9-step iterative process |

---

## References

- DeVellis, R. F. (2016). *Scale Development: Theory and Applications* (4th ed.). Sage.
- Fornell, C., & Larcker, D. F. (1981). Evaluating structural equation models with unobservable variables and measurement error. *Journal of Marketing Research*, 18(1), 39–50.
- Hair, J. F., Risher, J. J., Sarstedt, M., & Ringle, C. M. (2019). When to use and how to report the results of PLS-SEM. *European Business Review*, 31(1), 2–24.
- Henseler, J., Ringle, C. M., & Sarstedt, M. (2015). A new criterion for assessing discriminant validity in variance-based structural equation modeling. *Journal of the Academy of Marketing Science*, 43(1), 115–135.
- Nunnally, J. C., & Bernstein, I. H. (1994). *Psychometric Theory* (3rd ed.). McGraw-Hill.

---

*Next: [00_Analytical_Workflow.md](./00_Analytical_Workflow.md)*
