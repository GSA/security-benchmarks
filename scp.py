import csv
import json
import os


def is_approved(row):
    status = row['Approval Status']
    return 'approved' in status.lower()


def get_namespaces(csv_path):
    results = set()
    with open(csv_path, newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            namespace = row['Service Identifier']
            if namespace and is_approved(row):
                results.add(namespace)

    return results

def get_actions(namespaces):
    actions = [ns + ':*' for ns in namespaces]
    actions.sort()
    return actions


def generate_policy(actions):
    return {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": actions,
                "Resource": [
                    "*"
                ]
            }
        ]
    }


def csv_to_policy(csv_path):
    namespaces = get_namespaces(SRC)
    actions = get_actions(namespaces)
    return generate_policy(actions)


SRC = os.getenv('SRC', 'export.csv')
policy = csv_to_policy(SRC)
print(json.dumps(policy, indent=4))
