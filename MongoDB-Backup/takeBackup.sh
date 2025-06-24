#!/bin/bash

# MongoDB Atlas connection URI
MONGO_URI="<URL For Cluster>"

# Directory to store backups
BACKUP_DIR="/home/nauman/AutomatedBackups"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Get list of all databases
DB_LIST=$(mongosh "$MONGO_URI" --quiet --eval "db.getMongo().getDBNames().filter(db => db != 'admin' && db != 'config' && db != 'local').join(' ')")
echo "$DB_LIST"
#Loop through each database and perform backup
for DB_NAME in $DB_LIST; do
    BACKUP_TIMESTAMP=$(date +%Y%m%d%H%M%S)
    BACKUP_FILE="$BACKUP_DIR/$DB_NAME-backup-$BACKUP_TIMESTAMP"
    
    echo "Backing up $DB_NAME to $BACKUP_FILE"
    
    mongodump --uri "$MONGO_URI" --db "$DB_NAME" --out "$BACKUP_FILE"
    
    echo "Backup of $DB_NAME completed"
done

echo "All backups completed"
