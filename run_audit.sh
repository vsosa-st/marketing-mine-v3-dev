#!/bin/bash
set -e

TIMESTAMP=$(date +%Y-%m-%dT%H:%M)
FILENAME="current_state_${TIMESTAMP}.txt"

echo "--- Generating Current State Audit ---"
echo "Output will be saved to ${FILENAME}"

# Run the commands and redirect all output to the file
{
  echo "--- Google Cloud Environment Check ---"
  gcloud auth list
  gcloud config get-value project
  echo ""

  echo "--- Local Directory Structure ---"
  tree -I '.git|node_modules|__pycache__|.terraform|.DS_Store|dist'
  echo ""

  echo "\n***********************************************************"
  echo "\nGOOGLE CLOUD SERVICES CONFIGURATION (placeholders for now)"
  echo "\n***********************************************************"
  echo "\n--- Cloud Run Services ---"
  # gcloud run services list --format="table(NAME, URL)"

  echo "\n--- Cloud Functions ---"
  # gcloud functions list --format="table(name, state, trigger.https_trigger.url, event_trigger.eventType)"

  echo "\n--- GCS Buckets ---"
  # gcloud storage buckets list

} > "$FILENAME"

echo "Audit complete. Output saved to ${FILENAME}"
