##################################################
# Author: Poaq
# Date: 2022-07-10
#
# Purpose: 1) Automatically download data to local
#             storage from google drive
##################################################

#~~~~~~~~~~~~~~~~~~#
# libraries ----
#~~~~~~~~~~~~~~~~~~#
library(googledrive)
library(purrr)


#~~~~~~~~~~~~~~~~~~#
# functions ----
#~~~~~~~~~~~~~~~~~~#

## Not a function, but set user
drive_auth(email = "youremail@address.com")


#~~~~~~~~~~~~~~~~~~#
# variables ----
#~~~~~~~~~~~~~~~~~~#
# drive download doesn't like downloading n > 1 files to non wd, so set a variable
wd <- getwd()


#~~~~~~~~~~~~~~~~~~#
# download fitbit weekly ----
#~~~~~~~~~~~~~~~~~~#

# make variables for target dir
fitbit_week_dir <- "local/directory/for/fitbit/weekly/files"

# folder on google drive with our files
td_fitbit <- drive_get("FITBIT WEEKLY DOWNLOAD FOLDER LINK")

# make a list of the csv files in that folder
csv_files <- drive_ls(td_fitbit, type = "csv")

# walk down the list and download each file
walk(csv_files$id, ~ drive_download(as_id(.x)))

# since we have to download to wd, we need to move the files
fitbit_files <- list.files(pattern = ".csv")
for (file in fitbit_files){
  file.rename(from = paste0(wd, "/", file),
              to = paste0(fitbit_week_dir, file))
}


#~~~~~~~~~~~~~~~~~~#
# download fitbit archive ----
#~~~~~~~~~~~~~~~~~~#

# make variables for target dir
fitbit_archive_dir <- "local/directory/for/fitbit/archive/files"

# folder on google drive with our files
td_archive <- drive_get("FITBIT ARCHIVE DOWNLOAD FOLDER LINK")

# make a list of the zip files in that folder
zip_files <- drive_ls(td_archive, type = "zip")

# walk down the list and download each file
walk(zip_files$id, ~ drive_download(as_id(.x)))

archive_files <- list.files(pattern = ".zip")
for (file in archive_files){
  file.rename(from = paste0(wd, "/", file),
              to = paste0(fitbit_archive_dir, file))
}


#~~~~~~~~~~~~~~~~~~#
# download time log ----
#~~~~~~~~~~~~~~~~~~#
# make variables for target dir
time_log_dir <- "local/directory/for/time/log/files"

# folder on google drive with our files
td_time_log <- drive_get("TIME LOG DOWNLOAD FOLDER LINK")

# make a list of the csv files in that folder
csv_files <- drive_ls(td_time_log, type = "csv")

# walk down the list and download each file
walk(csv_files$id, ~ drive_download(as_id(.x)))

# since we have to download to wd, we need to move the files
time_log_files <- list.files(pattern = ".csv")
for (file in time_log_files){
  file.rename(from = paste0(wd, "/", file),
              to = paste0(time_log_dir, file))
}
