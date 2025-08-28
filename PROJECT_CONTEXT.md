# **Project Context: Marketing Mine**

This document provides a high-level overview of the Marketing Mine project.

## **1. Project Goal**

[cite_start]The primary goal is to create an automated pipeline for ingesting, analyzing, and enriching various media files using Google Cloud's AI services, specifically leveraging a Vertex AI Search-native architecture[cite: 1, 74]. [cite_start]The system makes content discoverable via natural language queries[cite: 34].

## **2. Core Technologies**

* [cite_start]**Cloud Provider:** Google Cloud Platform (GCP) [cite: 43]
* [cite_start]**Application Backend:** Cloud Run [cite: 43]
* [cite_start]**AI Search & Processing:** Vertex AI Search [cite: 43]
* [cite_start]**AI Metadata Extraction:** Vertex AI Gemini API [cite: 43]
* [cite_start]**Asynchronous Triggering:** Cloud Logging & Cloud Functions [cite: 43]
* [cite_start]**Data Persistence:** Firestore [cite: 43]
* [cite_start]**Authentication:** Firebase Authentication [cite: 58]

## **3. System Architecture Overview**

[cite_start]The system is an asynchronous pipeline triggered by file uploads to a GCS bucket[cite: 43, 47].

1.  [cite_start]**Ingestion (api-service):** An authenticated Cloud Run service receives file submission requests, creates a metadata record in Firestore, and uploads the file to GCS[cite: 46, 47].
2.  [cite_start]**Processing & Indexing (Vertex AI Search):** Vertex AI Search automatically detects the new file, processes it (transcription, OCR, etc.), and indexes it for search[cite: 49].
3.  [cite_start]**Metadata Enrichment (meta-tagger):** A Cloud Function is triggered by a completion log from the search service[cite: 51]. [cite_start]It retrieves the transcript, uses the Gemini API to extract structured tags, and updates the Firestore record[cite: 52, 53].
