from FirestoreRatatouille import FirestoreRatatouille
from FirestoreDocument import FirestoreDocument
from google.cloud import storage
from google.cloud import firestore
from google.oauth2 import service_account
import csv
import random

def parse_line(line):
        # Split the line into name and ingredients
        name, ingredients_str = line.strip().split(' - ')
        
        # Convert ingredients string to a list
        ingredients = ingredients_str[1:-1].split(',')
        print(ingredients)
        # Create a dictionary
        result = {
            'name': name.lower(),
            'ingredients': [ingredient.lower() for ingredient in ingredients]
        }
        return result
    

def main():
    fr = FirestoreRatatouille()
    # Function to parse each line and create a dictionary
  


    file_path = 'food-names-list.txt' 
    entries = []

    with open(file_path, 'r') as file:
        for line in file:
            entry = parse_line(line)
            entries.append(entry)
        
        i = 0
        for entry in entries:
            print("Index:", i)
            i+=1
            fd = FirestoreDocument()
            fd.add(u'name', entry["name"])
            fd.add(u'features', entry["ingredients"])
            fd.add(u'embedding', [random.uniform(0, 1), random.uniform(0, 1), random.uniform(0, 1)])
            id = entry["name"].replace(" ", "-")
            fd.add(u'id', id)
            new_food_id = fr.add_food(fd, id=id)
            if i == 10:
                break
            

if __name__ == '__main__':
	main()