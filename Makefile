VAULT_IDENTITY 		=	--vault-id "default@$(PASSWORD_FILE)"
VAULT_FILE 			=	group_vars/all/vault.yml
PASSWORD_FILE		?=	secrets/password
INPUT_VAULT			?=	secrets/vault


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

vault: $(VAULT_FILE)
	@ansible-vault edit $(VAULT_IDENTITY) $(VAULT_FILE)

$(VAULT_FILE): $(INPUT_VAULT)
	@ansible-vault encrypt $(VAULT_IDENTITY) --encrypt-vault-id default --output $(VAULT_FILE) $(INPUT_VAULT)

status:
	@ansible appservers --become $(VAULT_IDENTITY) -a "docker compose -f /opt/inception/docker-compose.yml ps"

.PHONY: all requirements phpmyadmin destroy deploy lint syntax check dry-run vault status
