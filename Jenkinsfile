pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
    }

    stages {
        stage('Clone Repository') {
            steps {
                git credentialsId: 'github-creds', url: 'https://github.com/cmacla301/cw2-pipeline.git'
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
                script {
                    docker.withRegistry('', DOCKERHUB_CREDENTIALS) {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl set image deployment/cw2-deployment cw2-container=cmacla301/cw2-server:1.0'
            }
        }
    }
}
