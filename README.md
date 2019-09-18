# GSA Security Benchmarks [![CircleCI](https://circleci.com/gh/GSA/security-benchmarks.svg?style=svg)](https://circleci.com/gh/GSA/security-benchmarks)

Welcome to the General Services Administration Security Benchmarks repository. As automated implementation and verification content is developed and updated, it will be posted here. This content is provided as a tool to facilitate implementation and verification of security settings required by the GSA Security Benchmarks.

## What are GSA Security Benchmarks?

The GSA publishes security guides for various operating systems and applications commonly used at the agency. For more information, please refer to the published guides on [insite.gsa.gov](https://insite.gsa.gov/portal/content/627210) (*only accessible with GSA account*).

## Available Content

### Security Benchmark Documentation

Dependency: GSA account

* [Hardening Guides](https://insite.gsa.gov/portal/content/627210) - Documents outlining the general use and standards for security benchmarks.
* [Security Benchmark Worksheets](https://drive.google.com/drive/folders/0BwLUd26GHbxibTFROVdoSk1RNUE) - Individual worksheets itemizing the security benchmark settings.

    
### Automated Implementation

#### Ansible Playbooks

Dependency: [Ansible](https://docs.ansible.com/ansible/latest/intro_installation.html)

* [RHEL 6](https://github.com/GSA/ansible-os-rhel-6)
* [RHEL 7](https://github.com/GSA/ansible-os-rhel-7)
* [Ubuntu 16](https://github.com/GSA/ansible-os-ubuntu-16)
* [Windows Server 2016](https://github.com/GSA/ansible-os-win-2016)

#### GPOs

* [Windows Server 2012 R2](https://github.com/GSA/ISE-Security-Benchmark-GPOs)



### Automated Verification

Dependency: GSA account

* [Tenable/Nessus Audit Files](https://drive.google.com/drive/folders/0BwLUd26GHbxiT1hMVUtRTGNKZjg) - Custom audit content for use with Tenable Security Center or Nessus Vulnerability Scanner
* [BigFix Compliance Checklists](https://bigfixcompliance.gsa.gov:52315/scm) - Custom audit content for use with hosts that are registered with the BigFix platform.

For questions or comments, contact OCISO ISE: [ise-guides@gsa.gov](mailto:ise-guides@gsa.gov).

<!-- reference-style links, to de-duplicate URLs and keep the table above readable -->

[ClamAV]: https://www.clamav.net/
[Cylance]:https://www.cylance.com/en_us/products/our-products/protect.html
[FireEyeHx]:https://www.fireeye.com/blog/products-and-services/2017/09/bringing-advanced-protection-to-endpoints.html
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
