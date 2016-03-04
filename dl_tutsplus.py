#!/usr/bin/python
# selenium, pyvirtualdisplay, xvfb

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.keys import Keys
from selenium.common.exceptions import NoSuchElementException

from time import sleep
import sys
import urllib

from pyvirtualdisplay import Display

class TutsPlusDigger:
    def __init__(self, url):
        print 'Initing hidden display'
        self.display = Display(visible=0, size=(800,600))
        self.downloads = []
        self.url = url
        
    def __enter__(self):
        print 'Starting hidden display and webdriver'
        self.display.start()
        self.driver = webdriver.Firefox()
        return self
                
    def __exit__(self, type, value, tb):
        print 'Stopping display and webdriver'
        self.driver.close()
        self.display.stop()
        
    def dig(self):
        #self.login()
        print 'Visiting %s' % self.url
        self.driver.get(self.url)
        self.get_page_downloads()
        
    def login(self, username, password):
        self.driver.get("https://tutsplus.com/sign_in?redirect_to=https%3A%2F%2Ftutsplus.com%2F")

        username = self.driver.find_element_by_id("session_login")
        username.send_keys(username)
        password = self.driver.find_element_by_id("session_password")
        password.send_keys(password)
        password.send_keys(Keys.ENTER)
        print "Logging in"
        sleep(3)   
        
    def get_page_downloads(self):
        courses = self.driver.find_elements_by_class_name("posts__post-title")
        for course in courses:
            link = course.get_attribute("href")
            name = link.rsplit("/", 1)[1] 
            download = {
                "videos" : [],
                "name" : name,
                "url" : link                
            }
            self.downloads.append(download)
        self.get_downloads_video_urls()
            
    def get_downloads_video_urls(self):
        for download in self.downloads:
            print 'Finding videos for course "%s"' % download['name']
            self.driver.get(download['url'])
            sleep(1)
            for element in self.driver.find_elements_by_class_name("lesson-index__lesson-link"):
                url = element.get_attribute('href')
                name = url.rsplit("/", 1)[1]                
                print name
                video = {
                    'url' : url,
                    'name' :  name,
                    'mp4' : ""
                }
                download['videos'].append(video)
                
            for video in download['videos']:
                video['mp4'] = self.get_video_mp4(video['url'])
                
    def get_video_mp4(self, video_url):
        print 'Finding video mp4 url for %s' % video_url
        self.driver.get(video_url)
        sleep(1)
        element = self.driver.find_element_by_xpath("//source[contains(@src, 'mp4')]")
        mp4_url = element.get_attribute("src")
        print mp4_url
        return mp4_url  
        
address = "https://code.tutsplus.com/courses" if not len(sys.argv) >= 2 else sys.argv[i]
with TutsPlusDigger(address) as digger:
    digger.dig()