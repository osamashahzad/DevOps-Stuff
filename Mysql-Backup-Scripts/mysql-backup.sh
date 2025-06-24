#!/bin/bash
PASS="" #Enter Password of your DB in the PASS variable
EXCLUDE_DBS=("information_schema" "mysql" "performance_schema" "sys")
CURRENT_DATE=$(date +%Y-%m-%d)
CURRENT_TIME=$(date +%H:%M:%S)
cd ~ && mkdir -p backup/mysql/$CURRENT_DATE
BACKUP_DIR="backup/mysql/$CURRENT_DATE"
# Get the list of all databases
ALL_DATABASES=$(mysql -u root -p$PASS -N -B -e "SHOW DATABASES;")
# Loop through each database and create backups (excluding the ones in EXCLUDE_DBS)
for DB_NAME in $ALL_DATABASES; do
  if [[ ! " ${EXCLUDE_DBS[@]} " =~ " $DB_NAME " ]]; then
    FILE_NAME="${BACKUP_DIR}/${DB_NAME}_${CURRENT_TIME}.sql"
    mysqldump -u root --password="$PASS" "$DB_NAME" --routines > "$FILE_NAME"
    echo "MySQL database $DB_NAME backup saved to: $FILE_NAME"
  fi
done
