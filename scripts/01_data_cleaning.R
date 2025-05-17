library(tidyverse)
library(readr)

input_file <- "data/linkedin-jobs-usa.csv"
output_file <- "data/cleaned_job_data.csv"

df_raw <- read_csv(input_file)

df_clean <- df_raw %>%
  rename_with(~tolower(gsub(" ", "_", .))) %>%
  distinct() %>%
  filter(
    !is.na(title),
    !is.na(company),
    !is.na(location),
    !is.na(description)
  ) %>%
  mutate(across(c(title, company, location), str_trim))

write_csv(df_clean, output_file)

cat("Cleaned data saved to", output_file, "\n")
