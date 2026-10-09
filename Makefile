PASSWORD_FILE		?=	password
VAULT_FILE 			=	group_vars/all/vault.yml
VAULT_IDENTITY 		=	--vault-id "default@$(PASSWORD_FILE)"


all: deploy

requirements:
	@ansible-galaxy collection install community.general

phpmyadmin:
	@ssh -L 8080:127.0.0.1:8080 ubuntu@0.0.0.0

destroy:
	@ansible-playbook $(VAULT_IDENTITY) unplaybook.yml

deploy:
	@ansible-playbook $(VAULT_IDENTITY) playbook.yml

lint:
	@yamllint .
	@ansible-lint playbook.yml unplaybook.yml

syntax:
	@ansible-playbook $(VAULT_IDENTITY) --syntax-check playbook.yml
	@ansible-playbook $(VAULT_IDENTITY) --syntax-check unplaybook.yml
	@ansible-inventory $(VAULT_IDENTITY) --graph

check: lint syntax

dry-run:
	@ansible-playbook $(VAULT_IDENTITY) --check --diff playbook.yml

vault:
	@ansible-vault encrypt $(VAULT_IDENTITY) $(VAULT_FILE)

status:
	@ansible appservers --become $(VAULT_IDENTITY) -a "docker compose -f /opt/inception/docker-compose.yml ps"

.PHONY: all requirements phpmyadmin destroy deploy lint syntax check dry-run vault status
