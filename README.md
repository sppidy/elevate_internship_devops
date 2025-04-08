# Jenkins + Docker Socket Setup (No Docker-in-Docker)

This setup runs Jenkins in a Docker container and allows Jenkins to build and run Docker containers by sharing the Docker host socket (`/var/run/docker.sock`).

## 🛠️ Directory Structure
```
.
├── docker-compose.yml
├── jenkins-data/              # Jenkins home data
├── jenkins-docker-certs/      # (Optional) certs directory if used earlier
└── Jenkinsfile                # Jenkins pipeline definition
```

## 📦 `docker-compose.yml`
```yaml
services:
  jenkins:
    image: jenkins/jenkins:lts
    container_name: jenkins
    user: root
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - ./jenkins-data:/var/jenkins_home
      - ./jenkins-docker-certs:/certs/client  # Optional, harmless to leave
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - jenkins

networks:
  jenkins:
    driver: bridge
```

## 🧪 Jenkinsfile
```groovy
pipeline {
    agent any

    environment {
        IMAGE_NAME = "ghostpxe-docker:5000/spidy-elevatelabs-task2"
        IMAGE_TAG = "latest"
        CONTAINER_NAME = "spidy-elevatelabs-task2-app"
    }

    stages {
        stage('Clone Repo') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG .'
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                docker stop $CONTAINER_NAME || true
                docker rm $CONTAINER_NAME || true
                docker run -d --name $CONTAINER_NAME -p 10101:10101 $IMAGE_NAME:$IMAGE_TAG
                '''
            }
        }
    }

    post {
        success {
            echo '✨ Jenkins pipeline finished successfully.'
        }
        failure {
            echo '❌ Pipeline failed. Check logs for details.'
        }
    }
}
```

## 🌐 Access
- Jenkins Dashboard → http://localhost:8080
- App Served on → http://localhost:10101

## 🧠 Notes
- No Docker-in-Docker (DinD) — just host socket sharing via `/var/run/docker.sock`
- This gives full Docker access inside Jenkins container
- Easier networking and less resource-intensive than DinD

## ⚠️ Troubleshooting
- **Port already in use** → Make sure no other service is using `10101`
- **Permission denied** → Add `jenkins` user to `docker` group on host or run as `root`

## ✅ Benefits of This Approach
- Lighter setup, better performance
- Full access to host Docker from Jenkins
- Simpler networking — no extra bridges or host mode

---
