---
title: "WordPress"
weight: 4
---


## Objectif
Frontend du blog connecté à MariaDB.

## Injection des secrets
WordPress reçoit les variables depuis **Vault Agent** dans `/vault/secrets/wp.env`, chargées par l'entrypoint.

### Vérifications utiles
```bash
WPPOD=$(kubectl -n blog get pod -l app=wordpress -o jsonpath='{.items[0].metadata.name}')
kubectl -n blog exec "$WPPOD" -c wordpress -- cat /vault/secrets/wp.env
kubectl -n blog exec "$WPPOD" -c wordpress -- grep -E 'DB_(HOST|NAME|USER)' /var/www/html/wp-config.php
```

### Persistance
```bash
kubectl -n blog exec "$WPPOD" -c wordpress -- sh -lc 'echo ok > /var/www/html/wp-content/test.txt'
kubectl -n blog delete pod -l app=wordpress
kubectl -n blog wait --for=condition=Ready pod -l app=wordpress --timeout=120s
NEW=$(kubectl -n blog get pod -l app=wordpress -o jsonpath='{.items[0].metadata.name}')
kubectl -n blog exec "$NEW" -c wordpress -- cat /var/www/html/wp-content/test.txt
```
