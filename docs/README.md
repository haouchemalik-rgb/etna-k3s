# Documentation ISR-CLO4 (Hugo)

## Build
```bash
# Sur ta machine (avec Hugo installé)
hugo --minify
docker build -t registry.local/doc-isr:latest .
docker push registry.local/doc-isr:latest
```

## Déploiement
```bash
kubectl -n blog create secret generic doc-auth   --from-literal=users="admin:$(openssl passwd -apr1 SuperSecret)"

# Secret TLS doc-tls (auto-signé pour test)
kubectl -n blog create secret tls doc-tls   --cert=server.crt --key=server.key

kubectl apply -f manifests/doc-isr.yaml
```

Accès: https://doc.etna.student (BasicAuth).
