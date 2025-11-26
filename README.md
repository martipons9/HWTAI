Handball Wing Throw Assessment Instrument (HWTAI) – Code and Documentation
1. Project Title

Design and Validation of the Handball Wing Throw Assessment Instrument (HWTAI) for Novice Players

This repository contains all R scripts, documentation, and processing workflows used in the development, scoring, and validation of the HWTAI instrument.

2. Authors

Martí Pons-Oliver

Víctor López-Ros

3. Description

The Handball Wing Throw Assessment Instrument (HWTAI) is a performance-based observational tool designed to evaluate the execution quality of the wing throw in handball.
This repository includes:

Data-cleaning and scoring scripts for computing the Individual Rating (IR).

Scripts for reliability analyses:

Construct validity

Intra-observer reliability

Inter-observer reliability

Test–retest reliability

Documentation and examples to allow full reproducibility of analyses presented in the article.

All code is written in R, structured into two main scripts:

01_scoring_HWTAI.R – Computes all performance indicators, repertoire score, final IR, and exports the analysis dataset.

02_HWTAI_reliability_analysis.R – Performs all psychometric analyses (ICC, Shapiro–Wilk, Levene, paired tests, boxplots).

4. Repository Structure
HWTAI/
│
├── data/
│   └── hwtai_data.xlsx                # Raw data (or synthetic example)
│
├── scripts/
│   ├── 01_scoring_HWTAI.R             # Script to compute IR
│   └── 02_HWTAI_reliability_analysis.R# Reliability & validity analyses
│
├── output/
│   └── hwtai_analysis.xlsx            # Generated IR dataset
│
└── README.md


You may adapt this structure according to journal or institutional requirements.

5. Requirements

This project uses R (≥ 4.2) and the following packages:

readxl

dplyr

tidyr

purrr

writexl

car

ggplot2

irr

To install all required packages:

install.packages(c("readxl", "dplyr", "tidyr", "purrr", 
                   "writexl", "car", "ggplot2", "irr"))

6. How to Use the Repository
Step 1 – Compute IR (Individual Rating)

Run:

scripts/01_scoring_HWTAI.R


This script:

Cleans and processes all attempts

Applies penalties

Computes level scores and repertoire score

Generates the final IR

Exports hwtai_analysis.xlsx to the output/ folder

Step 2 – Perform Reliability & Validity Analyses

Run:

scripts/02_HWTAI_reliability_analysis.R


This script performs:

Construct validity (expertise groups)

Intra-observer reliability (ICC + paired tests)

Inter-observer reliability (ICC + paired tests)

Test–retest reliability (ICC + paired tests)

Produces diagnostic tests and boxplots

7. Citation

If you use this code or adapt the instrument, please cite:

Pons-Oliver, M., & López-Ros, V. (2025). Design and validation of the Handball Wing Throw Assessment Instrument (HWTAI) for novice players. [Journal Name], [Volume(Issue)], pages. DOI: XXXXXXXX

(Update citation details once accepted/pre-print is available.)

8. License

We recommend using the MIT License, which is standard for code repositories.
It allows anyone to reuse and adapt the code as long as they include the copyright notice.

If you prefer stronger attribution requirements similar to Creative Commons, you may choose CC-BY 4.0, but note:

MIT → Ideal for code

CC-BY → Ideal for datasets / documents / text

For a research code repository, MIT is most appropriate.
A LICENSE file has to be included in the repository.

9. Contact

For questions or collaborations:

Martí Pons-Oliver – [add email or ORCID]

Víctor López-Ros – [add email or ORCID]
