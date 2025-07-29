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

        stage('Test Docker Image') {
            steps {
                sh 'docker run --rm -d -p 3000:3000 --name test-container ${IMAGE_NAME}:${IMAGE_TAG}'
                sh 'sleep 5'
                sh 'curl -f http://localhost:3000 || exit 1'
                sh 'docker stop test-container'
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
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
                    sh '''
                        ssh -o StrictHostKeyChecking=no ubuntu@34.229.247.123 << EOF
                        kubectl set image deployment/cw2-deployment cw2-container=${IMAGE_NAME}:${IMAGE_TAG} --record
                        kubectl rollout status deployment/cw2-deployment
                        EOF
                    '''
                }
            }
        }
    }
}
