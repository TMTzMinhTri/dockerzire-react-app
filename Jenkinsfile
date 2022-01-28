pipeline {

  agent none

  environment {
    DOCKER_IMAGE = "tmtzminhtri/react-nginx"
  }

  stages {
		stage("Test") {
      steps {
        echo 'Hello World'
      }
    }

    stage("build") {
      // agent { node {label 'master'}}
		  agent any
      environment {
        DOCKER_TAG="${GIT_BRANCH.tokenize('/').pop()}-${BUILD_NUMBER}-${GIT_COMMIT.substring(0,7)}"
      }
      steps {
        withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
            sh 'echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin'
        }

        sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} . "
        sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
        script {
          if (GIT_BRANCH ==~ /.*master.*/) {
            sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
            sh "docker push ${DOCKER_IMAGE}:latest"
          }
        }

        //clean to save disk
        sh "docker image rm ${DOCKER_IMAGE}:${DOCKER_TAG}"
      }
    }
  }

  post {
    success {
      echo "SUCCESSFUL"
    }
    failure {
      echo "FAILED"
    }
  }
}