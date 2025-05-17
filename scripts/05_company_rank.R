library(tidyverse)
library(readr)

# Load cleaned job data
job_data <- read_csv("data/cleaned_job_data.csv")

# Count number of jobs by company
company_counts <- job_data %>%
  count(company, sort = TRUE) %>%
  slice_max(n, n = 10)

# Print top 10 companies
print(company_counts)

# Create output folder if it doesn't exist
if (!dir.exists("visualizations")) dir.create("visualizations")

# Plot top companies
plot <- ggplot(company_counts, aes(x = reorder(company, n), y = n)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(title = "Top 10 Companies by Job Postings",
       x = "Company",
       y = "Number of Jobs") +
  theme_minimal()

# Save the plot
ggsave("visualizations/top_companies.png", plot, width = 8, height = 5)

cat("Top companies plot saved to visualizations/top_companies.png\n")
