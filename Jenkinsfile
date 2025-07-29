pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'docker build -t cmacla301/cw2-server:latest .'
      }
    }
    stage('Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
          sh 'echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin'
          sh 'docker push cmacla301/cw2-server:latest'
        }
      }
    }
  }
}

