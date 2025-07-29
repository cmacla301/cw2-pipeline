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
                    def dockerImage = docker.build("cmacla301/cw2-server:1.0")
                    // Store it for pushing
                    env.IMAGE_NAME = "cmacla301/cw2-server:1.0"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        docker.image(env.IMAGE_NAME).push()
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
