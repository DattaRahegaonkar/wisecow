#!/bin/bash

# Install NGINX Ingress Controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# Wait for ingress controller
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s

# Install cert-manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.2/cert-manager.yaml

# Wait for cert-manager
kubectl wait --namespace cert-manager --for=condition=ready pod --selector=app.kubernetes.io/name=cert-manager --timeout=90s

# Apply namespace
kubectl apply -f kubernetes/namespace.yml

# Apply TLS configuration
kubectl apply -f kubernetes/tls-setup.yml

# Apply application
kubectl apply -f kubernetes/wisecow.yml
kubectl apply -f kubernetes/wisecow-service.yml

echo "Setup complete. Add '127.0.0.1 wisecow.local' to /etc/hosts"
echo "Access via: https://wisecow.local"
