Follow the following steps in order to take backups of your databases and store them into your s3 bucket:

1. Run the mysql-backup.sh script to take backups of your databases. You can also change the path of the directory where you want to store the backups.
2. Now run the upload-backup-to-s3.sh script in order to upload the backups to your bucket.

***You can setup cronjobs for both the scripts to have scheduled backups taken and uploaded to your s3 bucket***