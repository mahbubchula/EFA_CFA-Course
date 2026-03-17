# 00 — Research Design and Methodology in Transportation & Behavioral Research

> **Module 00 | Introduction & Foundations**
> *Course: Advanced Statistical Methods for Transportation & Behavioral Research*
> *Instructor: Dr. Mahbub Hassan, Chulalongkorn University*

---

## 1. The Role of Quantitative Research

Transportation engineering and behavioral research address questions like:

- Why do commuters prefer private cars over public transit?
- What factors influence drivers' risk-taking behavior?
- How does service quality perception affect transit ridership?
- What predicts accident involvement among young motorcyclists?

These questions involve **unmeasured (latent) psychological and social constructs** that cannot be captured with a single measurement. This is where advanced statistical methods become indispensable.

---

## 2. Types of Research in Transportation

### 2.1 Descriptive Research
*What is the current state?*
- Traffic volume counts, accident statistics, modal share
- Methods: descriptive statistics, frequency analysis

### 2.2 Correlational / Associative Research
*Are variables related?*
- Relationship between income and mode choice
- Methods: correlation, regression

### 2.3 Causal / Explanatory Research
*Why does X affect Y?*
- Effect of perceived safety on transit use intention
- Methods: SEM, regression with theory-based models

### 2.4 Predictive Research
*Can we predict outcomes?*
- Predicting crash severity
- Methods: logistic regression, machine learning

---

## 3. The Quantitative Research Process

```
Step 1: Problem Identification
        ↓
Step 2: Literature Review & Theory Building
        ↓
Step 3: Conceptual Framework & Hypothesis Development
        ↓
Step 4: Operationalization (construct → indicators)
        ↓
Step 5: Survey/Instrument Design
        ↓
Step 6: Data Collection
        ↓
Step 7: Data Screening & Preparation
        ↓
Step 8: Descriptive Statistics & Reliability Assessment
        ↓
Step 9: Exploratory Factor Analysis (EFA)         ← Module 02
        ↓
Step 10: Confirmatory Factor Analysis (CFA)       ← Module 03
        ↓
Step 11: Structural Model / SEM / Regression      ← Module 04 & 05
        ↓
Step 12: Interpretation & Reporting
```

---

## 4. Survey Research in Transportation

Survey research is the backbone of behavioral transportation research. Key considerations:

### 4.1 Sampling Design
| Type | Description | When to Use |
|------|-------------|-------------|
| Simple Random Sampling | Every element has equal probability | Population is homogeneous |
| Stratified Sampling | Population divided into strata | Known sub-groups (age, gender, mode) |
| Cluster Sampling | Groups randomly selected | Geographically dispersed population |
| Purposive / Snowball | Non-probability | Hard-to-reach populations |

### 4.2 Sample Size Considerations
- **Rule of thumb for factor analysis**: Minimum 5–10 respondents per item; ideally N > 200
- **SEM**: Minimum N = 200; N = 300–500 recommended for stable estimates
- **Regression**: N ≥ 50 + 8m (where m = number of predictors) for multiple regression
- **CB-SEM power analysis**: Use G*Power or Samplesize.net

### 4.3 Measurement Scales
| Scale | Type | Examples | Analyses |
|-------|------|---------|---------|
| Nominal | Categorical | Gender, mode of transport | Chi-square, frequency |
| Ordinal | Ranked | Likert items, satisfaction ratings | Median, rank correlation |
| Interval | Equal intervals | Temperature | Mean, SD, parametric tests |
| Ratio | True zero | Income, age, distance | All parametric methods |

**Note on Likert Scales**: In practice, 5-point and 7-point Likert scales are treated as interval-level for SEM and factor analysis when items are part of a multi-item scale. This is widely accepted in behavioral and transportation research.

---

## 5. Types of Variables in Structural Research

### 5.1 By Role in Model
```
Exogenous Variable (ξ, xi)  →  Endogenous Variable (η, eta)
    (Independent)                  (Dependent / mediating)
```

- **Exogenous**: Not explained by the model; only affects others
- **Endogenous**: Explained by the model (has arrows pointing to it)
- **Mediator**: Transmits the effect of X on Y
- **Moderator**: Changes the strength/direction of X→Y relationship

### 5.2 By Observability
```
Latent Variable (construct)
    ↓ reflected by
Manifest/Observed Variables (indicators, items)
```

**Example — Perceived Service Quality:**
```
Perceived Service Quality (latent)
    ├── SQ1: "The bus arrives on time"              (manifest)
    ├── SQ2: "The bus is clean and comfortable"     (manifest)
    ├── SQ3: "The staff are helpful and polite"     (manifest)
    └── SQ4: "The frequency of service is adequate" (manifest)
```

---

## 6. Common Research Frameworks in Transportation

### 6.1 Theory of Planned Behavior (TPB) — Ajzen (1991)
```
Attitude → Behavioral Intention → Behavior
Social Norm ↗                    ↑
Perceived Behavioral Control ────┘
```
*Widely used for: mode choice, speeding, seatbelt use, helmet use*

### 6.2 Technology Acceptance Model (TAM) — Davis (1989)
```
Perceived Usefulness → Behavioral Intention → Usage
Perceived Ease of Use ↗
```
*Widely used for: ride-hailing apps, navigation systems, autonomous vehicles*

### 6.3 Value-Belief-Norm (VBN) Theory — Stern (2000)
```
Values → Beliefs → Personal Norms → Behavior
```
*Widely used for: pro-environmental travel behavior, car reduction*

### 6.4 Protection Motivation Theory (PMT)
```
Threat Appraisal → Coping Appraisal → Protection Motivation → Behavior
```
*Widely used for: road safety behavior, helmet and seatbelt compliance*

---

## 7. Operationalization: From Theory to Measurement

**Example**: Operationalizing "Perceived Road Safety" for motorcyclists

```
Theoretical Construct: Perceived Road Safety
    ↓
Dimensions (from literature):
    1. Physical Road Environment Safety
    2. Traffic Behavior Safety
    3. Vehicle Safety

    ↓
Indicators (survey items, 5-point Likert scale):

Physical Road Environment (PRE):
    PRE1: "The road surface condition is good for motorcycling"
    PRE2: "Road lighting is adequate for night riding"
    PRE3: "Road markings and signs are clear and visible"

Traffic Behavior (TB):
    TB1: "Other drivers respect motorcycle lane rules"
    TB2: "Drivers give way to motorcycles at intersections"
    TB3: "I feel safe when riding in heavy traffic"

Vehicle Safety (VS):
    VS1: "My motorcycle is well-maintained"
    VS2: "I regularly check brakes and tires before riding"
    VS3: "My motorcycle meets safety standards"
```

---

## 8. Key Terminology Reference

| Term | Definition |
|------|-----------|
| **Construct** | Abstract concept being measured (e.g., "Satisfaction") |
| **Indicator** | Observed/measured item reflecting a construct |
| **Reflective model** | Construct → Indicators (changes in construct cause changes in indicators) |
| **Formative model** | Indicators → Construct (indicators define the construct) |
| **Reliability** | Consistency/stability of measurement |
| **Validity** | Accuracy — are we measuring what we intend? |
| **Convergent validity** | Items measuring the same construct correlate highly |
| **Discriminant validity** | Items measuring different constructs do NOT correlate highly |
| **Common method bias** | Variance due to the measurement method rather than the constructs |
| **Multicollinearity** | High correlations among predictors — problematic for regression |
| **Endogeneity** | When a predictor correlates with the error term |

---

## 9. Summary

Transportation and behavioral research requires methods that can:
1. Handle **latent, unobservable constructs** (EFA, CFA)
2. Test **complex theoretical frameworks** with multiple relationships (SEM)
3. Predict outcomes from multiple predictors (regression)
4. Account for measurement error (CFA, SEM)

The following modules build each of these skills step by step.

---

## References

- Ajzen, I. (1991). The theory of planned behavior. *Organizational Behavior and Human Decision Processes*, 50(2), 179–211.
- Hair, J. F., Black, W. C., Babin, B. J., & Anderson, R. E. (2019). *Multivariate Data Analysis* (8th ed.). Cengage.
- Kline, R. B. (2023). *Principles and Practice of Structural Equation Modeling* (5th ed.). Guilford Press.
- Washington, S., Karlaftis, M., Mannering, F., & Anastasopoulos, P. (2020). *Statistical and Econometric Methods for Transportation Data Analysis* (3rd ed.). CRC Press.

---

*Next: [00_Measurement_Theory.md](./00_Measurement_Theory.md)*
