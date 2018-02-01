import csv
import json
import os

# boilerplate
policy = {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [],
            "Resource": [
                "*"
            ]
        }
    ]
}

SRC = os.getenv('SRC', 'export.csv')
namespaces = set()
with open(SRC, newline='') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        namespace = row['Service Identifier']
        status = row['Approval Status']
        if namespace and 'approved' in status.lower():
            namespaces.add(namespace)

actions = [ns + ':*' for ns in namespaces]
actions.sort()
policy['Statement'][0]['Action'] = actions

print(json.dumps(policy, indent=4))
