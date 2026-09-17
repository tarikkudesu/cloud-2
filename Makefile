VAULT_IDENTITY					= --vault-id "default@$(PASSWORD_FILE)"
VAULT_FILE						= group_vars/all/vault.yml
PASSWORD_FILE 					?= secrets/password
INPUT_VAULT						?= secrets/vault

all: deploy

phpmyadmin:
	@ssh -L 8080:127.0.0.1:8080 ubuntu@0.0.0.0

destroy:
	@ansible-playbook $(VAULT_IDENTITY) unplaybook.yml

deploy:
	@ansible-playbook $(VAULT_IDENTITY) playbook.yml

check:
	@ansible-playbook $(VAULT_IDENTITY) --syntax-check playbook.yml
	@ansible-inventory $(VAULT_IDENTITY) --graph

vault: $(VAULT_FILE)
	@ansible-vault edit $(VAULT_IDENTITY) $(VAULT_FILE)

$(VAULT_FILE): $(INPUT_VAULT)
	@ansible-vault encrypt $(VAULT_IDENTITY) --encrypt-vault-id default --output $(VAULT_FILE) $(INPUT_VAULT)

status:
	@ansible servers --become $(VAULT_IDENTITY) -a "docker compose $(COMPOSE_FILES) ps"

.PHONY: all deploy check vault status phpmyadmin
