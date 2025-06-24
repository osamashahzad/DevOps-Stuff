#!/bin/bash

# MongoDB Atlas connection URI
MONGO_URI=""
BACKUP_DIR=""
BUCKET_NAME=""
# Peggy-Prod Cluster URI
# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Get list of all databases
DB_LIST=$(mongosh "$MONGO_URI" --quiet --eval "db.getMongo().getDBNames().filter(db => db != 'admin' && db != 'config' && db != 'local').join(' ')")
printf "\n$DB_LIST\n"

#Loop through each database and perform backup
BACKUP_TIMESTAMP=$(date +%Y'-'%m'-'%d)
BACKUP_FILE="$BACKUP_DIR/$DB_NAME-backup-$BACKUP_TIMESTAMP"

for DB_NAME in $DB_LIST; do    
    printf "\nBacking up $DB_NAME to $BACKUP_FILE\n"
    mongodump --uri "$MONGO_URI" --db "$DB_NAME" --out "$BACKUP_FILE"
    printf "\nBackup of $DB_NAME completed\n"
done
printf "\n*********************\n"
printf "All backups completed"
printf "\n*********************\n"

printf "\n***Zipping Files***\n"
tar -cvf $BACKUP_FILE.tar $BACKUP_DIR
ls -lh $BACKUP_DIR

printf "\n***Moving Files to S3***\n"
aws s3 cp $BACKUP_FILE.tar  s3://$BUCKET_NAME/

# printf "\n***Cleaning Server Resources***\n"
# rm -rf $BACKUP_DIR/*
printf "\n***All Operations Completed!***\n"