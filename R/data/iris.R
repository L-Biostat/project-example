#' Name         : iris.R
#' Author       : Alexandre Bohyn
#' Date         : 01 Jan 2025
#' Purpose      : Read the raw iris csv file and save it as an R data file.
#' Files created: `data/processed/iris.rds`
#' Edits        :
#'              - 01 Jan 2025: First version.
#'              - 05 Jan 2025: Added variable labels.

# Packages ----------------------------------------------------------------

library(tidyverse)
library(here)
library(labelled)

# Read the raw data -------------------------------------------------------

raw <- read_delim(
  file = here("data/raw/iris_data_file.csv"),
  delim = ",",
  show_col_types = FALSE
)


# Clean, rename and label -------------------------------------------------

# Rename with snake_case
data <- raw %>%
  rename(
    sepal_length = Sepal.Length,
    sepal_width  = Sepal.Width,
    petal_length = Petal.Length,
    petal_width  = Petal.Width,
    species      = Species,
    id           = `Plant id`
  )  |> 
  # Convert id and species to factors
  mutate(
    id = as.factor(id),
    species = factor(species, levels = c("setosa", "versicolor", "virginica")) |> 
      fct_relabel(.fun = str_to_title)
  ) |> 
  # Add variable labels
  set_variable_labels(
    sepal_length = "Sepal Length (cm)",
    sepal_width  = "Sepal Width (cm)",
    petal_length = "Petal Length (cm)",
    petal_width  = "Petal Width (cm)",
    species      = "Iris Species",
    id           = "Plant ID"
  )

# Save the processed data -------------------------------------------------

saveRDS(data, file = here("data/processed/iris.rds"))
