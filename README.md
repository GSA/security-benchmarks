# GSA Security Benchmarks

Welcome to the General Services Administration Security Benchmarks repository. Here you can find items to help implement GSA Security Benchmarks, Infrastructure As Code, and other tools for [our DevSecOps work](https://tech.gsa.gov/guides/dev_sec_ops_guide/).

## What are GSA Security Benchmarks?

The GSA publishes security guides for various operating systems and applications commonly used at the agency. For more information, please refer to the published guides on [insite.gsa.gov](https://insite.gsa.gov/portal/content/627210) (only accessible with GSA account).  

## Available Tools

### Benchmarks

Only accessible with GSA account.

* GSA Security Benchmarks
    * [IT Security Technical Guides and Standards](https://insite.gsa.gov/portal/content/627210) - Documents outlining the general use and standards for security baselines.
    * [Security Benchmark Workbooks](https://drive.google.com/drive/folders/0BwLUd26GHbxibTFROVdoSk1RNUE) - Individual workbooks listing the applicable security settings.
* [Tenable Nessus Audit Files](https://drive.google.com/drive/folders/0BwLUd26GHbxiT1hMVUtRTGNKZjg) - Custom audit files for use with Tenable Security Center or Nessus Vulnerability Scanner

For questions or comments, please email [ise-guides@gsa.gov](mailto:ise-guides@gsa.gov).

### Infrastructure

The [DevSecOps Example](https://github.com/GSA/devsecops-example) is a good starting point for understanding how all the various pieces fit together. The components are at varying levels of "completion" - see the README and open issues in the respective repository for more details. Feedback more than welcome!

#### Terraform Modules

* [Base Infrastructure](https://github.com/GSA/DevSecOps)
* [EKK (logging) stack](https://github.com/GSA/devsecops-ekk-stack)
* [Jenkins](https://github.com/GSA/jenkins-deploy)
* [AWS VPC flow logs](https://github.com/GSA/terraform-vpc-flow-log)

#### Ansible Roles

* [Jenkins](https://github.com/GSA/jenkins-deploy)
* [Nessus](https://github.helix.gsa.gov/GSASecOps/ansible-nessus-agent)
* [NGINX HTTPS proxy](https://github.com/GSA/ansible-https-proxy)
* [OSSEC][OSSEC]

### By operating system

Unless there's a good reason to go with something else, the following should be used on every server:

Requirement | Linux | Windows
--- | --- | ---
Activity monitoring | [OSSEC][OSSEC] | [OSSEC][OSSEC]
Antivirus | [ClamAV][ClamAV] | [ClamAV][ClamAV]
Hardening (to match [benchmarks](#benchmarks)) | [RHEL 6][RHEL 6], [RHEL 7][RHEL 7], [Ubuntu 14][Ubuntu 14], [Ubuntu 16][Ubuntu 16] | [Group Policy Settings][GPOs]
Log forwarding | [rsyslog](http://www.rsyslog.com/) | [Snare][Snare]
Multi-factor auth (required for internet-facing servers) | [Google Authenticator][GAuth] | [Rohos Logon Key][Rohos]
Vulnerability scanning | [Nessus][Nessus Linux] | [Nessus][Nessus Win]

<!-- reference-style links, to de-duplicate URLs and keep the table above readable -->

[ClamAV]: https://www.clamav.net/
[GAuth]: https://github.com/GSA/d2d/blob/master/docs/linux_mfa_setup.md
[Nessus Linux]: https://drive.google.com/open?id=0B726fftFCN-oemFRazdnM3FITE0
[Nessus Win]: https://drive.google.com/open?id=0B726fftFCN-oQUtGWWE3SENBYjg
[OSSEC]: https://github.helix.gsa.gov/GSASecOps/ansible-ossec-agent
[RHEL 6]: https://github.com/GSA/ansible-os-rhel-6
[RHEL 7]: https://github.com/GSA/ansible-os-rhel-7
[Rohos]: https://github.com/GSA/d2d/blob/master/docs/windows_mfa_setup.md
[Snare]: https://www.intersectalliance.com/our-product/snare-agent/
[Ubuntu 14]: https://github.com/GSA/ansible-os-ubuntu-14
[Ubuntu 16]: https://github.com/GSA/ansible-os-ubuntu-16
[GPOs]: https://github.com/GSA/ISE-Security-Benchmark-GPOs
