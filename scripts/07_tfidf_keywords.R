library(tidyverse)
library(tidytext)
library(stopwords)
library(readr)
library(ggplot2)

# Load data
job_data <- read_csv("data/cleaned_job_data.csv")

# Tokenize by company
words_by_company <- job_data %>%
  select(company, description) %>%
  unnest_tokens(word, description) %>%
  filter(!word %in% stopwords("en")) %>%
  filter(str_length(word) > 2) %>%
  count(company, word, sort = TRUE)

# Compute tf-idf
tfidf <- words_by_company %>%
  bind_tf_idf(word, company, n) %>%
  arrange(desc(tf_idf))

# Select top 10 tf-idf words per company (limit to top companies only to reduce clutter)
top_companies <- job_data %>%
  count(company, sort = TRUE) %>%
  slice_max(n, n = 5) %>%
  pull(company)

top_tfidf <- tfidf %>%
  filter(company %in% top_companies) %>%
  group_by(company) %>%
  slice_max(tf_idf, n = 5) %>%
  ungroup()

# Create output folder if needed
if (!dir.exists("visualizations")) dir.create("visualizations")

# Plot
plot <- ggplot(top_tfidf, aes(x = tf_idf, y = reorder(word, tf_idf), fill = company)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~company, scales = "free_y") +
  labs(title = "Top TF-IDF Keywords by Company",
       x = "TF-IDF Score",
       y = "Keyword") +
  theme_minimal()

# Save plot
ggsave("visualizations/tfidf_keywords.png", plot, width = 10, height = 6)

cat("TF-IDF keyword chart saved to visualizations/tfidf_keywords.png\n")
