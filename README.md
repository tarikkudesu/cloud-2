# Cloud Infrastructure

An Ansible project that provisions a remote server and deploys a Docker Compose stack with Nginx, WordPress, MariaDB, and phpMyAdmin.

## Requirements

- Ansible
- Make
- SSH access to the target server

## Usage

1. Update `inventory` with the target host, SSH user, and `site_domain`.
2. Add the Vault password to `secrets/password` and the application secrets to `secrets/vault`.
3. Encrypt the secrets and deploy:

```sh
make vault
make check
make deploy
```

Useful commands:

```sh
make status       # Show container status
make phpmyadmin   # Forward phpMyAdmin to localhost:8080
make destroy      # Remove the deployed stack and managed resources
```

## License

MIT
