##################################################
# Author: Poaq
# Date: 2022-06-07
#
# Purpose: 1) Automatically sync Fitbit 
#             data to Google Drive
##################################################

#~~~~~~~~~~~~~~~~~~#
# libraries ----
#~~~~~~~~~~~~~~~~~~#
library(googledrive)


#~~~~~~~~~~~~~~~~~~#
# functions ----
#~~~~~~~~~~~~~~~~~~#

# Not a function, but set user
# Enter your email address here -- required for the script to work
drive_auth(email = "youremail@address.com")


#~~~~~~~~~~~~~~~~~~#
# sync fitbit weekly to google drive ----
#~~~~~~~~~~~~~~~~~~#
# the directory on google drive that will hold our data
# copy/paste the link to your target folder on google drive
td_fitbit <- drive_get("LINK TO FOLDER GOES HERE")

# the directory where our data is stored locally
# point this to the path where your data is stored -- INCLUDE the trailing slash as shown
# Recommended to keep forward slashes -- R will interpret them correctly even on Windows
fitbit_week_dir <- paste0("C:/path/to/local/data/folder/")

# filename
# you can modify this as needed, but by default it grabs the current date's download
# if you need an old file or renamed file, you can modify the line as follows:
# fitbit_week_string <- paste0("myfilename.csv")
fitbit_week_string <- paste0("fitbit_export_", format(Sys.time(), "%Y%m%d"), ".csv")

# upload the file
drive_upload(media = paste0(fitbit_week_dir, fitbit_week_string), path = as_id(td_fitbit),
             name = fitbit_week_string)


#~~~~~~~~~~~~~~~~~~#
# sync fitbit archive to google drive ----
#~~~~~~~~~~~~~~~~~~#
# the directory on google drive that will hold our data
# copy/paste the link to your target folder on google drive
td_archive <- drive_get("LINK TO FOLDER GOES HERE")

# the directory where our data is stored locally
# point this to the path where your data is stored -- INCLUDE the trailing slash as shown
# Recommended to keep forward slashes -- R will interpret them correctly even on Windows
fitbit_archive_dir <- paste0("C:/path/to/local/data/folder/")

# filename
# you can modify this as needed, but by default it grabs the default zip download name
# if you need an old file or renamed file, you can modify the line as follows:
# fitbit_week_string <- paste0("myfilename.zip")
fitbit_archive_string <- paste0("MyFitbitData.zip")

# upload the file
drive_upload(media = paste0(fitbit_archive_dir, fitbit_archive_string), path = as_id(td_archive),
             name = fitbit_archive_string)

