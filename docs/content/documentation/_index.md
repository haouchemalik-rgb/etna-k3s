---
title: "Service de documentation (Hugo)"
weight: 7
---


## Build local
```bash
hugo --minify
docker build -t registry.local/doc-isr:latest .
docker push registry.local/doc-isr:latest
```

## Manifeste Kubernetes
Voir `manifests/doc-isr.yaml` incluant :
- **Deployment** NGINX servant `public/`
- **Service** ClusterIP
- **Middleware Traefik** BasicAuth + Secret `doc-auth`
- **Ingress** TLS pour `doc.etna.student`

### Création du secret BasicAuth
```bash
kubectl -n blog create secret generic doc-auth   --from-literal=users="admin:$(openssl passwd -apr1 SuperSecret)"
```

### Vérification
Ouvrir `https://doc.etna.student` (admin / SuperSecret).
