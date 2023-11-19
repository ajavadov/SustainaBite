import functions_framework
from google.cloud import firestore

@functions_framework.http
def hello_http(request):
    #input data
    username = request.args.get('username')
    food_id = request.args.get('foodid')
    
    db = firestore.Client()
    query = db.collection("Users").where("username", "==", username).limit(1) #get user
    docs = query.stream()
    for doc in docs:
        current_data = doc.to_dict()
        current_food_list = current_data.get('liked', []) #get list of liked/history
        print(current_food_list)

        if food_id not in current_food_list:
            current_food_list.append(food_id)

            # Update the Firestore document
            db.collection("Users").document(doc.id).update({'liked': current_food_list})

            return f"Food ID added to the list"
        else:
            return f"Food ID already in the list"
    return f"No user found with the given username"

