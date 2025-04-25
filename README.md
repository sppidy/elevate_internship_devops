# GitOps Workflow using ArgoCD on Kubernetes

This document walks you through the hands-on journey I took to set up a robust, secure Kubernetes environment, powered by Tailscale for seamless networking, automated with Ansible, and driven by a GitOps workflow using ArgoCD.

---

## Introduction

Welcome! I'm a computer science enthusiast who wanted a streamlined, secure Kubernetes environment with Tailscale VPN, automated provisioning via Ansible, and continuous delivery through ArgoCD.

## Objective

- Architect a **Tailscale**\-backed mesh VPN across three nodes.
- Automate **K3s** installation on master and workers with **Ansible**.
- Deploy and expose **ArgoCD** for continuous, Git-driven deployments.
- Create a **GitOps** pipeline that auto-syncs Kubernetes manifests from GitHub.

## My Environment

- **Control Workstation**: Ubuntu 24.04
- **Nodes**:
    - **Master**: `ghostpxe-k8` (Ubuntu 24.04)
    - **Worker1**: `debian` (Debian 12 Bookworm)
    - **Worker2**: `debian1` (Debian 12 Bookworm)
- **Networking**: All nodes connected via **Tailscale** (`tailscale0` interface)

## Prerequisites

- SSH access to each node.
- Tailscale auth key (`tskey-XXXXX`).
- Ansible installed locally.
- `kubectl` CLI configured.
- Docker on all nodes (for container runtime).
- GitHub account and a repository for Kubernetes manifests.

## Tools & Technologies

- **Tailscale**: Lightweight mesh VPN.
- **Ansible**: Infrastructure-as-code automation.
- **K3s**: Kubernetes distribution for resource efficiency.
- **kubectl**: Kubernetes command-line tool.
- **ArgoCD**: Declarative GitOps continuous delivery.
- **GitHub**: Version control for manifests.
- **Docker**: Container image building.

## Cluster & VPN Setup

### Tailscale Mesh VPN

To simplify networking and bypass complex CIDR setups, I used Tailscale:

```bash
# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh
# Connect to tailnet
sudo tailscale up --authkey tskey-XXXXX --hostname $(hostname) --ssh
```

I applied a permissive ACL (`acl.json`) to allow all traffic between nodes and SSH also i am the only one using this VPN though it is not a good practice, this can be done in a Isolated VPN :

```json
{
  "acls": [{"action":"accept","src":["*"],"dst":["*:*"]}],
  "autoApprovers": {"routes":{"10.42.0.0/16":["me@domain.com"]}},
  "ssh": [{"action":"accept","src":["autogroup:member"],"dst":["autogroup:self"],"users":["autogroup:nonroot","root","spidy"]}],
  "nodeAttrs": [{"target":["autogroup:member"],"attr":["funnel"]}]
}
```

This gave me automatically routable, secure IPs (`100.x.x.x`) for each node.

### Ansible Inventory & Variables

I defined my nodes in `inventory.ini` and shared variables in `group_vars/all.yml`:

**inventory.ini**

```ini
[master]
master1 ansible_host=100.x.x.x
[workers]
debian ansible_host=100.x.x.x
debian1 ansible_host=100.x.x.x
[all:vars]
ansible_user=root
```

**group_vars/all.yml**

```yaml
tailscale_auth_key: "tskey-XXXXX"
k3s_version: "v1.30.2+k3s1"
```

### Automated K3s Provisioning

Using Ansible, I set up the master and workers. Key points:

- Disabled default Flannel & Traefik plugins.
- Bound K3s to `tailscale0` for pod networking.
- Used Docker as the container runtime.

**install-k3s.yml**

```yaml
- hosts: all
  become: true
  tasks:
    - name: Ensure Tailscale is running
      shell: |
        curl -fsSL https://tailscale.com/install.sh | sh
        tailscale up --authkey={{ tailscale_auth_key }} --ssh

- hosts: master
  become: true
  tasks:
    - name: Install K3s server
      shell: |
        curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION={{ k3s_version }} \
          sh -s - server \
          --disable-network-policy --disable=flannel --disable=traefik \
          --flannel-iface tailscale0 --docker
    - name: Retrieve join token
      command: cat /var/lib/rancher/k3s/server/node-token
      register: k3s_token
    - set_fact:
        node_token: "{{ k3s_token.stdout }}"

- hosts: workers
  become: true
  tasks:
    - name: Join K3s as agent
      shell: |
        curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION={{ k3s_version }} \
          K3S_URL=https://{{ hostvars['master1']['ansible_host'] }}:6443 \
          K3S_TOKEN={{ hostvars['master1']['node_token'] }} \
          sh -s - agent --flannel-iface tailscale0 --docker
```

Run the playbook:

```bash
ansible-playbook -i inventory.ini install-k3s.yml
```

Everything came up clean: master and workers joined with `tailscale0` IPs.

## Local Access Configuration

### Retrieve & Configure kubeconfig

Once the master was live, I copied its kubeconfig locally and updated the server address:

```bash
scp ubuntu@100.x.x.x:/etc/rancher/k3s/k3s.yaml ~/.kube/k3s-config.yaml
sed -i 's/127.0.0.1/100.x.x.x/' ~/.kube/k3s-config.yaml
export KUBECONFIG=~/.kube/k3s-config.yaml
```

### Context Management

I checked and switched contexts for my cluster:

```bash
kubectl config get-contexts
kubectl config use-context default
```

This ensured `kubectl` commands targeted my new Tailscale-backed cluster.

## ArgoCD Installation & Exposure

### Deploy ArgoCD

I deployed ArgoCD into its own namespace:

```bash
kubectl create namespace argocd
kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### Expose ArgoCD Server

Since I wasn't on a cloud LoadBalancer, I patched the service to `NodePort`:

```bash
kubectl patch svc argocd-server -n argocd \
  -p '{"spec":{"type":"NodePort"}}'
# NodePort: 80→30189, 443→31388
```

I accessed the UI at `http://100.x.x.x:30189`.

### Retrieve Admin Credentials

The default admin password was in a Kubernetes secret:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath='{.data.password}' | base64 -d; echo
```

Username: `admin`.

## GitOps Application Manifests

### Deployment (`deployment.yaml`)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.21.6
        ports:
        - containerPort: 80
```

### Service (`service.yaml`)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP
```

### ArgoCD Application (`argocd-app.yaml`)

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: nginx-app
  namespace: argocd
spec:
  source:
    repoURL: https://github.com/yourusername/gitops-argo
    targetRevision: main
    path: manifests
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

Deploy it:

```bash
kubectl apply -f manifests/argocd-app.yaml
```

## Automated Sync & Updates

Whenever I update `deployment.yaml` (bump the image tag), I simply commit & push:

```bash
git commit -am "chore: bump nginx to 1.21.7" && git push
```

ArgoCD picks up the change and self-heals my cluster to the desired state.

## Deliverables

- **GitHub Repo:** https://github.com/sppidy/elevate_internship_devops/tree/final_project
- **Directories:**
    - `/manifests` – Kubernetes YAMLs
    - `/ansible` – Ansible playbooks

## Screenshots & Video

- **Screenshot:** `images/argocd-sync.png` (Shows sync status in ArgoCD)
- **Vid**`4` (Walkthrough of GitOps workflow)**eo:** `videos/gitops-flow.mp`

## Appendix

All code snippets and YAML manifests are embedded above. For more in-depth reference, see the [ArgoCD docs](https://argo-cd.readthedocs.io/).
