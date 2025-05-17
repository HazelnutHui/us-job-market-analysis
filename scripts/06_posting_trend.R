library(tidyverse)
library(readr)
library(lubridate)

# Load cleaned data
job_data <- read_csv("data/cleaned_job_data.csv")

# Ensure the date column exists and is in date format
if (!"posted_date" %in% colnames(job_data)) {
  stop("No 'posted_date' column found. Check your dataset.")
}

# Convert to Date format if needed
job_data <- job_data %>%
  mutate(posted_date = as_date(posted_date))

# Count number of jobs per week
trend_df <- job_data %>%
  mutate(posting_week = floor_date(posted_date, "week")) %>%
  count(posting_week)

# Create output folder if it doesn't exist
if (!dir.exists("visualizations")) dir.create("visualizations")

# Plot time series
plot <- ggplot(trend_df, aes(x = posting_week, y = n)) +
  geom_line(color = "steelblue", size = 1) +
  geom_point(size = 2, color = "darkblue") +
  labs(title = "Weekly Trend of Data Analyst Job Postings",
       x = "Week Posted",
       y = "Number of Jobs") +
  theme_minimal()

# Save the plot
ggsave("visualizations/posting_trend.png", plot, width = 8, height = 5)

cat("Posting trend plot saved to visualizations/posting_trend.png\n")

