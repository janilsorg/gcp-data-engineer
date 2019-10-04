# clone repository
git clone https://github.com/GoogleCloudPlatform/training-data-analyst

cd ~/training-data-analyst/courses/data_analysis/lab2/python
sudo ./install_packages.sh

# Execute the pipeline locally
cd ~/training-data-analyst/courses/data_analysis/lab2/python
python grep.py

# Execute the pipeline on the cloud
gsutil cp ../javahelp/src/main/java/com/google/cloud/training/dataanalyst/javahelp/*.java gs://$BUCKET/javahelp

python grepc.py
