curl -X POST -H "Content-Type: application/json" \
  -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
  https://automl.googleapis.com/v1beta1/projects/qwiklabs-gcp-125497db46ca3074/locations/us-central1/models/ICN2827229006846332582:predict -d @request2.json