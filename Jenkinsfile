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
                    pip3 install flask
                '''
            }
        }

        stage('Python Debug') {
            steps {
                echo 'Python Debug with versions'
                sh '''
                    which python || true
                    which python3 || true
                    python --version || true
                    python3 --version || true
                    pip --version || true
                    pip3 --version || true
                    flask --version || true
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
            steps {
                echo 'Deploying to Staging Environment...'
                sh '''
                python3 app.py &
                sleep 5 
                curl http://localhost:5000/
                '''
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