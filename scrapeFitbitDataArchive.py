"""
Created on 2022-06-28

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
# Set webdriver requirements
# ------------------------ #

# set path for driver
# chrome seems less buggy than ff

########## FOR LINUX ##########

PATH = Service("path/to/chromedriver")

########## ~~~~~~~~~ ##########


########## FOR WINDOWS ##########

# PATH = Service("C:/Program Files (x86)/chromedriver.exe")

########## ~~~~~~~~~~~ ##########


########## HEADLESS OR NOT ##########
options = Options()
options.add_argument("--headless")
options.add_argument("--disable-gpu")
driver = webdriver.Chrome(service = PATH, options = options)
########## ~~~~~~~~~~~~~~~ ##########

#%%
# Get logged hours
# -------------- #

## point to the website and open browser
driver.get("https://accounts.fitbit.com/login?targetUrl=https%3A%2F%2Fwww.fitbit.com%2Fglobal%2Fus%2Fhome")
time.sleep(10)

# ## find username and password fields and enter them
username = driver.find_element_by_xpath("//input[@placeholder='Your account email']")
username.send_keys("youremailaddress@email.com")

password = driver.find_element_by_xpath("//input[@placeholder='Enter your secure password']")
password.send_keys("yourpassword")
password.send_keys(Keys.RETURN)

time.sleep(10)
driver.get("https://www.fitbit.com/settings/data/export")

time.sleep(10)
requestButton = driver.find_element_by_xpath('//button[text()="Request Data"]')
requestButton.click()


########## you MUST respond to an email here ##########

# wait for page to load or it breaks
time.sleep(10)

# we can maybe use the "resend email" button to check for if the code has been verified
# empty list is falsey, so we don't need to explicitly check len()
while driver.find_elements_by_xpath('//button[text()="Resend Email"]'):
    print("waiting for email confirmation...")
    time.sleep(180)
    print("refreshing page")
    driver.refresh()
    time.sleep(10)
    
print("Email confirmed")

########## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ##########


# Have to make sure we're finding the "correct" cancel request, so build in a wait here too
time.sleep(10)

# now we wait for the data to be prepared for download
# check if it's ready by seeing if we can cancel the request
# refresh page at each check
while driver.find_elements_by_xpath('//button[text()="Cancel Request"]'):
    print("waiting for data preparation...")
    time.sleep(180)
    print("refreshing page")
    driver.refresh()
    time.sleep(10)
    
print("File prepared")

# grab Download buttons
buttons = driver.find_elements_by_xpath('//button[text()="Download"]')

# we want specifically the second one
print("Downloading zip...")
button = buttons[1]
button.click()



# give zip time to download
time.sleep(60)

# close browser
driver.quit()
