#!/bin/bash

export AWS_PROFILE=<PROFILE_NAME>

RootFolderOnBucket=<NAME_OF_FOLDER_IN_BUCKET>

Folder1ToSync=actions-runner/_work

# Copy ENVs to S3
find $Folder1ToSync -type d -name "node_modules" -prune -o \( -type f -name ".env*" \) -exec sh -c 'aws s3 cp {} s3://inhouse-server-bucket/'$RootFolderOnBucket'/$(dirname {})/' \;

# Copy this shell Scripts to S3 as well
aws s3 cp sync-server.sh s3://inhouse-server-bucket/$RootFolderOnBucket/