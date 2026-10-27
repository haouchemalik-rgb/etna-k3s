#!/bin/bash
# Crée les Secrets MariaDB / WordPress avec des mots de passe aléatoires.
# Aucun mot de passe n'est versionné. Idempotent : les Secrets existants sont conservés.
# (Version cible : identifiants servis par Vault, cf. manifests/06-wordpress-vault.yaml)

set -euo pipefail
NS="blog"

if kubectl get secret db-secret -n "$NS" >/dev/null 2>&1; then
  echo "Secrets déjà présents dans $NS : rien à faire."
  exit 0
fi

DB_PASS=$(openssl rand -base64 24 | tr -d '/+=' | cut -c1-24)
ROOT_PASS=$(openssl rand -base64 24 | tr -d '/+=' | cut -c1-24)

kubectl create secret generic db-secret -n "$NS" \
  --from-literal=MYSQL_DATABASE=wordpress \
  --from-literal=MYSQL_USER=wpuser \
  --from-literal=MYSQL_PASSWORD="$DB_PASS" \
  --from-literal=MYSQL_ROOT_PASSWORD="$ROOT_PASS"

kubectl create secret generic wp-secret -n "$NS" \
  --from-literal=WORDPRESS_DB_HOST=mariadb.blog.svc.cluster.local \
  --from-literal=WORDPRESS_DB_NAME=wordpress \
  --from-literal=WORDPRESS_DB_USER=wpuser \
  --from-literal=WORDPRESS_DB_PASSWORD="$DB_PASS"

echo "Secrets db-secret et wp-secret créés dans le namespace $NS."
