# 🚀 ElevateLabs Task 3 - DevOps Deployment with Terraform

This project showcases the deployment of a Dockerized Node.js application to a remote server using **Terraform** and a **custom local Docker registry**, all orchestrated via a CI/CD pipeline powered by **Jenkins**.

---

## 📆 Tech Stack

- **Node.js** – Web application runtime
- **Docker** – Containerization platform
- **Jenkins** – CI/CD automation
- **Terraform** – Infrastructure as Code (IaC)
- **Local Docker Registry** – `ghostpxe-docker:5000`

---

## 📁 Project Structure

```
🔹 Dockerfile
🔹 .gitignore
🔹 main.tf              # Terraform configuration
🔹 README.md            # Project documentation
🔹 Jenkinsfile          # Jenkins pipeline script
🔹 terraform.tfstate    # Generated Terraform state file
🔹 logs/                # Terraform logs (init, plan, apply, state, destroy)
🔹 src/                 # Node.js source code
```

---

## 🚦 How It Works

### ✅ Jenkins CI/CD Pipeline

1. Clones the repository
2. Builds the Docker image:
   ```
   ghostpxe-docker:5000/spidy-elevatelabs-task2:latest
   ```
3. Pushes the image to the **insecure local registry** (no authentication)

### ✅ Terraform Infrastructure Deployment

1. Connects to the **remote Docker daemon via SSH**
2. Pulls the image from the **local registry**
3. Deploys and manages the container on the remote server

---

## 📜 Terraform Workflow

Execute the following commands from your **local machine**:

```bash
terraform init
terraform plan
terraform apply -auto-approve
terraform state list
terraform destroy
```

---

## Terraform Logs

Available in terraform/logs in the repo

---

## ⚙️ Configuration Requirements

- **Registry Access:** Ensure `ghostpxe-docker:5000` is reachable from the remote server
- **Docker Daemon Config (********`/etc/docker/daemon.json`********)**:
  ```json
  {
    "insecure-registries": ["ghostpxe-docker:5000"]
  }
  ```
- **Remote Access:** Enable SSH access for Terraform to interact with Docker remotely

---

## 🌐 Application Access

Once deployed, access the application at:

```
http://your-server-ip:8181
```

Ensure port **8181** is open in your firewall or security group settings.


