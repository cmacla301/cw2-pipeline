pipeline {
    agent any

    environment {
        IMAGE_NAME = "cmacla301/cw2-server"
        IMAGE_TAG = "1.0"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/cmacla301/cw2-pipeline.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sshagent(credentials: ['prod-ssh']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@34.229.247.123 '
                            kubectl set image deployment/cw2-deployment cw2-server=${IMAGE_NAME}:${IMAGE_TAG} --record &&
                            kubectl rollout status deployment/cw2-deployment
                        '
                    """
                }
            }
        }
    }
}
