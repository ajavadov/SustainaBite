import csv
import re
import shutil
import json
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from bs4 import BeautifulSoup
from tempfile import NamedTemporaryFile


def get_image_url(query):
    # Use Selenium to open a browser and get the dynamically loaded content
    driver = webdriver.Chrome()  # Make sure you have ChromeDriver installed and in your PATH
    search_url = f"https://duckduckgo.com/?q={query}&va=q&t=ha&iax=images&ia=images"
    driver.get(search_url)

    # Scroll down to load more images (you may need to adjust this based on the actual website behavior)
    driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")

    # Wait for a short period to ensure dynamic content is loaded
    wait = WebDriverWait(driver, 10)
    wait.until(EC.presence_of_element_located((By.CLASS_NAME, 'tile--img__img')))

    # Get the page source after dynamic content is loaded
    page_source = driver.page_source
    driver.quit()

    # Use BeautifulSoup to parse the HTML
    soup = BeautifulSoup(page_source, 'html.parser')

    # Find the first image in the search results
    img_tag = soup.find('img', class_='tile--img__img')

    if img_tag and 'src' in img_tag.attrs:
        return img_tag['src']
    else:
        return None
    

count = 0  # Initialize counter
image_urls = []  # List to store image URLs
recipe_url_map = {}  # Dictionary to store recipe names and their corresponding image URLs


# Open the CSV file for reading
with open('last_for_images.csv', 'r', newline='') as csv_file, \
    NamedTemporaryFile(mode='w', delete=False, newline='') as temp_file:

    csv_reader = csv.DictReader(csv_file)
    fieldnames = csv_reader.fieldnames + ['image_url']  # Add 'image_url' to fieldnames
    csv_writer = csv.DictWriter(temp_file, fieldnames=fieldnames)
    csv_writer.writeheader()


    for row in csv_reader:
        if count <= 50:
            count += 1
            continue
        print(row['recipeName'])
        search_query = '+'.join(re.findall(r'\b\w+\b', row['recipeName'].lower()))
        
        # Get the image URL
        image_url = get_image_url(search_query)  # This line defines image_url




        # Handle the case where image_url is None
        if image_url is not None:
            row['image_url'] = image_url
            modified_url = re.sub(r'^//external-content\.duckduckgo\.com', 'duckduckgo.com', image_url)
            print(modified_url)
            image_urls.append(image_url)  # Store the image URL
            recipe_url_map[row['recipeName']] = modified_url  # Store the recipe name and URL in the map


        count += 1
        csv_writer.writerow(row)
    # csv_writer.writerow(row)


with open('last_images-1.json', 'w') as json_file:
    json.dump(recipe_url_map, json_file, indent=4)