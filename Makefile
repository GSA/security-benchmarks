ami: rhel7

rhel7: roles
	packer build -var-file=packer/rhel7.json packer/template.json

roles:
	ansible-galaxy install -p ansible/roles -r ansible/requirements.yml
