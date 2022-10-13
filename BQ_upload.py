from google.cloud import bigquery
import os

credentials_path = "/Users/sambhav/Desktop/BigQueryPipeline/credentials/BQkey.json"
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = credentials_path

#creates a big query client
client = bigquery.Client()

#TODO: Make file_path and table_ID easy to change based on user input
#sets table and file path 
table_id = "united-wavelet-356113.AUTODROM_MASTER_LITE.test8"
file_path = "/Users/sambhav/Desktop/BigQueryPipeline/output/test2.tsv"


job_config = bigquery.LoadJobConfig(
    source_format=bigquery.SourceFormat.CSV, skip_leading_rows=1, autodetect=False , schema = {}
)

#TODO: Ensure that the load function makes use of your predefined schema rather than auto-schema
#TODO: Set delimited to tab instead of comma
with open(file_path, "rb") as source_file:
    job = client.load_table_from_file(source_file, table_id, job_config=job_config)

job.result()  # Waits for the job to complete.

table = client.get_table(table_id)  # Make an API request.
print(
    "Loaded {} rows and {} columns to {}".format(
        table.num_rows, len(table.schema), table_id
    )
)