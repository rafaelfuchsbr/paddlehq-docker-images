@Library('paddle-jenkins-library')_

pipeline {
    agent any
    environment {
        DOCKER_ENV = 'ci'
        UNIQUE_BUILD_ID = "${GIT_COMMIT}".substring(0, 7)
        GITHUB_REPOSITORY_NAME = 'docker-images'
        COMPOSE_PROJECT_NAME = ["${GITHUB_REPOSITORY_NAME}", "${UNIQUE_BUILD_ID}"].join('_')
    }
    stages {
        stage('Init') {
            steps {
                script {
                    echo 'Hello'
                }
            }
        }
        stage('Build image') {
            steps {
                script {
                    echo 'Building image'
                    sh 'docker build .'
                }
            }
        }
        stage('Push image') {
            steps {
                script {
                    echo 'Pushing image'
                }
            }
        }
    }
    post {
        success {
            script {
                echo 'Success!!!'
            }
        }
        failure {
            script {
                echo 'Failed!'
            }
        }
        cleanup {
            script {
                //sh('make docker-cleanup')
                cleanWs()
            }
        }
    }
}