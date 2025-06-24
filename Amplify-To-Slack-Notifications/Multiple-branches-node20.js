import https from 'https';

const webhookUrl = "https://hooks.slack.com/services/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";

export const handler = async (event) => {
    const sns = event.Records[0].Sns.Message;

    console.log("SNS Message:", sns);

    let Branch = extractBranchFromMessage(sns);
    let Url = getUrlForBranch(Branch);
    let WebsiteName = getWebsiteNameForBranch(Branch);

    let message = '';
    let color = '';

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

    return sendSlackMessage(data);
};

const sendSlackMessage = async (data) => {
    return new Promise((resolve, reject) => {
        const request = https.request(webhookUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Content-Length': data.length,
            }
        }, (res) => {
            let response = '';

            res.on('data', (chunk) => {
                response += chunk;
            });

            res.on('end', () => {
                if (res.statusCode >= 200 && res.statusCode < 300) {
                    resolve(response);
                } else {
                    reject(new Error(`Slack API responded with status code ${res.statusCode}: ${response}`));
                }
            });
        });

        request.on('error', (err) => {
            reject(err);
        });

        request.write(data);
        request.end();
    });
};

function extractBranchFromMessage(snsMessage) {
    return snsMessage.match(/branches\/([^\?]+)/)[1];
}

function getUrlForBranch(branch) {
    const branchUrls = {
        "staging": "https://stg-ghostsmarketplace.kryptomind.net",
    };
    return branchUrls[branch] || "https://default.example.com";
}

function getWebsiteNameForBranch(branch) {
    const websiteNames = {
        "staging": "Ghosts-Marketplace-FE-Staging",
    };
    return websiteNames[branch] || "Default Website";
}
