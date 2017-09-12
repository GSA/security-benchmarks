## GSA Security Benchmarks

Welcome to General Services Administration (GSA) Information Security Engineering (ISE) GitHub. Here you can find tools to help implement and audit GSA security benchmarks.

### What are these benchmarks?

The ISE publishes security guides for various systems at the GSA. For more information, please refer to the published guide on insite.gsa.gov.  

### Available Tools

* [IT Security Technical Guides and Standards](https://insite.gsa.gov/portal/content/627210) (only accessible to GSA)
    * See the Hardening Guides
* [Tenable Nessus Audit Files](https://drive.google.com/drive/folders/0BwLUd26GHbxiT1hMVUtRTGNKZjg) (only accessible to GSA)
    * These are testing what is required by the Hardening Guides
* [Windows GPOs](https://github.com/GSA/ISE-Security-Benchmark-GPOs)

### Ansible Roles

* [Jenkins](https://github.com/GSA/jenkins-deploy)
* [NGINX HTTPS proxy](https://github.com/GSA/ansible-https-proxy)

#### Hardening

These configure base operating systems in line with the Hardening Guides linked above, to the greatest extent possible.

* [RHEL 7](https://github.com/GSA/ansible-os-rhel-7)
* [Ubuntu 14](https://github.com/GSA/ansible-os-ubuntu-14)

### Coming Soon
- [More Ansible Roles](https://github.com/GSA/ISE-Security-Benchmarks/issues/5)
- Puppet
- Chef
