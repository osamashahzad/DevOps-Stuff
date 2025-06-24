#!/bin/bash

aws_access_key="" #Enter your IAM account's access key here
aws_secret_key="" #Enter your IAM account's secret key here
s3_bucket="" #Enter the name of the bucket you want to store your backups in, here
s3_region="" #Enter the region of your bucket
local_folder_path=~/backup/mysql

#export PATH="/usr/local/bin/aws"
aws=/usr/local/bin/aws
$aws s3 sync "$local_folder_path" "s3://$s3_bucket/" --region "$s3_region" \
  --acl private \
  --profile default

if [ $? -eq 0 ]; then
  echo "Upload completed successfully."
else
  echo "Upload failed. Please check the AWS CLI configuration and permissions."
fi
