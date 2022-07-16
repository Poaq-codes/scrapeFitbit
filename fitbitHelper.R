################################################################################
# Author: Poaq
#
# Date: 2022-07-12
#
# Purpose: Functions for working with fitbit data
################################################################################

# # requires the following packages:
# library(data.table)
# library(tidyverse)
# library(lubridate)

# converts column called "Date" into class Date
# can be ignored -- called later in `makeFitbitWeeklyDataframe`
makeDateClass <- function(df_list){
for (i in seq_along(df_list)){
  df_list[[i]]$Date <- as.Date(df_list[[i]]$Date)
}
return(df_list)
}


# index NAs -- can be ignored; called in `collapse`
filter_NA <- function(x) x[!is.na(x)]
# collapse rows with duplicate dates and NAs into 1 row
# can be ignored -- called later in `makeFitbitWeeklyDataframe`
collapse <- function(df){
  df <- df %>%
    group_by(Date) %>%
    summarise_all(funs(filter_NA(.)))
  return(df)
}


# Function to read in an arbitrary number of csv from fitbit weekly exports,
#     parse them, then merge them into 1 dataframe based on the date
# This function assumes the data is generated from the weekly export, e.g. as in
#     `scrapeFitbitData.py`
# Input should be a character vector from `list.files()` or similar consisting
#     of paths to the fitbit csv files
# I personally have a Charge 5, so I am unsure if other devices output
#     extra/less data or data in different formats
# Returns a dataframe
makeFitbitWeeklyDataframe <- function(file_list){
  
  # first make an empty list of proper length
  fitbit_list <- vector(mode = "list", length = length(file_list))
  
  # initialize counter
  i <- 1
  
  # iterate
  for (file in file_list){
    
    # the format for these is terrible -- we essentially have to read in "chunks"
    # assumes you have exported 1 week at a time
    
    # read first chunk
    tmp <- read.table(file = file, sep = ",",
                      fill = TRUE, blank.lines.skip = FALSE,
                      header = FALSE, nrows = 19)
    
    # grab weights
    tmp_weight <- tmp[3:9, ]
    colnames(tmp_weight) <- tmp[2,]
    
    # grab calories in
    tmp_cals <- tmp[13:19, 1:2]
    colnames(tmp_cals) <- tmp[12, 1:2]
    
    # read second chunk
    tmp2 <- read.table(file = file, sep = ",",
                       fill = TRUE, blank.lines.skip = FALSE,
                       header = FALSE, skip = 20, nrows = 19)
    
    # grab activity
    tmp_activity <- tmp2[3:9, ]
    colnames(tmp_activity) <- tmp2[2, ]
    
    # grab sleep stats
    tmp_sleep <- tmp2[13:19, -c(1, 10)]
    colnames(tmp_sleep) <- tmp2[12, -c(1, 10)]
    
    # dates are going to be off-by-1
    # easiest method for getting the correct date is probably to take end time and subtract 1 day
    #   this method will help avoid weird am/pm parsing (e.g. going to sleep at 1am and waking up at 10am)
    
    # removes timestamps
    tmp_sleep$`End Time` <- gsub(pattern = "(.*)-(.*)-(.*) [0-9]+:[0-9]+[A-Z]+",
                                 replacement = "\\1-\\2-\\3",
                                 x = tmp_sleep$`End Time`)
    colnames(tmp_sleep)[1] <- "Date"
    
    # make Date Class and subtract 1 day
    tmp_sleep$Date <- as.Date(tmp_sleep$Date) - 1
    
    # put each individual df into a list
    fitbit_week_list <- list(tmp_weight, tmp_cals,
                             tmp_activity, tmp_sleep)
    
    # change all 'Date' columns to Date class
    fitbit_week_list <- makeDateClass(df_list = fitbit_week_list)
    
    # reduce list to a dataframe by 'Date'
    fitbit_week_merged <- reduce(.x = fitbit_week_list,
                                 full_join, by = 'Date')
    
    # sort by date and reset row names/values
    fitbit_week_merged <- fitbit_week_merged[order(fitbit_week_merged$Date),]
    rownames(fitbit_week_merged) <- NULL
    
    # put this new df into a list
    fitbit_list[[i]] <- fitbit_week_merged
    
    # increment counter
    i <- i + 1
  }
  
  # bind each week's final dataframe into a single large dataframe
  fitbit <- rbindlist(fitbit_list)
  
  # need to collapse duplicated dates
  # this will remove any date containing NAs
  # this occurs at "breakpoint" dates between weeks if it's not "duplicated"
  final <- collapse(df = fitbit)
  
  return(final)
}