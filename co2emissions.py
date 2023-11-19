import pandas as pd
import json
from collections import defaultdict


csv_file = 'clean_recipes.csv'


df = pd.read_csv(csv_file, encoding="utf-8")
df['ingredients'] = df['ingredients'].str.strip('[]').str.split(', ')


food_ingredients = defaultdict(list)
all_ingredients = set()

print(df.head())

for dish, features in zip(df['recipeName'], df['ingredients']):
    food_ingredients[dish].extend(features)
    all_ingredients.update(features)


# print(len(all_ingredients))
# print(all_ingredients)

ingredient_count = defaultdict(int)

for index, row in df.iterrows():
    if isinstance(row['ingredients'], list):
        for i in row['ingredients']:
            ingredient_count[i] += 1


tmp = sorted(ingredient_count.items(), key=lambda x: x[1], reverse=True)
print(tmp[:30][0])


co2_emissions_per_kg = {
    "salt": 0.2, 
    "garlic": 1.2, 
    "onions": 0.4,
    "olive oil": 3.0,
    "water": 0.2,
    "sugar": 1.65, 
    "pepper": 4.0, 
    "butter": 11.5,
    "soy sauce": 2.0, 
    "garlic cloves": 1.2, 
    "all-purpose flour": 0.9,
    "eggs": 4.8,
    "ground black pepper": 4.0,
    "vegetable oil": 3.0,
    "green onions": 0.4, 
    "sesame oil": 3.0,
    "kosher salt": 0.2,
    "unsalted butter": 11.5,
    "black pepper": 4.0,
    "corn starch": 0.9,
    "oil": 3.0,
    "paprika": 4.0,
    "extra-virgin olive oil": 3.0,
    "dried oregano": 1.0,
    "carrots": 0.2,
    "ginger": 2.0,
    "flour": 0.9,
    "lemon juice": 1.5,
    "milk": 3.15,
    "apples": 0.43,
    "bananas": 0.86,
    "barley": 1.18,
    "beef": 99.48,
    "ground beef": 33.3,
    "grapes": 1.53,
    "cheese": 23.88,
    "coffee": 28.53,
    "dark chocolate": 46.65,
    "eggs": 4.67,
    "fish": 13.63,
    "cashew nuts": 3.23,
    "lamb": 39.72,
    "mutton": 39.72,
    "potatoes": 0.46,
    "rice": 4.45,
    "tofu": 3.16,
    "tomatoes": 2.09,
    "wine": 1.79
}

ingredient_grams_per_meal = {
    "salt": 5, 
    "garlic": 10, 
    "onions": 100,
    "olive oil": 15,
    "water": 240,
    "sugar": 7, 
    "pepper": 2, 
    "butter": 14,
    "soy sauce": 15, 
    "garlic cloves": 10, 
    "all-purpose flour": 125,
    "eggs": 50,
    "ground black pepper": 2,
    "vegetable oil": 15,
    "green onions": 15, 
    "sesame oil": 15,
    "kosher salt": 5,
    "unsalted butter": 14,
    "black pepper": 2,
    "corn starch": 8,
    "oil": 15,
    "paprika": 2,
    "extra-virgin olive oil": 15,
    "dried oregano": 1,
    "carrots": 60,
    "ginger": 5,
    "tomatoes": 150,
    "flour": 125,
    "lemon juice": 15,
    "milk": 244,
    "apples": 150,
    "bananas": 118,
    "barley": 200,
    "beef": 85,
    "ground beef": 85,
    "grapes": 150,
    "cheese": 30,
    "coffee": 240,
    "dark chocolate": 30,
    "eggs": 50,
    "fish": 85,
    "cashew nuts": 28,
    "lamb": 85,
    "mutton": 85,
    "potatoes": 150,
    "rice": 195,
    "tofu": 150,
    "wine": 150
}

thresholds = {
    'A': 50,   # Up to 50g CO2 is labeled as A
    'B': 100,  # 51-100g CO2 is labeled as B
    'C': 200,  # 101-200g CO2 is labeled as C
    'D': 300,  # 201-300g CO2 is labeled as D
    'E': 400,  # 301-400g CO2 is labeled as E
}

food_emissions = defaultdict(float)

for index, row in df.iterrows():
    food_name = row['recipeName']
    ingredients_list = row['ingredients']
    co2_emission = 0
    if isinstance(ingredients_list, list):
        for i in ingredients_list:
            co2_emission += co2_emissions_per_kg.get(i, 0) * ingredient_grams_per_meal.get(i, 0)

        food_emissions[food_name] = co2_emission




def assign_label(co2_emissions):
    for label, threshold in thresholds.items():
        if co2_emissions <= threshold:
            return label
    return 'F'


food_labels = {food: assign_label(emissions) for food, emissions in food_emissions.items()}
json_string = json.dumps(food_labels, indent=4)
with open('food_labels.json', 'w') as json_file:
    json_file.write(json_string)