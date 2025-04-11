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

        stage('Push Image to Registry') {
            steps {
                sh 'docker push $IMAGE_NAME:$IMAGE_TAG'
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

