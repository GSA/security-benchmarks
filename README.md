## GSA Security Benchmarks

Welcome to General Services Administration Security Benchmarks repository. Here you can find items to help implement GSA Security Benchmarks, Infrastructure As Code, and other tools for [our DevSecOps work](https://tech.gsa.gov/guides/dev_sec_ops_guide/).

### What are GSA Security Benchmarks?

The GSA publishes security guides for various operating systems and applications commonly used at the agency. For more information, please refer to the published guides on [insite.gsa.gov](https://insite.gsa.gov/portal/content/627210).  

### Available Tools

* GSA Security Benchmarks (only accessible to GSA)
    * [IT Security Technical Guides and Standards](https://insite.gsa.gov/portal/content/627210) Documents outlining the general use and standards for security baselines.
    * [Security Benchmark Workbooks](https://drive.google.com/drive/folders/0BwLUd26GHbxibTFROVdoSk1RNUE) Individual workbooks listing the applicable security settings.

* [Tenable Nessus Audit Files](https://drive.google.com/drive/folders/0BwLUd26GHbxiT1hMVUtRTGNKZjg) (only accessible to GSA)
    * Custom audit files for use with Tenable Security Center or Nessus Vulnerability Scanner

### IAC Tools

## Terraform Modules

* [Base Infrastructure](https://github.com/GSA/DevSecOps-Infrastructure)
* [Jenkins](https://github.com/GSA/jenkins-deploy)

## Ansible Roles

* [Jenkins](https://github.com/GSA/jenkins-deploy)
* [NGINX HTTPS proxy](https://github.com/GSA/ansible-https-proxy)

#### Security Hardening

These configure base operating systems in line with the Hardening Guides linked above, to the greatest extent possible.

* [RHEL 7](https://github.com/GSA/ansible-os-rhel-7)
* [Ubuntu 14](https://github.com/GSA/ansible-os-ubuntu-14)
* RHEL 6 Comming Soon
* Ubuntu 16 Comming Soon
* [GPOs and INF for server 2008/2012](https://github.com/GSA/ISE-Security-Benchmark-GPOs)
