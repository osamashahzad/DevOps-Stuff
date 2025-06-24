Follow the following steps in order to take backups of your databases and store them into your s3 bucket:

1. Place both scripts on your home directory.
2. First run the *postgres-db-backup.sh*. It will take backups of all the dbs present on your postgres server. 
3. Now run the *upload-to-s3.sh* file. This will first  of all make a tar file of your backup folder and then upload it to your s3 bucket.

***You can setup cronjobs for both the scripts to have scheduled backups taken and uploaded to your s3 bucket***

To restore the backup, use pgadmin 4. Right click on the desired db and choose the psql tool query method for restoring it.

Use this url as reference: 

https://stackoverflow.com/questions/2732474/restore-a-postgres-backup-file-using-the-command-line