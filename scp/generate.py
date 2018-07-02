import csv
import json
import os
import re


def is_approved(row):
    status = row['Approval Status'].lower()
    return (
        'approved' in status and
        re.match("(not|isn'?t|hasn'?t).*approved", status) is None
    )


def get_namespaces(csv_path):
    results = set()
    with open(csv_path, errors='surrogateescape') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            namespace = row['Service Namespace']
            if namespace and is_approved(row):
                results.add(namespace)

    return results


def get_actions(namespaces):
    return [ns + ':*' for ns in namespaces]


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
    namespaces = get_namespaces(csv_path)
    # sanity check
    if not namespaces:
        raise RuntimeError("Expected to find more than zero namespaces")

    actions = get_actions(namespaces)
    actions.sort()
    return generate_policy(actions)


if __name__ == '__main__':
    SRC = os.getenv('SRC', 'export.csv')
    policy = csv_to_policy(SRC)
    print(json.dumps(policy, indent=4))
