ami: roles
	packer build packer/rhel7_base.json

roles:
	ansible-galaxy install -p ansible/roles -r ansible/requirements.yml
