pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', credentialsId: 'github-creds', url: 'https://github.com/cmacla301/cw2-pipeline.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("cmacla301/cw2-server:1.0")
                }
            }
        }

         stage('Push Docker Image') {
            steps {
                echo 'Skipping Docker Hub push for now'
                // script {
                //     docker.withRegistry('', DOCKERHUB_CREDENTIALS) {
                //         dockerImage.push()
                //     }
                // }
            }
        }


stage('Deploy to Kubernetes') {
    steps {
        sshagent (credentials: ['prod-ssh']) {
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@34.229.247.123 "kubectl set image deployment/cw2-deployment cw2-container=cmacla301/cw2-server:1.0"'
        }
    }
}

