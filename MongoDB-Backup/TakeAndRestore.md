## Authors
[@nauman-akram](https://github.com/naumanakram-km)
## MongoDB Backup using CLI ( Linux - Ubuntu - 22.04 - 24.04 )
1- Download Required Tools
```bash
##wget https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu2204-x86_64-100.8.0.deb  (For Ubuntu 22.04)
wget https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu2404-x86_64-100.10.0.deb  (For Ubuntu 24.04)
```
For more info please see: https://www.mongodb.com/docs/database-tools/

2- Install Downloaded Package
```bash
sudo dpkg -i mongodb-database-tools-ubuntu2404-x86_64-100.10.0.deb
```

## Take Backup
```bash
mongodump --uri="<SOURCE_MONGO_URI>" --out <OUTPUT_DIR>
```

## Restore Backup
```bash
mongorestore --uri="<DESTINATION_MONGO_URI>" <PATH_TO_BACKUP_DIR>
```

## Take Backup of all DBs in Cluster.
You can use the script by passing the ClusterURI and Destination Directory. It will take backup of all the DBs inside a cluster.
```bash
cd PATH_TO_SCRIPT && chmod +x takeBackup.sh
```
```bash
./takeBackup.sh
```
