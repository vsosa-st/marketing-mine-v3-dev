import os
import datetime
from flask import Flask, jsonify, request
from google.cloud import firestore, storage

app = Flask(__name__)

# Initialize clients
db = firestore.Client()
storage_client = storage.Client()

# Get the GCS bucket from an environment variable, with a fallback for local dev
# In Cloud Run, we will set this environment variable.
BUCKET_NAME = os.environ.get("GCS_BUCKET_NAME", "marketing-mine-v3-dev-uploads")

@app.route("/", methods=["GET"])
def index():
    """A simple endpoint to confirm the service is running."""
    return jsonify({"status": "ok"}), 200

@app.route("/upload", methods=["POST"])
def upload_file():
    """
    Receives a file, uploads it to GCS, and creates a corresponding
    metadata document in Firestore.
    """
    if 'file' not in request.files:
        return jsonify({"error": "No file part in the request"}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({"error": "No file selected for uploading"}), 400

    if file:
        try:
            # --- 1. Upload to GCS ---
            bucket = storage_client.bucket(BUCKET_NAME)
            blob = bucket.blob(file.filename)
            
            print(f"Uploading file {file.filename} to bucket {BUCKET_NAME}...")
            blob.upload_from_file(file)
            print("File upload to GCS successful.")

            # --- 2. Create Firestore Document ---
            gem_data = {
                'fileName': file.filename,
                'gcsUri': f'gs://{BUCKET_NAME}/{file.filename}',
                'processingStatus': 'UPLOADED', # Status is now UPLOADED
                'createdAt': datetime.datetime.utcnow(),
                'updatedAt': datetime.datetime.utcnow(),
            }
            
            print(f"Writing metadata to Firestore for {file.filename}...")
            update_time, doc_ref = db.collection('gems').add(gem_data)
            print(f"Firestore write successful. New gem ID: {doc_ref.id}")
            
            return jsonify({
                "message": "File uploaded and metadata created successfully", 
                "gemId": doc_ref.id,
                "gcsUri": gem_data['gcsUri']
            }), 201

        except Exception as e:
            print(f"An error occurred: {e}")
            return jsonify({"error": "An internal error occurred"}), 500

    return jsonify({"error": "An unexpected error occurred"}), 500


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
