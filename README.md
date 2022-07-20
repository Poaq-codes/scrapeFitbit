# scrapeFitbit
Apparently I am integrating a bit more than Fitbit, but... yeah. That was the original intent.
------------------------------------------------------------------------------------------------
A couple of scripts to help download your fitbit data without having to do it manually. Amenable to integration into cronjobs (only slight exception is the archive download has a limit of 1 request per 24 hours).

**2FA MUST BE DISABLED ON YOUR ACCOUNT FOR THIS TO WORK**

Fitbit's 2FA requires you to manually enter text codes, which makes it not amenable to automation via crontab.

## scrapeFitbitData.py
Python script that uses selenium to download the data export csv file for THE PAST WEEK.

Written for Linux, but should run on Windows if you:
  1) Comment out line 41
  2) Uncomment line 48

A few things have to be modified/set up by the user:
  1) Your system needs python 3 installed
  2) You need the `selenium` packge for python. The easiest way to go about this would be to download and install `pip` to manage your packages, then get selenium with `pip install selenium`. The exact command may vary, e.g. `pip3 install selenium`.
  3) You need to download the chrome webdriver for your version of Chrome. "Help -> About Google Chrome" should give you the version number. Then head [here](https://chromedriver.chromium.org/downloads) and download whichever version you need.
  4) The path in line 41 or 48 needs to be changed to wherever you kept your chrome webdriver file. For Linux, this can be basically anywhere as long as you provide the full path. For Windows, it seems to be easiest to keep it in `Program Files (x86)`.
  5) Line 73 should be replaced with your Fitbit email address
  6) Line 76 should be replaced with your Fitbit account password
  7) **DISABLE 2 FACTOR AUTHENTICATION ON FITBIT**. If you have it enabled, selenium won't be able to continue on because of the required manual input of the security code.

Generally, once it's set up, the script can be run from whatever directory it's in with `python3 scrapeFitbitData.py`.

Since this script grabs data for the past week, you should run it once a week at roughly the same time. If you're on Linux (maybe Mac, but I'm not sure), the easiest way to do this is to set up a cronjob to execute the script. I assume there's something similar for Windows to accomplish the same thing, but I'm not familiar.


## scrapeFitbitDataArchive.py
Python script that uses selenium to download complete data archive.

For some reason, Fitbit only gives you heartrate and... many other things if you download your account's entire archive.

This functions essentially the same as described above, so follows those steps for setup. The only big differences:

  1) Webdriver path is line 27, Username and password go to lines 56 and 59, respectively.
  2) Most importantly, **YOU MUST VERIFY YOUR DOWNLOAD REQUEST VIA EMAIL.** Part of downloading the archive sends an email to your fitbit account email address, and you have to click the link contained in the email. I did not automate this because it requires access to your email account and can vary based on who hosts that account (gmail vs. protonmail vs. outlook, etc.), but it's something I may work on later.

You are technically limited to 1 request per 24 hour period with this. Further, each request "lasts" about 7 days, so you can download old requests up to a week after the intial request.


## uploadData.R
An R script that makes use of the [googledrive](https://googledrive.tidyverse.org/) R package to upload results from fitbit webscraping to Google Drive. You can download R [here](https://cloud.r-project.org/). You next need to install the `googledrive` package:

  1) Launch R
  2) type `install.packages('googledrive')`, and the package will be downloaded and installed
  3) Close R

Next, we need to set up `googledrive` to work with your account:

  1) Launch R
  2) type `drive_auth()` -- this will prompt a few things. The main thing here is we're giving the package permission to edit your google drive.
  3) Allow R to store the token between sessions
  4) A webpage should pop up asking you to sign into your Google account
  5) Sign in your account
  6) Check the bottom box to give the tidyverse/googledrive permission to create, edit, and delete files
  7) Close R

Now, edit the R script with your information:

  1) Line 21 - enter your email
  2) Line 29 - paste the link to the folder on google drive that will hold your data
  3) Line 34 - enter the path to your local file that you're trying to upload
  4) OPTIONAL - Line 40 - enter the file name here if it's not the default fitbit name for the current date
  5) Lines 52, 57, 63 the same as 2-4 above, but for fitbit archive data
  6) 74 and 77 - google drive link and local directory

If you don't want either the archive or non-archive data upload, simply comment out the lines.

To run the script, open a console, navigate to the directory holding the script, and type `Rscript uploadData.R`.


## downloadData.R
This script is essentially a companion script to `uploadData.R`. It is not generally needed unless you plan on primarily storing your data on google drive instead of locally.

I recommend having a working directly that is empty except for the fitbit files you're about to download. Because `drive_download` doesn't seem to play nicely with lists of files being saved to non-working directory locations, these files must first be downloaded to the current working directory, then moved to their respective destination directories. This means that any other files in the working directory with `.csv` or `.zip` extensions will be caught up in the move operation.

Setup is the same as `uploadData.R`, but additionally requires the [purrr](https://purrr.tidyverse.org/) package. You can either install `purrr` alone, or install the entire `tidyverse` package. Either way will allow access to the package.

Edit the following lines:

  1) Line 21 - enter your email
  2) Lines 36 and 60 - enter the paths to your local storage directories for fitbit weekly downloads and fitbit archive downloads, respectively
  3) 39 and 63 - enter the google drive folder links to where your fitbit weekly downloads and fitbit archive downloads are stored, respectively
  4) 82 and 85 - enter local directory and google drive folder for time log data 
 
 The script can be executed from command line with `Rscript downloadData.R`.
