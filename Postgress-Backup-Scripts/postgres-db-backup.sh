#!/bin/bash

#Update these variables according to your postgres credentials
PGHOST="localhost"
PGPORT="5432"
PGUSER="postgres"
PGPASSWORD="postgres"


DATE=$(date +"%Y%m%d")
cd ~ && mkdir -p backup/postgres/$DATE
BACKUP_DIR="backup/postgres/$DATE"

DATABASES=$(PGPASSWORD=$PGPASSWORD psql -h $PGHOST -p $PGPORT -U $PGUSER -l -t | cut -d '|' -f 1 | grep -E -v "(template0|template1|^$)")

for DB in $DATABASES; do
    BACKUP_FILE="$BACKUP_DIR/$DB-$DATE.sql"

    PGPASSWORD=$PGPASSWORD pg_dump -h $PGHOST -p $PGPORT -U $PGUSER -d $DB > $BACKUP_FILE

    if [ $? -eq 0 ]; then
        echo "Backup of database $DB completed successfully and saved to $BACKUP_FILE"
    else
        echo "Error: Backup of database $DB failed."
    fi
done
