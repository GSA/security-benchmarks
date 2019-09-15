import csv
import json
import os
import re
import sys
from io import _io


def is_approved(row):
    status = row['Approval Status'].lower()
    return (
        'approved' in status and
        re.match("(not|isn'?t|hasn'?t).*approved", status) is None
    )


def get_namespaces(csv_data):
    results = set()
    if type(csv_data) == str:
        reader = csv.DictReader(open(csv_data, newline=''))
    if isinstance(csv_data, _io.TextIOWrapper):
        reader = csv.DictReader(csv_data)
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


def csv_to_policy(csv):
    namespaces = get_namespaces(csv)
    # sanity check
    if not namespaces:
        raise RuntimeError("Expected to find more than zero namespaces")

    actions = get_actions(namespaces)
    actions.sort()
    return generate_policy(actions)


if __name__ == '__main__':
    # if stdin is not a tty then stdin has data and use it over env var
    if not sys.stdin.isatty():
        SRC = sys.stdin
    else:
        SRC = os.getenv('SRC', 'export.csv')
    policy = csv_to_policy(SRC)
    print(json.dumps(policy, indent=4))
