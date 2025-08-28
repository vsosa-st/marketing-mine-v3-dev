terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# Configure the Google Cloud provider to use our project and region.
provider "google" {
  project = "marketing-mine-v3-dev"
  region  = "us-central1"
}

# Create the GCS bucket for raw file uploads.
# This bucket is the entry point for the Vertex AI Search pipeline.
resource "google_storage_bucket" "uploads_bucket" {
  # Bucket names must be globally unique, so we use the project ID
  # as a prefix to avoid collisions.
  name          = "marketing-mine-v3-dev-uploads"
  location      = "US-CENTRAL1"
  storage_class = "STANDARD"

  # This setting ensures uniform, simple permissions for the bucket.
  uniform_bucket_level_access = true

  # Enable autoclass to automatically move objects to colder storage
  # classes to save costs, which is important for a large media archive.
  autoclass {
    enabled = true
  }
}
