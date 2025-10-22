---
title: "MariaDB"
weight: 3
---


## Objectif
Base de données **WordPress**.

## Points clés
- StatefulSet `mariadb` (labels: `app=mariadb, tier=database`)
- Service `mariadb` **sélecteur strict** `app=mariadb,tier=database`
- Exporter `mariadb-metrics` séparé (labels: `app=mariadb,tier=exporter`)

## Sanity-check
```bash
# Pod + IP
kubectl -n blog get pod -l app=mariadb -o wide

# Service + Endpoints (doit montrer l'IP du pod DB uniquement)
kubectl -n blog get svc mariadb
kubectl -n blog get endpoints mariadb -o wide

# Connexion root sur l'IP du pod
ROOTPW=$(kubectl -n blog get secret db-secret -o jsonpath='{.data.MYSQL_ROOT_PASSWORD}' | base64 -d)
MDB_IP=$(kubectl -n blog get pod -l app=mariadb -o jsonpath='{.items[0].status.podIP}')
kubectl -n blog run mysql-client --rm -it --image=mariadb:11 --restart=Never --   bash -lc 'mariadb --ssl=OFF -h'"$MDB_IP"' -uroot -p"'"$ROOTPW"'" -e "SELECT 1"'
```
