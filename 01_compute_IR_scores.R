###############################################################
### HWTAI SCORING SCRIPT
### Script 1/2 – Computing Individual IR Scores
### Author: Martí Pons Oliver
### Version: 1.0
### Description:
###   - Loads raw dataset
###   - Cleans attempts (penalties)
###   - Computes performance points for each level
###   - Computes repertoire score
###   - Outputs final IR dataset for analysis
###############################################################

###############################################################
### 0. LIBRARIES
###############################################################

library(readxl)
library(dplyr)
library(tidyr)
library(purrr)
library(writexl)

###############################################################
### 1. LOAD AND PREPARE DATA
###############################################################

# Working directory (modify as needed by each user)
# setwd("path/to/your/folder")

# Import dataset
data <- read_excel("hwtai_data.xlsx", sheet = 1)

# Lowercase column names + text content
colnames(data) <- tolower(colnames(data))
data <- data %>% mutate(across(where(is.character), tolower))


###############################################################
### 2. CLEANING FUNCTION (penalties)
###############################################################
clean_attempt <- function(A, T, D, E, R, P){
  
  if (P == "inv") {
    return(list(A = 0, T = 0, D = 0, E = 0, R = "x"))
  }
  
  if (P %in% c("san", "reg")) {
    R <- "x"
  }
  
  return(list(A = A, T = T, D = D, E = E, R = R))
}


###############################################################
### 3. CREATE *_clean VARIABLES
###############################################################
for(level in 1:3){
  for(attempt in 1:4){
    
    Acol <- paste0("a", attempt, "_", level)
    Tcol <- paste0("t", attempt, "_", level)
    Dcol <- paste0("d", attempt, "_", level)
    Ecol <- paste0("e", attempt, "_", level)
    Rcol <- paste0("r", attempt, "_", level)
    Pcol <- paste0("p", attempt, "_", level)
    
    Anew <- paste0(Acol, "_clean")
    Tnew <- paste0(Tcol, "_clean")
    Dnew <- paste0(Dcol, "_clean")
    Enew <- paste0(Ecol, "_clean")
    Rnew <- paste0(Rcol, "_clean")
    
    data <- data %>%
      mutate(
        tmp = pmap(list(!!sym(Acol), !!sym(Tcol), !!sym(Dcol),
                        !!sym(Ecol), !!sym(Rcol), !!sym(Pcol)),
                   clean_attempt),
        !!Anew := map_dbl(tmp, "A"),
        !!Tnew := map_dbl(tmp, "T"),
        !!Dnew := map_dbl(tmp, "D"),
        !!Enew := map_dbl(tmp, "E"),
        !!Rnew := map_chr(tmp, "R")
      ) %>%
      select(-tmp)
  }
}


###############################################################
### 4. FUNCTION – POINTS PER ATTEMPT
###############################################################
attempt_points <- function(A, T, D, E, P, level){
  
  bonus <- case_when(
    P == "san"            ~ -2,
    E == 1 & P == "no"    ~ c(1.5, 2, 3)[level],
    E == 1 & P == "reg"   ~ 0,
    TRUE                  ~ 0
  )
  
  if(level == 1) return(A * 0.5 + T + D * 0.5 + bonus)
  if(level == 2) return(A * 0.5 + T + D       + bonus)
  if(level == 3) return(A * 0.5 + T + D * 1.5 + bonus)
}


###############################################################
### 5. FUNCTION – REPERTOIRE SCORE
###############################################################
compute_repertoire <- function(repertoire, efficacy){
  
  attempts <- tibble(rep = repertoire, eff = efficacy) %>%
    mutate(
      p_raw = case_when(
        rep == "x" ~ 0,
        eff == 1   ~ 2,
        eff == 0   ~ 1
      )
    )
  
  attempts_summary <- attempts %>%
    group_by(rep) %>%
    summarise(p = max(p_raw), .groups = "drop") %>%
    filter(rep != "x")
  
  top_repertoire <- attempts_summary %>%
    arrange(desc(p)) %>%
    slice_head(n = 6)
  
  sum(top_repertoire$p)
}


###############################################################
### 6. COMPUTE FINAL IR SCORE
###############################################################
results <- data %>%
  rowwise() %>%
  mutate(
    points_l1 = sum(
      attempt_points(a1_1_clean, t1_1_clean, d1_1_clean, e1_1_clean, p1_1, 1),
      attempt_points(a2_1_clean, t2_1_clean, d2_1_clean, e2_1_clean, p2_1, 1),
      attempt_points(a3_1_clean, t3_1_clean, d3_1_clean, e3_1_clean, p3_1, 1),
      attempt_points(a4_1_clean, t4_1_clean, d4_1_clean, e4_1_clean, p4_1, 1)
    ),
    points_l2 = sum(
      attempt_points(a1_2_clean, t1_2_clean, d1_2_clean, e1_2_clean, p1_2, 2),
      attempt_points(a2_2_clean, t2_2_clean, d2_2_clean, e2_2_clean, p2_2, 2),
      attempt_points(a3_2_clean, t3_2_clean, d3_2_clean, e3_2_clean, p3_2, 2),
      attempt_points(a4_2_clean, t4_2_clean, d4_2_clean, e4_2_clean, p4_2, 2)
    ),
    points_l3 = sum(
      attempt_points(a1_3_clean, t1_3_clean, d1_3_clean, e1_3_clean, p1_3, 3),
      attempt_points(a2_3_clean, t2_3_clean, d2_3_clean, e2_3_clean, p2_3, 3),
      attempt_points(a3_3_clean, t3_3_clean, d3_3_clean, e3_3_clean, p3_3, 3),
      attempt_points(a4_3_clean, t4_3_clean, d4_3_clean, e4_3_clean, p4_3, 3)
    ),
    repertoire_points = compute_repertoire(
      repertoire = c(r1_1_clean, r2_1_clean, r3_1_clean, r4_1_clean,
                     r1_2_clean, r2_2_clean, r3_2_clean, r4_2_clean,
                     r1_3_clean, r2_3_clean, r3_3_clean, r4_3_clean),
      efficacy = c(e1_1_clean, e2_1_clean, e3_1_clean, e4_1_clean,
                   e1_2_clean, e2_2_clean, e3_2_clean, e4_2_clean,
                   e1_3_clean, e2_3_clean, e3_3_clean, e4_3_clean)
    ),
    total_score = points_l1 + points_l2 + points_l3 + repertoire_points,
    ir = total_score * 100 / 68
  ) %>%
  ungroup()


###############################################################
### 7. EXPORT ANALYSIS DATASET
###############################################################
hwtai_analysis <- results %>%
  select(id, expertise, assessment_time, observer, observation_time, ir)

write_xlsx(hwtai_analysis, "hwtai_analysis.xlsx")