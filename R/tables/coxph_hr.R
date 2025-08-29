#' Name         : coxph_hr.R
#' Author       : Alexandre Bohyn
#' Date         : 2025-08-29
#' Purpose      : Create a table of hazard ratios from a Cox proportional hazards model
#'               using the `trial` dataset with covariates: treatment, age (as a spline term)
#'              tumor stage, tumor grade.
#' Files created: `outputs/tables/coxph_hr.rds`
#' Edits        :

# Packages ----------------------------------------------------------------

library(survival)
library(gtsummary)
library(rms)

# Load the processed data -------------------------------------------------

trial <- readRDS(here::here("data/processed/trial.rds"))

# Fit the Cox proportional hazards model ----------------------------------

fit <- coxph(
  Surv(time_to_event, event) ~ trt + tumor_stage + tumor_grade + rcs(age, 4),
  data = trial
)
cox.zph(fit)

# Create the table of hazard ratios ---------------------------------------

tbl <- tbl_regression(fit, exponentiate = TRUE) |>
  add_global_p()

# Save the table ----------------------------------------------------------

saveRDS(
  object = tbl,
  file = here::here("data/tables/coxph_hr.rds")
)
# gtsummary::as_flex_table(tbl) |>
# flextable::save_as_docx(path = here::here("output/tables/coxph_hr.docx"))
tbl |>
  gtsummary::as_gt() |>
  # gt::gtsave(filename = here::here("output/tables/coxph_hr.docx"))
  gt::gtsave(filename = here::here("output/tables/coxph_hr.html"))
