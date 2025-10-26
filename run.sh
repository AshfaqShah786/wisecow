#!/bin/bash
set -e

echo "🚀 Starting Wisecow CI/CD deployment..."

# 1️⃣ Use Minikube's Docker daemon
echo "➡️ Setting Docker to use Minikube's daemon..."
eval $(minikube docker-env)

# 2️⃣ Build Docker image
IMAGE_NAME="ashfaqs96/wisecow:latest"
echo "➡️ Building Docker image: $IMAGE_NAME ..."
docker build -t $IMAGE_NAME .

# 3️⃣ Apply TLS secret
TLS_SECRET_NAME="wisecow-tls"
if kubectl get secret $TLS_SECRET_NAME -n default &> /dev/null; then
  echo "➡️ TLS secret $TLS_SECRET_NAME already exists, updating..."
  kubectl delete secret $TLS_SECRET_NAME -n default
fi

echo "➡️ Creating TLS secret..."
kubectl create secret tls $TLS_SECRET_NAME \
  --cert=wisecow.crt --key=wisecow.key \
  -n default

# 4️⃣ Apply Kubernetes manifests
echo "➡️ Applying Deployment, Service, and Ingress..."
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/ingress.yaml

# 5️⃣ Wait for deployment rollout
echo "➡️ Waiting for deployment rollout..."
kubectl rollout status deployment/wisecow -n default

# 6️⃣ Done
echo "✅ Wisecow app successfully deployed on Minikube!"
echo "Access it via: https://wisecow.local (use --insecure with curl if using self-signed cert)"

