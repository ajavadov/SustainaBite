import functions_framework
import random
from google.cloud import firestore
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np

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
    
    recommendedFoods = []
    for likedFood in likedFoods:
        embeddings = [food['embedding'] for food in foods_data]
        ids = [food['id'] for food in foods_data]
        try:
            # Find the index of the given ID
            given_index = ids.index(likedFood)
        except ValueError:
            print(f"Item with ID '{likedFood}' not found in the list.")
            continue

        # Convert to numpy arrays for compatibility with cosine_similarity
        given_embedding = np.array([embeddings[given_index]])
        embeddings_array = np.array(embeddings)

        # Calculate cosine similarity
        similarities = cosine_similarity(given_embedding, embeddings_array)

        # Find the index of the item with the highest similarity (excluding the given item itself)
        closest_index = np.argmax(similarities[:, np.arange(len(ids)) != given_index])

        # Get the closest item
        recommendedFoods.append(foods_data[closest_index])
    
    return recommendedFoods
