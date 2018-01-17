default: rhel7 ubuntu16

roles:
	ansible-galaxy install -p ansible/roles -r ansible/requirements.yml

validate_packer:
	packer validate -syntax-only packer/template.json
	packer validate -syntax-only -var-file=packer/rhel7.json packer/template.json
	packer validate -syntax-only -var-file=packer/ubuntu16.json packer/template.json

rhel7: roles
	packer build -var-file=packer/rhel7.json packer/template.json

ubuntu16: roles
	packer build -var-file=packer/ubuntu16.json packer/template.json
