# Service Control Policy

GSA uses a spreadsheet to track the approval status of AWS services. To generate a [Service Control Policy](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scp.html) to only allow approved services:

1. Export a CSV from [the AWS service approval tracking spreadsheet](https://docs.google.com/spreadsheets/d/1kJrPqu10x80LaGQ_oXFDuoPkBdnaXrXTQVF_uJ14-ok/edit#gid=0).
    * Link above only accessible to GSA.
    * Expects columns:
        * `Service Namespace`, with the lower-case [namespace](https://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html#genref-aws-service-namespaces) values (`ec2`, etc.)
        * `Approval Status`, with the word `Approved`...or not
1. Generate the policy.

        $ SRC=path/to/export.csv python3 scp.py
        {
            "Version": "2012-10-17",
            ...
        }

1. Validate the policy.
    1. [Create a new IAM policy in the AWS Console.](https://console.aws.amazon.com/iam/home#/policies$new?step=edit)
    1. Paste in the generated JSON.
    1. Click `Review policy`.
    1. Review [the warnings/errors](https://docs.aws.amazon.com/IAM/latest/UserGuide/troubleshoot_policies.html#troubleshoot_policies-unrecognized-visual).
    1. Close the tab - you don't need to save the policy here.
1. [Create the Service Control Policy](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scp.html#create_policy) with the generated JSON.
