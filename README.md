# Task 5: Kubernetes with Minikube

## 🧩 Objective
Deploy and manage a simple app inside a local Kubernetes cluster using Minikube.

## 🛠 Tools
- Minikube
- kubectl
- Docker

## 📦 Steps
1. Start Minikube: `minikube start`
2. Deploy app: `kubectl apply -f deployment.yaml`
3. Expose it: `kubectl apply -f service.yaml`
4. Verify Pods: `kubectl get pods`
5. Access app: `minikube service demo-service`
6. Scale it: `kubectl scale deployment demo-app --replicas=4`
