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

  # This line forces Terraform to act as our new service account,
  # bypassing the broken local credentials.
  impersonate_service_account = "terraform-admin@marketing-mine-v3-dev.iam.gserviceaccount.com"
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

# Create the Vertex AI Search Datastore (using the correct resource name and all required arguments).
# This will be the central index for all processed content.
resource "google_discovery_engine_data_store" "content_datastore" {
  location          = "global"
  # This is the required, unique ID for the datastore.
  data_store_id     = "marketing-mine-datastore"
  display_name      = "marketing-mine-datastore"
  industry_vertical = "GENERIC"
  solution_types    = ["SOLUTION_TYPE_SEARCH"]
  content_config    = "NO_CONTENT"
  
  # This is required, but we are not creating a site search engine.
  create_advanced_site_search = false
}