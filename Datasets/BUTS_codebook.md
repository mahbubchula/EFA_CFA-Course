# Bangkok Urban Transportation Survey (BUTS) — Data Codebook

> Dataset for: *Advanced Statistical Methods for Transportation & Behavioral Research*
> Instructor: Mahbub Hassan, Chulalongkorn University

---

## Dataset Overview

| Property | Value |
|----------|-------|
| File | `BUTS_main.csv` |
| Respondents | 450 |
| Variables | 34 |
| Collection context | Synthetic data generated for educational purposes |
| Missing values | Yes (realistic MCAR pattern) |
| Scale items | 5-point Likert (1=Strongly Disagree to 5=Strongly Agree) |

---

## Variable Dictionary

### Section A: Identification

| Variable | Type | Description |
|----------|------|-------------|
| `RespondentID` | Character | Unique respondent identifier (BUTS_0001 to BUTS_0450) |

### Section B: Sociodemographic Variables

| Variable | Type | Coding |
|----------|------|--------|
| `Gender` | Categorical | 1=Male, 2=Female |
| `Age` | Continuous | Age in years (18–70) |
| `AgeGroup` | Categorical | 1=18–25, 2=26–35, 3=36–45, 4=46–55, 5=56+ |
| `EducationLevel` | Ordinal | 1=Primary, 2=Secondary, 3=Vocational, 4=Bachelor's, 5=Postgraduate |
| `IncomeGroup` | Categorical | 1=<15,000, 2=15,000–30,000, 3=30,001–50,000, 4=>50,000 (THB/month) |
| `Income` | Continuous | Monthly income in Thai Baht |
| `CarOwnership` | Binary | 0=No car, 1=Owns car |

### Section C: Travel Behavior Variables

| Variable | Type | Coding |
|----------|------|--------|
| `PrimaryMode` | Categorical | 1=Car, 2=Motorcycle, 3=Public Transit, 4=Walk/Cycle |
| `TripDistance_km` | Continuous | Average daily travel distance (km) |
| `TripTime_min` | Continuous | Average daily travel time (minutes) |
| `TripsPerDay` | Count | Number of trips per day (1–6) |
| `YearsDriving` | Continuous | Years of driving/riding experience |
| `ResidentialZone` | Categorical | 1=Urban core, 2=Urban fringe, 3=Suburban, 4=Rural |

### Section D: Perceived Safety Scale (PS)
*"Please rate your agreement with each statement about transportation safety."*
*Scale: 1=Strongly Disagree to 5=Strongly Agree*

| Variable | Item Wording |
|----------|-------------|
| `PS1` | I feel safe when using public transit in Bangkok |
| `PS2` | The roads I travel daily are generally safe |
| `PS3` | I feel protected from crime at transit stops and stations |
| `PS4` | Traffic behavior in Bangkok makes me feel safe as a traveler |
| `PS5` | The overall transportation environment in Bangkok is safe (weaker loading) |

### Section E: Service Quality Scale (SQ)
*"Please rate the quality of public transit service in Bangkok."*

| Variable | Item Wording |
|----------|-------------|
| `SQ1` | Public transit in Bangkok generally arrives on schedule |
| `SQ2` | Transit vehicles are clean and well-maintained |
| `SQ3` | Transit staff are helpful and professional |
| `SQ4` | The frequency of transit service is adequate for my needs |

### Section F: Environmental Attitude Scale (EA)
*"Please indicate your agreement with statements about the environment and travel."*

| Variable | Item Wording |
|----------|-------------|
| `EA1` | I prefer to choose travel options that are environmentally friendly |
| `EA2` | I am concerned about the environmental impact of private vehicle use |
| `EA3` | I try to reduce my carbon footprint through my travel choices |
| `EA4` | Public transit is an important part of reducing urban air pollution |

### Section G: Behavioral Intention Scale (BI)
*"Please indicate your intentions regarding public transit use."*

| Variable | Item Wording |
|----------|-------------|
| `BI1` | I plan to use public transit more frequently in the next month |
| `BI2` | I intend to reduce my private vehicle use in favor of transit |
| `BI3` | I will choose public transit over private car for my next commute |

### Section H: Actual Behavior Scale (AB)
*"Please indicate your current transit use behavior."*

| Variable | Item Wording |
|----------|-------------|
| `AB1` | I regularly use public transit for my daily commute |
| `AB2` | Over the past month, I have increased my use of public transit |
| `AB3` | Public transit is my primary mode of transportation for most trips |

---

## Missing Values

| Variable | Missing (n) | % Missing | Pattern |
|----------|------------|-----------|---------|
| `Income` | ~31 | ~7% | MCAR |
| `IncomeGroup` | ~31 | ~7% | MCAR |
| `PS5` | ~9 | ~2% | MCAR |
| `AB3` | ~13 | ~3% | MCAR |
| All others | 0 | 0% | — |

---

## Construct Correlations (Design Values)

| | PS | SQ | EA | BI | AB |
|--|---|----|----|----|-----|
| PS | 1.00 | | | | |
| SQ | 0.45 | 1.00 | | | |
| EA | 0.32 | 0.38 | 1.00 | | |
| BI | 0.55 | 0.62 | 0.58 | 1.00 | |
| AB | 0.42 | 0.48 | 0.44 | 0.68 | 1.00 |

---

## Recommended Analysis Sequence

```
Module 01: Descriptive statistics → Use all 34 variables
Module 02: EFA                    → Use items PS1-AB3 (19 items)
Module 03: CFA                    → Use items PS1-AB3 (19 items)
Module 04: CB-SEM                 → Use items PS1-AB3 (19 items)
Module 05: Regression             → Use PS/SQ/EA/BI/AB scores + demographics
Module 06: Case studies           → Use full dataset
```

---

## Citation

*Bangkok Urban Transportation Survey (BUTS) is a synthetic dataset created for educational use in the course "Advanced Statistical Methods for Transportation and Behavioral Research" taught by Mahbub Hassan at Chulalongkorn University.*

*To generate/regenerate the dataset: Run `generate_BUTS_dataset.R`*
