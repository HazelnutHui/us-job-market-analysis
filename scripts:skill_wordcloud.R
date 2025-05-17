setwd("/Users/hui/github/us-job-market-analysis")

library(tidyverse)
library(tidytext)
library(wordcloud2)
library(stopwords)
library(readr)
library(htmlwidgets)

# Load cleaned job data
job_data <- read_csv("data/cleaned_job_data.csv")

# Tokenize job descriptions into words and calculate word frequency
word_df <- job_data %>%
  select(title, company, location, description) %>%
  unnest_tokens(word, description) %>%
  filter(!word %in% stopwords("en")) %>%
  filter(str_length(word) > 2) %>%
  count(word, sort = TRUE)

# Print top 20 words
print(head(word_df, 20))

# Generate a word cloud from top 100 frequent words
wc <- wordcloud2(word_df[1:100, ])

# Create output folder if it doesn't exist
if (!dir.exists("visualizations")) dir.create("visualizations")

# Save the word cloud as an HTML file
saveWidget(wc, "visualizations/wordcloud.html", selfcontained = TRUE)

cat("Wordcloud saved to visualizations/wordcloud.html\n")
