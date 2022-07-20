"""
Created on 2022-07-18

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
import os
import shutil

#%%
# Set webdriver requirements
# ------------------------ #

# set path for driver
# chrome seems less buggy than ff

########## FOR LINUX ##########

# PATH = Service("path/to/chromedriver")

########## ~~~~~~~~~ ##########


########## FOR WINDOWS ##########

PATH = Service("C:/Program Files (x86)/chromedriver.exe")

########## ~~~~~~~~~~~ ##########


########## HEADLESS OR NOT ##########
options = Options()
options.add_argument("--headless")
options.add_argument("--disable-gpu")
########## ~~~~~~~~~~~~~~~ ##########
driver = webdriver.Chrome(service = PATH, options = options)

#%%
# Get time log
# -------------- #

## point to the website and open browser
driver.get("https://app.atimelogger.com/#/signin")

## find username and password fields and enter them
username = driver.find_element_by_xpath("//input[@placeholder='E-Mail']")
username.send_keys("youremail@address.com")

password = driver.find_element_by_xpath("//input[@placeholder='Password']")
password.send_keys("yourpassword")
password.send_keys(Keys.RETURN)

## change to 'this week'
time.sleep(10)
select = driver.find_elements_by_class_name('ant-select-selection__rendered')
select_correct = select[1]
select_correct.click()
time.sleep(3)
dropdown = driver.find_elements_by_class_name('ant-select-dropdown-menu-item')
week = dropdown[2] # edit this to select different time period (0 indexed)
week.click()
time.sleep(3)

## download file
button = driver.find_element_by_class_name('ant-btn')
button.click()
time.sleep(10)

# close browser
driver.quit()