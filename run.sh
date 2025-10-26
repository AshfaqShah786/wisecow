#!/usr/bin/env bash
set -e

APP_HOST="wisecow.local"
TLS_SECRET="wisecow-tls"

echo "Building Docker image inside Minikube..."
eval $(minikube docker-env)
docker build -t wisecow:latest .

echo "Deploying Wisecow app..."
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

echo "Enabling ingress..."
minikube addons enable ingress || true

echo "Creating TLS certificate..."
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout tls.key -out tls.crt -subj "/CN=${APP_HOST}/O=${APP_HOST}"
kubectl create secret tls ${TLS_SECRET} --cert=tls.crt --key=tls.key --dry-run=client -o yaml | kubectl apply -f -

echo "Applying ingress..."
kubectl apply -f k8s/ingress.yaml

echo "Mapping hostname..."
MINIKUBE_IP=$(minikube ip)
echo "${MINIKUBE_IP} ${APP_HOST}" | sudo tee -a /etc/hosts

echo "Checking deployment..."
kubectl get pods
kubectl get svc
kubectl get ingress

echo "Visit: https://${APP_HOST} (accept the self-signed cert warning)"

