from FirestoreRatatouille import FirestoreRatatouille
from FirestoreDocument import FirestoreDocument
from google.cloud import storage
from google.cloud import firestore
from google.oauth2 import service_account
import csv

def main():
    fr = FirestoreRatatouille()
    with open('small_data_with_embeds.csv', newline='', encoding='latin-1') as f:
        next(f)
        reader = csv.reader(f)
        i = 0
        for row in reader:
            print("Index:", i)
            id, recipeID, recipeName, rating, totalTimeInSeconds, course, cuisine, dirty_ing, ingredients, ingredient_count, timeMins, embeddings, image_url, co2rating = row
            ingredients_list = [ingredient.strip().lower() for ingredient in ingredients[1:-1].split(',') if ingredient.strip()]
            course_list = [c.strip().lower() for c in course[1:-1].split(',') if c.strip()]
            cuisine_list = [c.strip().lower() for c in cuisine[1:-1].split(',') if c.strip()]
            i+=1
            fd = FirestoreDocument()
            fd.add(u'id', recipeID.lower())
            fd.add(u'recipeName', recipeName.lower())
            fd.add(u'rating', rating)
            fd.add(u'totalTimeInSeconds', totalTimeInSeconds)
            fd.add(u'course', course_list)
            fd.add(u'cuisine', cuisine_list)
            fd.add(u'ingredients', ingredients_list)
            fd.add(u'ingredientCount', ingredient_count)
            fd.add(u'timeMins', timeMins)
            fd.add(u'image_url', image_url)
            fd.add(u'co2rating', co2rating)
            emb = [float(e) for e in embeddings[1:-1].replace("\n", " ").split()]
            fd.add(u'embedding', emb)
            new_food_id = fr.add_food(fd, id=recipeID.lower())
            

if __name__ == '__main__':
	main()