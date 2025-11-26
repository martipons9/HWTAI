###############################################################
### SCRIPT 2 – RELIABILITY & CONSTRUCT VALIDITY ANALYSES
### Dataset required: hwtai_analysis.xlsx (output of Script 1)
### Author: Martí Pons Oliver
### Version: 1.0
###############################################################

###############################################################
### 0. LIBRARIES
###############################################################

library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)
library(car)
library(irr)

###############################################################
### 1. LOAD DATA
###############################################################

hwtai <- read_excel("hwtai_analysis.xlsx")


###############################################################
### ===========================================================
### PART A – DATASET PREPARATION FOR EACH ANALYSIS
### ===========================================================
###############################################################

###############################################################
### 1. TEST–RETEST (Assessment Time 1 vs 2)
###############################################################

test_retest <- hwtai %>%
  filter(assessment_time %in% c(1, 2)) %>%
  group_by(id, assessment_time) %>%
  arrange(
    observer != "a",          
    observation_time != 1     
  ) %>%
  slice(1) %>%
  ungroup() %>%
  select(id, assessment_time, pi) %>%
  pivot_wider(
    names_from = assessment_time,
    values_from = pi,
    names_prefix = "pi_t"
  )


###############################################################
### 2. INTRA-OBSERVER (Observer A, Observation 1 vs 2)
###############################################################

intraobserver <- hwtai %>%
  filter(observer == "a",
         observation_time %in% c(1, 2)) %>%
  group_by(id, observation_time) %>%
  arrange(assessment_time != 1) %>%
  slice(1) %>%
  ungroup() %>%
  select(id, observation_time, pi) %>%
  pivot_wider(
    names_from = observation_time,
    values_from = pi,
    names_prefix = "pi_io_"
  )


###############################################################
### 3. INTER-OBSERVER (Observers A vs B, Same Observation Time)
###############################################################

interobserver <- hwtai %>%
  filter(observation_time == 1,
         observer %in% c("a", "b")) %>%
  group_by(id, observer) %>%
  arrange(assessment_time != 1) %>%
  slice(1) %>%
  ungroup() %>%
  select(id, observer, pi) %>%
  pivot_wider(
    names_from = observer,
    values_from = pi,
    names_prefix = "pi_ieo_"
  )


###############################################################
### 4. CONSTRUCT VALIDITY DATASETS
###############################################################

# Expert vs Inexpert
inexpert_expert <- hwtai %>%
  filter(expertise %in% c("inexpert", "expert")) %>%
  group_by(id) %>%
  arrange(observer != "a", observation_time != 1, assessment_time != 1) %>%
  slice(1) %>%
  ungroup()

# Expert vs Novice
novice_expert <- hwtai %>%
  filter(expertise %in% c("novice", "expert")) %>%
  group_by(id) %>%
  arrange(observer != "a", observation_time != 1, assessment_time != 1) %>%
  slice(1) %>%
  ungroup()



###############################################################
### ===========================================================
### PART B – CONSTRUCT VALIDITY
### ===========================================================
###############################################################

###############################################################
### 1. NORMALITY TESTS (Shapiro–Wilk)
###############################################################

# Expert vs Inexpert
shapiro_expert_inexp <- shapiro.test(inexpert_expert$pi[inexpert_expert$expertise == "expert"])
shapiro_inexpert     <- shapiro.test(inexpert_expert$pi[inexpert_expert$expertise == "inexpert"])

# Expert vs Novice
shapiro_expert_nov <- shapiro.test(novice_expert$pi[novice_expert$expertise == "expert"])
shapiro_novice     <- shapiro.test(novice_expert$pi[novice_expert$expertise == "novice"])


###############################################################
### 2. HOMOGENEITY OF VARIANCES (Levene)
###############################################################

levene_inexpert <- leveneTest(pi ~ expertise, data = inexpert_expert)
levene_novice   <- leveneTest(pi ~ expertise, data = novice_expert)


###############################################################
### 3. SIGNIFICANCE TESTS DEPENDING ON NORMALITY
###############################################################

# Expert vs Inexpert
normal_inexp <- (shapiro_expert_inexp$p.value > 0.05 &
                   shapiro_inexpert$p.value > 0.05)
var_equal_inexp <- levene_inexpert$"Pr(>F)"[1] > 0.05

test_inexpert_expert <- if (normal_inexp) {
  t.test(pi ~ expertise, data = inexpert_expert, var.equal = var_equal_inexp)
} else {
  wilcox.test(pi ~ expertise, data = inexpert_expert)
}

# Expert vs Novice
normal_nov <- (shapiro_expert_nov$p.value > 0.05 &
                 shapiro_novice$p.value > 0.05)
var_equal_nov <- levene_novice$"Pr(>F)"[1] > 0.05

test_novice_expert <- if (normal_nov) {
  t.test(pi ~ expertise, data = novice_expert, var.equal = var_equal_nov)
} else {
  wilcox.test(pi ~ expertise, data = novice_expert)
}


###############################################################
### 4. BOXPLOT – Construct Validity
###############################################################

ggplot(
  rbind(inexpert_expert, novice_expert),
  aes(x = expertise, y = pi, fill = expertise)
) +
  geom_boxplot() +
  labs(
    title = "Construct Validity – PI by Expertise Level",
    x = "Expertise Level",
    y = "PI Score"
  ) +
  theme_minimal()



###############################################################
### ===========================================================
### PART C – INTRA-OBSERVER RELIABILITY
### ===========================================================
###############################################################

###############################################################
### 1. ICC (Two-way, Agreement, Single)
###############################################################

icc_intra <- icc(
  intraobserver[, c("pi_io_1", "pi_io_2")],
  model = "twoway",
  type  = "agreement",
  unit  = "single"
)

icc_intra


###############################################################
### 2. DIFFERENCES + NORMALITY
###############################################################

intraobserver$diff_io <- intraobserver$pi_io_1 - intraobserver$pi_io_2
shapiro.test(intraobserver$diff_io)


###############################################################
### 3. PAIRED TEST (t-test or Wilcoxon)
###############################################################

test_intra <- if (shapiro.test(intraobserver$diff_io)$p.value > 0.05) {
  t.test(intraobserver$pi_io_1, intraobserver$pi_io_2, paired = TRUE)
} else {
  wilcox.test(intraobserver$pi_io_1, intraobserver$pi_io_2, paired = TRUE)
}

test_intra



###############################################################
### ===========================================================
### PART D – INTER-OBSERVER RELIABILITY
### ===========================================================
###############################################################

###############################################################
### 1. ICC (Two-way, Agreement, Single)
###############################################################

icc_inter <- icc(
  interobserver[, c("pi_ieo_a", "pi_ieo_b")],
  model = "twoway",
  type  = "agreement",
  unit  = "single"
)

icc_inter


###############################################################
### 2. DIFFERENCES + NORMALITY
###############################################################

interobserver$diff_ieo <- interobserver$pi_ieo_a - interobserver$pi_ieo_b
shapiro.test(interobserver$diff_ieo)


###############################################################
### 3. PAIRED TEST (t-test or Wilcoxon)
###############################################################

test_inter <- if (shapiro.test(interobserver$diff_ieo)$p.value > 0.05) {
  t.test(interobserver$pi_ieo_a, interobserver$pi_ieo_b, paired = TRUE)
} else {
  wilcox.test(interobserver$pi_ieo_a, interobserver$pi_ieo_b, paired = TRUE)
}

test_inter



###############################################################
### ===========================================================
### PART E – TEST–RETEST RELIABILITY
### ===========================================================
###############################################################

###############################################################
### 1. ICC (One-way, Consistency, Single)
###############################################################

icc_test_retest <- icc(
  test_retest[, c("pi_t1", "pi_t2")],
  model = "oneway",
  type  = "consistency",
  unit  = "single"
)

icc_test_retest


###############################################################
### 2. DIFFERENCES + NORMALITY
###############################################################

test_retest$diff_t <- test_retest$pi_t2 - test_retest$pi_t1
shapiro.test(test_retest$diff_t)


###############################################################
### 3. PAIRED TEST
###############################################################

test_test_retest <- if (shapiro.test(test_retest$diff_t)$p.value > 0.05) {
  t.test(test_retest$pi_t1, test_retest$pi_t2, paired = TRUE)
} else {
  wilcox.test(test_retest$pi_t1, test_retest$pi_t2, paired = TRUE)
}

test_test_retest
