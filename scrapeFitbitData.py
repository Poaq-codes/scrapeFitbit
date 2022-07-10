"""
Created on 2022-06-23

Author: Poaq
"""

#%%
# import modules
# --------------- #

from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.keys import Keys

import time

#%%
########## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ##########
########## YOU NEED TO DISABLE 2FA FOR THIS TO WORK ##########
########## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ##########


# this is generally a hacky implementation using specific URLs to the
#       data export page after you log in, but it works
# using a time.sleep() call also sacrifices runtime, but again, very easy
#       to implment

# could be improved with specific selenium wait commands
# could be improved by spending more time tracking elements on the fitbit page

#%%
# Set webdriver requirements
# ------------------------ #

# set path for driver -- we're using Chrome here
# the chrome webdriver seems to play nicer than FF

########## FOR LINUX ##########

PATH = Service("/path/to/chromdriver")

########## ~~~~~~~~~ ##########


########## FOR WINDOWS ##########

# PATH = Service("C:/Program Files (x86)/chromedriver.exe")

########## ~~~~~~~~~~~ ##########


########## HEADLESS OR NOT ##########
options = Options()
# these two lines can be commented out if you don't need it to be headless
## ~~~~~ ##
options.add_argument("--headless")
options.add_argument("--disable-gpu")
## ~~~~~ ##
driver = webdriver.Chrome(service = PATH, options = options)
########## ~~~~~~~~~~~~~~~ ##########

#%%
# Get Fitbit data
# -------------- #

## point to the website and open browser
driver.get("https://accounts.fitbit.com/login?targetUrl=https%3A%2F%2Fwww.fitbit.com%2Fglobal%2Fus%2Fhome")
time.sleep(10)

## find username and password fields and enter them
username = driver.find_element_by_xpath("//input[@placeholder='Your account email']")
username.send_keys("youremailaddress@email.com")

password = driver.find_element_by_xpath("//input[@placeholder='Enter your secure password']")
password.send_keys("yourfitbitpasswordhere")
password.send_keys(Keys.RETURN)

time.sleep(10)
driver.get("https://www.fitbit.com/settings/data/export")

time.sleep(10)
button = driver.find_element_by_xpath('//button[text()="Download"]')
button.click()

time.sleep(10)

# close browser
driver.quit()
