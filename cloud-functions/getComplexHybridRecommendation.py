import functions_framework
import random
from google.cloud import firestore
from sklearn.metrics.pairwise import cosine_similarity
import pandas as pd
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity

@functions_framework.http
def hello_http(request):
    
    username = request.args.get('username')
    db = firestore.Client()
    query = db.collection("Users").where("username", "==", username).limit(1)
    users = query.stream()

    user_data = None   
    for user in users:
        user_data = user.to_dict()

    if user_data is None: return f"Username {username} not found"
    likedFoods = user_data["liked"]

    foods = db.collection("Food").stream()
    foods_data = [food.to_dict() for food in foods]
    foods_data_df = pd.DataFrame.from_dict(foods_data)    


    query = db.collection("Users")
    users = query.stream()
    user_list = []
    for user in users:
        ud = user.to_dict()
        user_list.append(ud)

    transformed_data = {'user_id': [], 'id': [], 'rating': []}

    for user_id, entry in enumerate(user_list):
        for recipe_id in entry['liked']:
            transformed_data['user_id'].append(user_id)
            transformed_data['id'].append(recipe_id)
            transformed_data['rating'].append(5)
    user_ratings_df = pd.DataFrame(transformed_data)
    return get_recommendations(likedFoods, foods_data_df, user_ratings_df)



def get_recommendations(likedFoods, foods_data_df, user_ratings_df, method:str="hybrid"):
    recommendation_pool = []
    if method=='nlp':
        for likedFood in likedFoods:
            candidates = most_similar_recipes(likedFood, foods_data_df, 5) 
            similar_recipes = set([(recipe, similarity) for recipe, similarity in candidates if recipe != likedFood])
            
            for i, (recipe, similarity) in enumerate(similar_recipes):
                print(f"{recipe}: {similarity}")
                print(i)
                recommendation_pool.append((recipe,similarity))
            recommendation_pool = sorted(recommendation_pool, key=lambda x: x[1], reverse=True)

    else: #hybrid
        for likedFood in likedFoods:

                # Get the vector for the target recipe
            target_vector = foods_data_df.loc[foods_data_df['id'] == likedFood, 'embedding'].values[0]

            # Calculate cosine similarity between the target recipe and all other recipes
            similarities = cosine_similarity([target_vector], foods_data_df['embedding'].tolist())[0]

            # Get indices of the top_n most similar recipes
            top_indices = similarities.argsort()[:-20-1:-1]

            # Filter user ratings for the top_n most similar recipes
            similar_recipes = foods_data_df.loc[top_indices, 'id'].tolist()
            print("BB",similar_recipes)
            # Filter user ratings for the target recipe and similar recipes
            user_ratings_subset = user_ratings_df[
                (user_ratings_df['id'].isin([likedFood] + similar_recipes))
            ]
            print("DD",user_ratings_subset)
            # Calculate the average rating for each recipe
            average_ratings = user_ratings_subset.groupby('id')['rating'].mean()
            print("EE", average_ratings)
            # Sort recipes by predicted average rating in descending order
            recommended_recipes = set(sorted(average_ratings.items(), key=lambda x: x[1], reverse=True))
            print(recommended_recipes)

            candidates = most_similar_recipes(likedFood, foods_data_df, top_n=10)
            print("CC",candidates)
            similar_recipes = set([(recipe, similarity+3.6) for recipe, similarity in candidates if recipe != likedFood])
            print("FF",similar_recipes)
            candidates += similar_recipes
            print("AA",candidates)
            for i, (recipe, similarity) in enumerate(similar_recipes):
                print(f"{recipe}: {similarity}")
                print(i)
                recommendation_pool.append((recipe,similarity))
            
        recommendation_pool = sorted(recommendation_pool, key=lambda x: x[1], reverse=True)


    if len(recommendation_pool)>25:
        recommendation_pool = recommendation_pool[:20]
    
    return recommendation_pool




def most_similar_recipes(recipe_name, recipe_vectors_df, top_n=5):
    # Get the vector for the target recipe
    target_vector = recipe_vectors_df.loc[recipe_vectors_df['id'] == recipe_name, 'embedding'].values[0]

    # Calculate cosine similarity between the target recipe and all other recipes
    similarities = cosine_similarity([target_vector], recipe_vectors_df['embedding'].tolist())[0]

    # Get indices of the top_n most similar recipes
    top_indices = similarities.argsort()[:-top_n-1:-1]

    # Create a list of tuples containing (recipe_name, similarity_score)
    similar_recipes = [(recipe_vectors_df.loc[i, 'id'], similarities[i]) for i in top_indices]

    return similar_recipes
