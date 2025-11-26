# **Handball Wing Throw Assessment Instrument (HWTAI)**  
## *Design and validation of the Handball Wing Throw Assessment Instrument (HWTAI) for novice players*  
### **Martí Pons-Oliver & Víctor López-Ros**

---

## **Overview**
This repository contains all scripts and materials used to compute the HWTAI performance score (IR score) and to conduct the instrument’s reliability and construct validity analyses.

Two independent R scripts are provided:

- **01_compute_IR.R** → Computes the IR score from raw observation data  
- **02_reliability_validity_analysis.R** → Performs test–retest, intra-observer, inter-observer reliability, and construct validity

A template Excel file (**hwtai_data.xlsx**) is included so that users can input their own observational data.

---

## **Before Running the Scripts**
Before executing `01_compute_IR.R`, users must complete the Excel file **hwtai_data.xlsx** with the observational data obtained after administering the HWTAI.

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

## 📂 **Repository Structure**

