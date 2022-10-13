<h2><strong>GOAL:</strong></h2>

To create a continuous pipeline that can push data into Big query from Google sheets.

This would enable average users to continue adding/editing raw values in a user-friendly enviroment and remove to requirement of learning SQL for existing employees.

<h2><strong>PROCESS</strong></h2>

- Set up the credentials for the google drive account in use
- Use the ruby script google_drive.rb and download the spreadsheet into the output folder
- Make sure to specify the name of the sheet you want to download as parameters when running the ruby script
- Once in the output folder, you can run the BQ_upload.py script to push the specified data into the BQ account specified by the credentials

<h2><strong>FUTURE IMPROVEMENTS</strong></h2>

- Use Google cloud storage to eliminate the need of downloading output files onto a local system
- Create a system that automatically downloads and configures the schema from the google sheet that is downloaded
- Make use of a cron job inorder to enable automatic and timely updates to the database
