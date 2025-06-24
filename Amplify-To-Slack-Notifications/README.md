# Follow these steps to enable slack notifications for web applications hosted on AWS Amplify.
    1. Click on the notififcation option after deploying your web application.
    2. Add your email address in the email section and choose the branch you want to receive notifications for.
    3. Verify notification subscription by clicking on the link received on your email.
    4. Open lambda and create a new lambda function. Choose the create from scratch option while creating it.
    5. Create a new file named index.js & copy the code from the file given here into your index.js file.
    6. Change the value of the variables "WebsiteName", "Branch", "Url" according to your web application's specifications.
    7. Change the value of the webhookUrl to the url of your slack channel.
    8. Now deploy the code in order to save changes.
    9. Add trigger and choose the SNS topic you created in step 3.
    10. Now re-deploy your application in order to test your slack integration.
    11. If something doesn't go well, check the value of the following variables:
        i. webhookUrl
        ii. WebsiteName
        iii. Branch
        iv. Url 