#' Name         : trial.R
#' Author       : Alexandre Bohyn
#' Date         : 01 Jan 2025
#' Purpose      : Read the raw csv file with the trial data and save it as an
#'                R data file.
#' Files created: `data/processed/trial.rds`
#' Edits        :
#'              - 01 Jan 2025: First version.
#'              - 05 Jan 2025: Added variable labels.

# Packages ----------------------------------------------------------------

library(tidyverse)
library(here)
library(labelled)

# Read the raw data -------------------------------------------------------

raw <- read_delim(
  file = here("data/raw/trial_data_FINAL_v3.0.csv"),
  delim = ",",
  show_col_types = FALSE
)

# Clean, rename and label -------------------------------------------------

# Rename with snake_case
data <- raw |>
  select(-1) |>
  rename(
    biomarker = marker,
    tumor_stage = stage,
    tumor_grade = grade,
    treatment_response = response,
    event = death,
    time_to_event = ttdeath
  ) |>
  # Convert treatment, stage and grade to factors
  mutate(
    trt = as.factor(trt),
    tumor_grade = factor(tumor_grade, levels = c("I", "II", "III")),
    tumor_stage = factor(tumor_stage, levels = paste0("T", 1:4))
  ) |>
  # Add variable labels
  set_variable_labels(
    trt = "Treatment group",
    age = "Age at enrollment (years)",
    biomarker = "Biomarker level",
    tumor_stage = "Tumor stage",
    tumor_grade = "Tumor grade",
    treatment_response = "Response to treatment",
    event = "Death",
    time_to_event = "Time to event (days)"
  )

# Save the processed data -------------------------------------------------

saveRDS(data, file = here("data/processed/trial.rds"))
