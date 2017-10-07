Overview

This is an API made to be used with breed-matchup-front end. One a meduim username is entered on the front end by a user, this api scrapes for blog text on medium.com, and then sends the text to watson personality insights API to score top personality traits. Dog breeds are then matched up based off of the top personality traits. Data is then sent back to the front end to be displayed. 

Main Features/flow

- nokogiri ruby gem used to scrape for text of meduim blog post
- Watson personality insights API used 

Languages & tools
  - Ruby on Rails

Database
  - PostgreSQL

External APIs
  - Watson personality insights API used 

Key Gems
	- excon (for fetch to external APIs)
  - Nokogiri (web scraping)
