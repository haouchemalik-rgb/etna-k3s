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
DOC_PASS=$(openssl rand -base64 18)          # mot de passe aléatoire, à conserver dans un gestionnaire de mots de passe
kubectl -n blog create secret generic doc-auth --from-literal=users="admin:$(openssl passwd -apr1 "$DOC_PASS")"
echo "$DOC_PASS"
```

### Vérification
Ouvrir `https://doc.etna.student` et se connecter avec `admin` et le mot de passe généré ci-dessus.
