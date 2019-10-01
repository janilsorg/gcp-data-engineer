'''
This PySpark application performs word counting on data contained in HDFS. Notice that the application 
currently expects to find the data in HDFS in a directory called /sampledata. You will modify the 
program to work on the data you just uploaded to Cloud Storage.'
'''

from pyspark.sql import SparkSession
from operator import add
import re

print("Okay Google.")

spark = SparkSession\
        .builder\
        .appName("CountUniqueWords")\
        .getOrCreate()

# lines reading HDFS
# lines = spark.read.text("/sampledata/road-not-taken.txt").rdd.map(lambda x: x[0])

# lines reading Cloud Storage, gs://<BUCKET_NAME/road-not-taken.txt) because we've copied this file to cloud storage
lines = spark.read.text("gs://qwiklabs-gcp-b10db268923d0fc5/road-not-taken.txt").rdd.map(lambda x: x[0])


counts = lines.flatMap(lambda x: x.split(' ')) \
                  .filter(lambda x: re.sub('[^a-zA-Z]+', '', x)) \
                  .filter(lambda x: len(x)>1 ) \
                  .map(lambda x: x.upper()) \
                  .map(lambda x: (x, 1)) \
                  .reduceByKey(add) \
                  .sortByKey()
output = counts.collect()
for (word, count) in output:
  print("%s = %i" % (word, count))

spark.stop()


# verify if data does not exist in HDFS ->  hadoop fs -ls /

# Next, use the Hadoop file system command to view the files through the hadoop connector to Cloud Storage. 
# This verifies that the connector is working and that the file is available in the bucket.
# hadoop fs -ls gs://$BUCKET

# other infos
# project id qwiklabs-gcp-b10db268923d0fc5
# BUCKET=qwiklabs-gcp-b10db268923d0fc5
# echo $BUCKET

# run the job
# spark-submit wordcount.py

