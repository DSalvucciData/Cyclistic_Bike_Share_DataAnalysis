# Install the bigrquery package
install.packages("bigrquery")

# Load the bigrquery library
library(bigrquery)

# Authenticate your Google account
# Ensure proper authentication setup
# You can use bq_auth() for interactive authentication or load credentials from a .json service account key file
# It is recommended to use environment variables or .env files for sensitive credentials
bq_auth()  # This will ask for authentication interactively

# Define the project ID using an environment variable
# Replace 'BIGQUERY_PROJECT_ID' with your environment variable name
project_id <- Sys.getenv("BIGQUERY_PROJECT_ID")  # Make sure to set this in your environment

# Define the SQL query to retrieve data from the table
# Replace 'your_project.your_dataset.your_table' with your BigQuery table path
sql <- "SELECT * FROM `your_project.your_dataset.your_table`"

# Run the SQL query and store the results in a dataframe in R
query_results <- bq_project_query("project_id", sql)

# Download the data into an R dataframe
df_cleaned_data <- bq_table_download(query_results)

# Display the first few records of the dataframe
head(df_cleaned_data)

# Optionally convert date columns to string format before exporting (if needed)
df_cleaned_data$started_at <- as.character(df_cleaned_data$started_at)
df_cleaned_data$ended_at <- as.character(df_cleaned_data$ended_at)

# Export the cleaned data to a CSV file
# Replace 'path/to/file.csv' with the actual path where you want to save the CSV file
write.csv(df_cleaned_data, "path/to/file.csv", row.names = FALSE, na = "")
