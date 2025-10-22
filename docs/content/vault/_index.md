---
title: "Vault"
weight: 2
---


## Objectif
Gestion centralisée **des secrets et identifiants** utilisés par les pods (WordPress, exporters…).

## Déploiement
```bash
helm repo add hashicorp https://helm.releases.hashicorp.com
helm upgrade --install vault hashicorp/vault -n vault --create-namespace
```

## Configuration réalisée
- Auth Kubernetes activée (`auth/kubernetes`)
- Rôle **blog-role** lié au SA du namespace `blog` avec la policy **blog-policy**
- KV v2 `kv/blog/db` contenant `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_ROOT_PASSWORD`

### Vérifications
```bash
kubectl -n vault exec vault-0 -- vault status
kubectl -n vault exec vault-0 -- vault auth list
kubectl -n vault exec vault-0 -- vault secrets list
kubectl -n vault exec vault-0 -- vault read auth/kubernetes/role/blog-role
kubectl -n vault exec vault-0 -- vault kv get kv/blog/db
```
