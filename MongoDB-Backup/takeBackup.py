import os
import subprocess
import shutil
import boto3
from datetime import datetime

# Take Backup
def take_mongodb_backup(uri, output_dir):
    try:
        # Run mongodump command with URI and output directory
        subprocess.run(['mongodump', '--uri', uri, '--out', output_dir], check=True)
        print(f"MongoDB backup for {output_dir} completed successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Error: MongoDB backup for {output_dir} failed with error: {e}")

# Generate ZIP Files
def make_zip_files(output_filename, base_directory):
    shutil.make_archive(output_filename, "zip", base_directory)

# Sync With S3
def upload_zip_files_to_s3(directory_path, bucket_name, s3_directory):
    """
    Uploads all zip files in a directory to an S3 bucket in a specific directory.

    Parameters:
    - directory_path: Path to the directory containing zip files.
    - bucket_name: Name of the S3 bucket.
    - s3_directory: Directory within the bucket where the files will be uploaded.
    """
    # Create an S3 client
    s3 = boto3.client('s3')

    # Iterate over files in the directory
    for filename in os.listdir(directory_path):
        if filename.endswith('.zip'):
            # Construct full file path
            file_path = os.path.join(directory_path, filename)

            # Construct the S3 key (file path within the bucket)
            s3_key = f"{s3_directory}/{filename}"

            # Upload the file to S3
            try:
                s3.upload_file(file_path, bucket_name, s3_key)
                print(f"Successfully uploaded {file_path} to S3 bucket {bucket_name} in directory {s3_directory}.")
            except Exception as e:
                print(f"Error uploading {file_path} to S3 bucket {bucket_name}: {e}")

# Get Todays Date
def get_formatted_date():
    todays_date = datetime.today().date().strftime("%d-%b-%Y")
    return todays_date

# Clean System Resources
def clean_system_resources(delete_directory, delete_zip_files):
    if delete_zip_files == True:
       files = os.listdir()
       # Filter the list to only include zip files
       zip_files = [file for file in files if file.endswith('.zip')]
       if zip_files:
        # Assuming you want to delete all zip files found in the current directory
        for zip_file in zip_files:
            os.remove(zip_file)
        print("Zip files deleted successfully.")
    else:
        print("No zip files found in the current directory.") 
    #shutil.rmtree(delete_directory)

# Starting the execution
if __name__ == "__main__":

    # List of MongoDB URIs and corresponding relative output directories
    mongodb_uris = [
        # Sample Input
        #("MONGO_URI", "FOLDER_NAME")
        # Add more MongoDB URIs and relative output directories as needed
    ]

    # Base directory to append
    base_directory = "/home/nauman/Mongo_Backups/"
    bucket_name = "staging-db-backups-new" 
    s3_dir = "MongoDB-Backups/"+get_formatted_date()

    # Perform backup for each MongoDB URI
    for uri, relative_output_dir in mongodb_uris:
        # Concatenate base directory with relative output directory
        output_dir = os.path.join(base_directory, relative_output_dir)
        take_mongodb_backup(uri, output_dir)
        make_zip_files(relative_output_dir, output_dir)
    
    upload_zip_files_to_s3(".", bucket_name, s3_dir)
    clean_system_resources(base_directory, delete_zip_files=True)

