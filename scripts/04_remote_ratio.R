library(tidyverse)
library(readr)
library(scales)

# Load cleaned job data
job_data <- read_csv("data/cleaned_job_data.csv")

# Count and calculate percent
remote_summary <- job_data %>%
  filter(!is.na(onsite_remote)) %>%
  count(onsite_remote, name = "n") %>%
  mutate(
    onsite_remote = str_to_title(onsite_remote),
    percent = n / sum(n),
    label = paste0(onsite_remote, ": ", percent(percent))
  )

# Print summary
print(remote_summary)

# Create output folder if needed
if (!dir.exists("visualizations")) dir.create("visualizations")

# Plot pie chart with percentage labels
plot <- ggplot(remote_summary, aes(x = "", y = n, fill = onsite_remote)) +
  geom_col(width = 1, color = "white") +
  coord_polar("y") +
  theme_void() +
  labs(title = "Job Location Type Distribution") +
  geom_text(aes(label = label), position = position_stack(vjust = 0.5), size = 4.5) +
  scale_fill_manual(values = c(
    "Remote" = "#1f77b4",
    "Hybrid" = "#2ca02c",
    "Onsite" = "#ff7f0e"
  ))

# Save chart
ggsave("visualizations/remote_vs_onsite.png", plot, width = 6, height = 6)

cat("Pie chart with percentages saved to visualizations/remote_vs_onsite.png\n")
