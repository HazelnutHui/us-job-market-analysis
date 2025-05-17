setwd("/Users/hui/github/us-job-market-analysis")

library(tidyverse)
library(readr)

# Load cleaned job data
job_data <- read_csv("data/cleaned_job_data.csv")

# Count number of jobs by city
city_counts <- job_data %>%
  count(location, sort = TRUE) %>%
  slice_max(n, n = 10)

# Print top cities
print(city_counts)

# Create output folder if it doesn't exist
if (!dir.exists("visualizations")) dir.create("visualizations")

# Plot top 10 cities
plot <- ggplot(city_counts, aes(x = reorder(location, n), y = n)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(title = "Top 10 Cities by Data Analyst Job Postings",
       x = "City",
       y = "Number of Jobs") +
  theme_minimal()

# Save the plot
ggsave("visualizations/top_cities.png", plot, width = 8, height = 5)

cat("Top cities plot saved to visualizations/top_cities.png\n")
