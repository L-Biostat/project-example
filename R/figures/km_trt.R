#' Name         : km_trt.R
#' Author       : Alexandre Bohyn
#' Date         : 2025-08-29
#' Purpose      : Kaplan-Meier survival curves by treatment group.
#' Files created: `output/figures/km_trt.png`
#' Edits        :

# Packages ----------------------------------------------------------------

library(ggsurvfit)
library(survival)

# Read the processed data -------------------------------------------------

trial <- readRDS(here::here("data/processed/trial.rds"))

# Create the Kaplan-Meier plot --------------------------------------------

# Create the survfit object
fit <- survfit2(Surv(time_to_event, event) ~ trt, data = trial)

# Create the plot
ggsurvfit(fit) +
  add_confidence_interval() +
  add_risktable() +
  add_censor_mark() +
  add_pvalue(location = "annotation", caption = "Log-rank test: {p.value}") +
  labs(
    x = "Time (days)",
    y = "Survival Probability (%)"
  ) +
  see::scale_color_material() +
  see::scale_fill_material()

# Save the plot -----------------------------------------------------------

ggsave(
  filename = here::here("output/figures/km_trt.png"),
  width = 6,
  height = 4,
  dpi = 300
)
