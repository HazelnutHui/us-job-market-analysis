setwd("/Users/hui/github/us-job-market-analysis")

library(tidyverse)
library(readr)

# Load cleaned job data
job_data <- read_csv("data/cleaned_job_data.csv")

# Classify each job as Remote / On-site / Unknown
remote_classified <- job_data %>%
  mutate(work_type = case_when(
    str_detect(tolower(location), "remote") ~ "Remote",
    str_detect(tolower(location), "on[- ]?site") ~ "On-site",
    TRUE ~ "Unspecified"
  )) %>%
  count(work_type)

# Print summary
print(remote_classified)

# Create output folder if it doesn't exist
if (!dir.exists("visualizations")) dir.create("visualizations")

# Plot pie chart
plot <- ggplot(remote_classified, aes(x = "", y = n, fill = work_type)) +
  geom_col(width = 1) +
  coord_polar("y") +
  theme_void() +
  labs(title = "Remote vs On-site Job Distribution") +
  scale_fill_manual(values = c("Remote" = "#1f77b4", "On-site" = "#ff7f0e", "Unspecified" = "#999999"))

# Save pie chart
ggsave("visualizations/remote_vs_onsite.png", plot, width = 6, height = 6)

cat("Remote vs On-site chart saved to visualizations/remote_vs_onsite.png\n")
