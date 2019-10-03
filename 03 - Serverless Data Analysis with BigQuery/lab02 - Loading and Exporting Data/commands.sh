# In Cloud Shell, enter the following command to download the schema file for the table to your working directory.
# https://storage.googleapis.com/cloud-training/CPB200/BQ/lab4/schema_flight_performance.json

curl https://storage.googleapis.com/cloud-training/CPB200/BQ/lab4/schema_flight_performance.json -o schema_flight_performance.json

# Next, you will create a table in the dataset using the schema file you downloaded to Cloud Shell and data 
# from JSON files that are in Cloud Storage. The JSON files have URIs like the following:
# gs://cloud-training/CPB200/BQ/lab4/domestic_2014_flights_*.json
# Note that your Project ID is stored as a variable in Cloud Shell `$DEVSHELL_PROJECT_ID` so there's no need 
# for you to remember it. If you require it, you can view your Project ID in the command line to the right
#  of your username (after the @ symbol).

# In Cloud Shell, create a table named flights_2014 in the cpb101_flight_data dataset with this command:
bq load --source_format=NEWLINE_DELIMITED_JSON 
    $DEVSHELL_PROJECT_ID:cpb101_flight_data.flights_2014 
    gs://cloud-training/CPB200/BQ/lab4/domestic_2014_flights_*.json ./schema_flight_performance.json

# There are multiple JSON files in the Cloud Storage bucket. They are named according to the convention: 
# domestic_2014_flights*.json_. The wildcard (*) character in the command is used to include all of 
# the .json files in the bucket.

# Once the table is created, type the following command to verify table flights_2014 exists in dataset cpb101_flight_data.
bq ls $DEVSHELL_PROJECT_ID:cpb101_flight_data

#output
# tableId        Type
# -------------- -------
# AIRPORTS       TABLE
# flights_2014   TABLE

# export data to a bucket
bq extract cpb101_flight_data.AIRPORTS gs://$BUCKET/bq/airports2.csv
