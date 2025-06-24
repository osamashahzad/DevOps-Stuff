#!/bin/bash

#Creates a tar file of the backup folder
cd ~/backup
name=$(date '+%Y%m%d')
tar -zcvf $name.tar.gz $name

aws_access_key=" " #Add Access Key here
aws_secret_key=" " #Add Secret Key here
s3_bucket=" " #Add bucket name here
s3_region=" " #Add bucket region here

aws="/usr/local/bin/aws"

"$aws" s3 cp "$name.tar.gz" "s3://$s3_bucket/Postgres-Backups/$name.tar.gz" --region "$s3_region"

if [ $? -eq 0 ]; then
  echo "Upload completed successfully."
else
  echo "Upload failed. Please check the AWS CLI configuration and permissions."
fi