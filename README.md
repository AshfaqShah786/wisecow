

# Wisecow Kubernetes Deployment – Step by Step

1. **Start Minikube and set Docker environment

        minikube start --driver=docker
        eval $(minikube docker-env)


2. **Build Docker image for Wisecow**

        docker build -t yourusername/wisecow:latest .


3. **Login and push Docker image to Docker Hub**


        docker login
        docker push yourusername/wisecow:latest


4. **Create TLS secret for secure communication**


        kubectl delete secret wisecow-tls -n default 2>/dev/null || true
        kubectl create secret tls wisecow-tls \
        --cert=wisecow.crt --key=wisecow.key -n default


5. **Apply Kubernetes manifests**


        kubectl apply -f k8s/deployment.yaml
        kubectl apply -f k8s/service.yaml
        kubectl apply -f k8s/ingress.yaml


6. **Wait for the deployment rollout to complete**


        kubectl rollout status deployment/wisecow -n default


7. **Verify deployed resources**


        kubectl get pods,svc,ingress -n default


8. **Access Wisecow application**

        curl https://wisecow.local --insecure


9. **Run system health monitoring script**


        ./system_health.sh
        tail -n 20 system_health.log


10. **Check application health using Python script**


        python3 app_health_checker.py


11. **cleanup**


        kubectl delete -f k8s/ingress.yaml
        kubectl delete -f k8s/service.yaml
        kubectl delete -f k8s/deployment.yaml
        kubectl delete secret wisecow-tls -n default
        minikube stop


