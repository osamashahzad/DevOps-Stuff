import requests
import json

ORG_NAME = ""
REPO_NAME = ""
PAT = "Bearer <PAT>"

# GET ARTIFACT URL OF REPO
url =  f"https://api.github.com/repos/{ORG_NAME}/{REPO_NAME}/actions/artifacts"
headers = {
    "Accept": "application/vnd.github+json",
    "Authorization": PAT,
    "X-GitHub-Api-Version": "2022-11-28"
}

response = requests.request("GET", url, headers=headers)
myjson = response.text
parse_json = json.loads(myjson)

if response.status_code != 200:
    print("\n *** Please double check your URL or PAT ***\n")

elif(len(parse_json['artifacts']) == 0):
    print("\n *** No Artifacts Found ***\n")

else:
    print("*** Total Number of Artifacts Found: ",len(parse_json['artifacts']),
        "***\n*** You may need to execute code twice as This code deletes 30 Artifacts at a time ***\n")
    
    # FILTER DATA AND FETCHING ONLY IDs FROM ARTIFACTS
    for i in range(len(parse_json['artifacts'])):
        id = parse_json['artifacts'][i]['id']
        print("Deleting Artifact",i, "having id =", id)
    
    # CALLING DELETE API AND DELETING ARTIFACTS
        requests.request("DELETE", url+"/"+str(id), headers=headers)    
    

