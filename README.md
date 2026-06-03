# **Handball Wing Throw Assessment Instrument (HWTAI)**  
## *Design and validation of the Handball Wing Throw Assessment Instrument (HWTAI) for novice players*  
### **Martí Pons-Oliver & Víctor López-Ros**

---

## **Overview**
This repository contains all scripts and materials used to compute the HWTAI performance score (PI score) and to conduct the instrument’s reliability and construct validity analyses.

Two independent R scripts are provided:

- **01_compute_PI.R** → Computes the PI score from raw observation data  
- **02_reliability_and_validity_analysis.R** → Performs test–retest, intra-observer, inter-observer reliability, and construct validity

A template Excel file (**hwtai_data.xlsx**) is included so that users can input their own observational data.

---

## **Before Running the Scripts**
Before executing `01_compute_PI.R`, users must complete the Excel file **hwtai_data.xlsx** with the observational data obtained after administering the HWTAI.

### 1. **Mandatory metadata columns (only required for reliability/validity)**

| Column | Meaning | Allowed values |
|--------|---------|----------------|
| **expertise** | Participant’s experience level | `expert`, `novice` (little experience), `inexpert` (0 experience) |
| **assessment_time** | Whether observation corresponds to time 1 or time 2 | `1`, `2` |
| **observer** | Who performed the coding | `a`, `b` |
| **observation_time** | First or second observation by same observer | `1`, `2` |

If the user does **not** want to evaluate reliability/validity, these fields can remain **empty**.

---

## 2️. **Columns corresponding to each HWTAI attempt**

Each attempt follows the naming structure:

LetterAttempt_Level
Example: A1_2 → Approach run, attempt 1, level 2

###  **Meaning of letters**
- **A** = *Approach Run*  
- **T** = *Take-off*  
- **D** = *Decision-making*  
- **E** = *Effectiveness*  
- **R** = *Technical repertoire*  
- **P** = *Penalisation*

###  **How to fill each column**
| Column | What to write |
|--------|---------------|
| **A, T, D, E** | Write **1** if the condition is met, **0** otherwise (see *Appendix A – Scoring System*) |
| **R** | Write the single-letter code corresponding to the throw performed |
| **P** | `no`, `reg`, `san`, or `inv` |

### ⚠️ Important
No additional calculations are needed.  
**All weightings and scoring rules are automated inside the R code.**

---

## Overview of the HWTAI Process

1. **Fill in the scoring Excel file (`hwtai_data.xlsx`).**  
2. **Run script 1** to automatically compute:  
   - Cleaned performance indicators  
   - Level scores  
   - Repertoire score  
   - Final **Instrument Result (PI)**  
   - Export dataset `hwtai_analysis.xlsx`

3. **Run script 2** *optionally* to perform:  
   - Construct validity  
   - Test–retest reliability  
   - Intra-observer reliability  
   - Inter-observer reliability  

All statistical outputs follow the methodology used in the article.

---

##  Script 1 — *Compute the Instrument Result (PI)*

The script performs:

- Data preparation  
- Cleaning rules based on penalisation code  
- Attempt-level weighted scoring  
- Global repertoire score calculation  
- Final score aggregation  
- Export of `hwtai_analysis.xlsx`  

###  Output  
A clean dataset containing:

| id | expertise | assessment_time | observer | observation_time | PI |
|----|-----------|------------------|----------|-------------------|----|

Saved in the project root.

---

##  Script 2 — *Reliability & Validity Analyses*

### Includes:

### **1. Construct Validity**  
- Shapiro–Wilk tests  
- Levene’s test  
- Parametric or non-parametric tests  
- Boxplots generated with **ggplot2**

### **2. Intra-observer Reliability**  
- ICC (two-way, agreement, single)  
- Shapiro test on paired differences  
- Paired t-test or Wilcoxon signed-rank test  

### **3. Inter-observer Reliability**  
- ICC (two-way, agreement, single)  
- Shapiro test  
- Paired t-test or Wilcoxon  

### **4. Test–retest Reliability**  
- ICC (one-way, consistency, single)  
- Paired comparison test  

All results print directly to the R console.

---

##  Citation

If you use the repository or the HWTAI scoring system, cite:

**Pons-Oliver, M., & López-Ros, V.**  
*Design and validation of the Handball Wing Throw Assessment Instrument (HWTAI) for novice players.*

---

##  License

This project is released under the **MIT License**, allowing reuse with attribution.


---

##  Contact

For questions, suggestions, or collaborations:

📧 **Martí Pons-Oliver** — (marti.3x3@gmail.com)

---



