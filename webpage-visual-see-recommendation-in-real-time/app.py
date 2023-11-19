from flask import Flask, render_template
import requests

app = Flask(__name__)

@app.route('/food')
def index():
    # API URL (replace with your API endpoint)
    api_url = "https://us-central1-ratatouille-ae161.cloudfunctions.net/function-3?username=murad"

    try:
        # Send GET request to the API
        response = requests.get(api_url)

        # Check if the request was successful (status code 200)
        if response.status_code == 200:
            # Parse JSON response
            data = response.json()
            for d in data:
                d["image_url"] = "https://" + d["image_url"]
            # Pass data to the template
            return render_template('index.html', recipes=data)
        else:
            return f"Error: Unable to fetch data from the API. Status code: {response.status_code}"

    except Exception as e:
        return f"Error: {str(e)}"

if __name__ == '__main__':
    app.run(debug=True)