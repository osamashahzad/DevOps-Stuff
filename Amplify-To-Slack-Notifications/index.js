// This should be your webook URL from Slack Incoming Webhooks
const webhookUrl = "<SLACK WEBHOOK URL>";
const https = require('https')

exports.handler = async (event) => {
	const sns = event.Records[0].Sns.Message
    var WebsiteName = "<WEBSITE NAME>"
    var Branch = "<BRANCH>"
    var Url = "<URL OF THE WEBSITE>"
	let message = ''
  let color = ''
	if (sns.includes('build status is FAILED')) {
		message = 'Build Failed.\nWebsite: ' + WebsiteName + '\nBranch: ' + Branch + '\n'
		color = '#E52E59'
	} else if (sns.includes('build status is SUCCEED')) {
		message = 'Build Process Succeeded.\nWebsite: '+ WebsiteName + '\nBranch: '+ Branch + '\nUrl: ' + Url + '\n'
		color = '#21E27C'
	} else if (sns.includes('build status is STARTED')) {
		message = 'Build Process Started.\nWebsite: ' + WebsiteName + '\nBranch: ' + Branch + '\n'
		color = '#3788DD'
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
	})
	return new Promise((resolve, reject) => {
		// Prepare the request.
		const request = https.request(webhookUrl, {
			method: 'POST',
			headers: {
				// Specify the content-type as JSON and pass the length headers.
				'Content-Type': 'application/json',
				'Content-Length': data.length,
			}
		}, (res) => {
			// Once the response comes back, resolve the Promise.
			res.on('end', () => resolve())
		})
		// Write the data we generated from above and end the request.
		request.write(data)
		request.end()
	})
}
