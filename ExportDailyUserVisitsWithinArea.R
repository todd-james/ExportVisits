# Script to subset visit location data 
# Gets all visit locations for a given date range for users that visit a given area 


# Load necessary libraries
library(sf)
library(lubridate)
library(dplyr)

# Check the number of command-line arguments
if (length(commandArgs(trailingOnly = TRUE)) < 7) {
  cat("Usage: Rscript your_script.R data_path start_date end_date min_lon min_lat max_lon max_lat prefix\n")
  quit(status = 1)
}

# Parse command-line arguments
data_path <- commandArgs(trailingOnly = TRUE)[1]
start_date <- ymd(commandArgs(trailingOnly = TRUE)[2])
end_date <- ymd(commandArgs(trailingOnly = TRUE)[3])
min_lon <- as.numeric(commandArgs(trailingOnly = TRUE)[4])
min_lat <- as.numeric(commandArgs(trailingOnly = TRUE)[5])
max_lon <- as.numeric(commandArgs(trailingOnly = TRUE)[6])
max_lat <- as.numeric(commandArgs(trailingOnly = TRUE)[7])
prefix <- commandArgs(trailingOnly = TRUE)[8]

# Load Mesh Data
mesh6 <- st_read("GRID6.shp")
mesh6 <- mesh6[, 3]
mesh6_wgs <- st_transform(mesh6, crs = 4326)

read_files_into_dataframe <- function(directory, pattern) {
  files <- list.files(path = directory, pattern = pattern, full.names = TRUE)
  data_frames <- lapply(files, read.csv)  # Change read.csv to your specific file-reading function if needed
  combined_data <- do.call(rbind, data_frames)
  return(combined_data)
}

# Define the data_date_subset function
data_date_subset <- function(data, start_date, end_date) {
  data$date <- ymd_hms(data$start)
  return(data %>% filter(date(date) >= start_date & date(date) <= end_date))
}

# Define the data_area_daily_users function
data_area_daily_users <- function(data, min_lat, min_lon, max_lat, max_lon, prefix) {
  # Get all distinct dates from the "date" column
  distinct_dates <- unique(date(data$date))
  
  # Create a loop to get unique UUIDs for each date
  for (i in 1:length(distinct_dates)) {
    day <- distinct_dates[i]
    
    unique_uuids <- data %>%
      filter(date(date) == day &
               lat >= min_lat & lat <= max_lat &
               long >= min_lon & long <= max_lon) %>%
      distinct(uuid)
    
    unique_uuids <- unique_uuids$uuid
    
    fname <- paste0(prefix, "-", day, ".csv" )
    
    day_subset <- data %>%
      filter(date(date) == day &
               uuid %in% unique_uuids)
    
    day_subset <- st_as_sf(day_subset, coords = c("long", "lat"))
    day_subset <- st_set_crs(day_subset, 4326)
    day_subset <- st_join(day_subset, mesh6_wgs)
    
    day_subset <- cbind(st_drop_geometry(day_subset), st_coordinates(day_subset))
    
    output_file <- file.path(getwd(), fname)
    write.csv(day_subset[,c(1:4,6:8)], output_file, row.names = FALSE)
  }
}

# Create the search pattern based on start and end dates
if (format(start_date, "%Y%m") == format(end_date, "%Y%m")) {
  search_pattern <- format(start_date, "%Y%m")
} else {
  search_pattern <- paste0("^", format(start_date, "%Y%m"), "|^", format(end_date, "%Y%m"))
}

# Load the data based on the search pattern
data <- read_files_into_dataframe(data_path, search_pattern)

# Subset the data based on the provided date range
data <- data_date_subset(data, start_date, end_date)

# Call the data_area_daily_users function
data_area_daily_users(data, min_lat, min_lon, max_lat, max_lon, prefix)
