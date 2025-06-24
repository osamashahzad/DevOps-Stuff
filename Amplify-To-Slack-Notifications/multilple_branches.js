const https = require('https');

// Slack webhook URL
const webhookUrl = "https://hooks.slack.com/services/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";

exports.handler = async (event) => {
    const sns = event.Records[0].Sns.Message;

    // Log the SNS message for inspection
    console.log("SNS Message:", sns);

    // Extract branch name dynamically from the SNS message
    let Branch = extractBranchFromMessage(sns);
    let Url = getUrlForBranch(Branch);
    let WebsiteName = getWebsiteNameForBranch(Branch);

    let message = '';
    let color = '';

    // Handle different build statuses
    if (sns.includes('build status is FAILED')) {
        message = `Build Failed.\nWebsite: ${WebsiteName}\nBranch: ${Branch}\n`;
        color = '#E52E59';
    } else if (sns.includes('build status is SUCCEED')) {
        message = `Build Process Succeeded.\nWebsite: ${WebsiteName}\nBranch: ${Branch}\nUrl: ${Url}\n`;
        color = '#21E27C';
    } else if (sns.includes('build status is STARTED')) {
        message = `Build Process Started.\nWebsite: ${WebsiteName}\nBranch: ${Branch}\n`;
        color = '#3788DD';
    }

    const data = JSON.stringify({
        attachments: [
            {
                'mrkdwn_in': ['text'],
                fallback: message,
                color,
                text: message
            }
        ]
    });

    return new Promise((resolve, reject) => {
        const request = https.request(webhookUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Content-Length': data.length,
            }
        }, (res) => {
            res.on('end', () => resolve());
        });

        // Write the data and end the request
        request.write(data);
        request.end();
    });
};

// Function to extract the branch name from the SNS message
function extractBranchFromMessage(snsMessage) {
    return snsMessage.match(/branches\/([^\?]+)/)[1];
}

// Function to return the URL based on the branch
function getUrlForBranch(branch) {
    // Custom domain mappings for each branch
    const branchUrls = {
        "pre-prod": "https://pre-prod.thetrumptoken.com",
        "staging": "https://stg.thetrumptoken.com",
        // Add more branches here as needed
    };

    // Return the URL for the branch, or a default URL
    return branchUrls[branch] || "https://default.example.com";
}

// Function to return the website name based on the branch
function getWebsiteNameForBranch(branch) {
    // Website names for each branch
    const websiteNames = {
        "staging": "Trump-Token-Staging",
        "pre-prod": "Trump-Token-PreProd",
        // Add more branches here as needed
    };

    // Return the Website Name for the branch, or a default name
    return websiteNames[branch] || "Default Website";
}
