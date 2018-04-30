# Service Control Policy

Individual AWS services need to be approved for use at GSA, or [through the FedRAMP JAB](https://marketplace.fedramp.gov/#/products?sort=productName&productNameSearch=aws), per GSA IT Security policy. GSA uses [a spreadsheet](https://docs.google.com/spreadsheets/u/1/d/1kJrPqu10x80LaGQ_oXFDuoPkBdnaXrXTQVF_uJ14-ok/edit#gid=0) to track the approval status of AWS services. The script in this folder reads an exported CSV from that spreadsheet, and generates a [Service Control Policy](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scp.html) (which is like an [IAM policy](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html)) allowing the approved services in JSON format, while denying everything else. This Service Control Policy is then [attached to the Organizational Unit](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies.html#attach_policy) for tenant subaccounts via an [AWS Organization](https://aws.amazon.com/organizations/) to only allow those approved services.

Note that some services are `Approved with Condition`, in which case there are restrictions on how the service can be used. See the spreadsheet for more details. This will be looked at during architecture review as part of the ATO assessment.

## Usage

To generate the Service Control Policy:

1. Export a CSV from [the AWS service approval tracking spreadsheet](https://docs.google.com/spreadsheets/d/1kJrPqu10x80LaGQ_oXFDuoPkBdnaXrXTQVF_uJ14-ok/edit#gid=0).
    * Link above only accessible to GSA.
    * Expects columns:
        * `Service Namespace`, with the lower-case [namespace](https://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html#genref-aws-service-namespaces) values (`ec2`, etc.)
        * `Approval Status`, with the word `Approved`...or not
1. Generate the policy.

        $ SRC=path/to/export.csv python3 scp/generate.py
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

While the generated Service Control Spreadsheet (artifact) isn’t version controlled, the code to generate it is versioned by Git, and the spreadsheet is versioned by Google Sheets. Changes to the spreadsheet are made by Security Engineering; changes to the code are made by pull request (by anyone, but particularly the DevSecOps team) and merged by DevSecOps.

## Compliance information

**Component approval status:** in assessment

**Relevant controls:**

Control | CSP/AWS | HOST/OS | App/DB | How is it implemented?
--- | --- | --- | --- | ---
[CM-7(2)](https://nvd.nist.gov/800-53/Rev4/control/CM-7) | ╳ | | | The Service Control Policy prevents use of AWS services that have not been approved.
[CM-7(5)(a)](https://nvd.nist.gov/800-53/Rev4/control/CM-7) | ╳ | | | AWS services are approved individually for use at GSA by Security Engineering. These are reflected in the spreadsheet, which this component then turns into a Service Control Policy with a corresponding `Allow` list.
[CM-7(5)(b](https://nvd.nist.gov/800-53/Rev4/control/CM-7)) | ╳ | | | This component generates a Service Control Policy with an `Allow` list. Since the “permission [to use a service] is blocked...implicitly (by not being included in an "Allow" policy statement)...then a user or role in the affected account cannot use that permission” ([source](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scp.html)). In other words, services not included in the `Allow` are considered blocked by AWS.
[CM-7(5)(c)](https://nvd.nist.gov/800-53/Rev4/control/CM-7) | ╳ | | | AWS services are reviewed and approved as needed by Security Engineering, with the status reflected in the spreadsheet. This component is used to generate a Service Control Policy from that spreadsheet and upload it to AWS. This update is done by the DevSecOps team every two weeks, and as needed at the request of tenant/Security teams.
[CM-8(3)(a)](https://nvd.nist.gov/800-53/Rev4/control/cm-8#enhancement-3) | ╳ | | | AWS services are approved individually for use at GSA by Security Engineering. This component creates a Service Control Policy with an `Allow` list of approved services. Unauthorized AWS services (which aren’t in that list) are understood by AWS to be implicitly denied.
[CM-8(3)(b)](https://nvd.nist.gov/800-53/Rev4/control/cm-8#enhancement-3) | ╳ | | | AWS gives an error through the Console, API, etc. when a user tries to access a service that isn’t included in the `Allow` list of the Service Control Policy. [More information.](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scp.html)