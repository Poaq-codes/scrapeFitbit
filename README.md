# scrapeFitbit
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
  7) DISABLE 2 FACTOR AUTHENTICATION ON FITBIT. If you have it enabled, selenium won't be able to continue on because of the required manual input of the security code.

Generally, once it's set up, the script can be run from whatever directory it's in with `python3 scrapeFitbitData.py`.

Since this script grabs data for the past week, you should run it once a week at roughly the same time. If you're on Linux (maybe Mac, but I'm not sure), the easiest way to do this is to set up a cronjob to execute the script. I assume there's something similar for Windows to accomplish the same thing, but I'm not familiar.
