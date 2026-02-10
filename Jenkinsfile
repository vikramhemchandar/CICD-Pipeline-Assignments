pipeline {
    agent any

    triggers {
        githubPush()
    }

    stages {
        stage('Build') {
            steps {
                echo 'Setting up virtual environment and installing dependencies...'
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install -r Requirements.txt
                '''
            }
        }

        stage('Test') {
            steps {
                echo 'Running Unit Tests...'
                sh '''
                    . venv/bin/activate
                    pytest
                '''
            }
        }

        stage('Debug Branch') {
            steps {
                echo "BRANCH_NAME = ${env.BRANCH_NAME}"
                sh 'git branch --show-current || true'
            }
        }

        stage('Deploy') {
            when {
                expression {
                    sh(
                        script: 'git rev-parse --abbrev-ref HEAD',
                        returnStdout: true
                    ).trim() == 'jenkins'
                }
            }
            steps {
                echo 'Deploying to Staging Environment...'
                sh 'curl http://localhost:5000/'
            }
        }
    }

    // post {
    //     success {.  
    //         emailext (
    //             subject: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
    //             body: "Check console output at ${env.BUILD_URL}",
    //             to: "your-email@example.com"
    //         )
    //     }
    //     failure {
    //         emailext (
    //             subject: "FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
    //             body: "Build failed. Check console output at ${env.BUILD_URL}",
    //             to: "your-email@example.com"
    //         )
    //     }
    // }
}