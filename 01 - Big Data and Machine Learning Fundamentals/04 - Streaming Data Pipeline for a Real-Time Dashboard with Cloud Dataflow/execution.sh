# Open Cloud Shell and run the below command to create the taxirides dataset
bq mk taxirides

# Run this command to create the taxirides.realtime table (empty schema we will stream into later)
bq mk \
--time_partitioning_field timestamp \
--schema ride_id:string,point_idx:integer,latitude:float,longitude:float,\
timestamp:timestamp,meter_reading:float,meter_increment:float,ride_status:string,\
passenger_count:integer -t taxirides.realtime