
# coding: utf-8

# In[10]:


import os  
import time
import csv
from selenium import webdriver  
from selenium.webdriver.common.keys import Keys  
from selenium.webdriver.chrome.options import Options  

chrome_options = Options()  
chrome_options.add_argument("--headless")  
chrome_options.binary_location = 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe'  

driver = webdriver.Chrome(executable_path=os.path.abspath("C:\\_files\\git\\DVA-Project\\ChromeDriver\\chromedriver.exe"), options=chrome_options)  
#driver = webdriver.Chrome(executable_path=os.path.relpath("..\chromedriver_win32\chromedriver.exe"), options=chrome_options)  


# In[177]:


def get_imdb_reviews(tt):
#     driver.get("https://www.imdb.com/title/tt0056592/reviews?ref_=tt_urv") 
    driver.get("https://www.imdb.com/title/"+tt+"/reviews")
    click_count = 0
    while True:
        try:
            load_button = driver.find_element_by_id('load-more-trigger')
            load_button.click()
            click_count = click_count + 1
            print(str(click_count))
            time.sleep(.5)
            continue
        except Exception as e: 
            print("No more found")
            print("Total Clicks: " + str(click_count))
            break
            
    # Click on all the spoiler warning controls to expand them
    ctls = driver.find_elements_by_css_selector("div.spoiler-warning__control")
    for idx,elem in enumerate(ctls):
        elem.click()
    
    #reviews = driver.find_elements_by_css_selector("div.review-container  .content  .text")
    reviews = driver.find_elements_by_css_selector("div.review-container")
    
    output = []
    review_clicks = 0

    for idx, review in enumerate(reviews):
        review_text = review.find_element_by_css_selector(".content .text")
        if 'clickable' in review_text.get_attribute('class'):
            review_text.click()
            review_clicks = review_clicks + 1
            
        link_elem = review.find_elements_by_class_name("title")
        if len(link_elem) > 0:
            link = link_elem[0].get_attribute("href")
        else:
            link = ''
        
        rating = '?'
        try:
            rating = review.find_elements_by_class_name("ipl-ratings-bar")[0].find_elements_by_tag_name("span")[1].text
        except:
            rating = '?'

        output.append((link, rating, review_text.text))

    return output


# In[ ]:


input_file = '.\\tmdb_to_imdb_id_mapping2.csv'

line_count = 0


with open(input_file) as csvfile:
    readCSV = csv.reader(csvfile, delimiter=',')
    with open('movie_reviews.csv', mode='w', encoding='utf8', newline='') as review_file:
        review_writer = csv.writer(review_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
        review_writer.writerow(['imdbid', 'reviewid', 'url', 'rating', 'review'])
        for movie in readCSV:
            line_count = line_count + 1
            #Skip header in read
            if line_count == 1:
                continue
            
            #Get the IMDBId
            tt = movie[2]
            if tt == '':
                continue

            reviews = get_imdb_reviews(tt)
            for idx, review in enumerate(reviews):                
                review_writer.writerow([tt,idx,review[0], review[1], review[2]])
            
            #Wait between movies
            time.sleep(2)
            
            #Hardcoded to only run a few
            # movie_count = 2
            # if line_count > movie_count:
            #     break


# In[ ]:


driver.close()

