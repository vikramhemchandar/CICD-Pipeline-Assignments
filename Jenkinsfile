pipeline {
    agent any

    environment {
        VENV = 'venv'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/<YOUR_USERNAME>/flasky.git'
            }
        }

        stage('Build') {
            steps {
                sh '''
                python3 -m venv $VENV
                . $VENV/bin/activate
                pip install --upgrade pip
                pip install -r requirements.txt
                '''
            }
        }

        stage('Test') {
            steps {
                sh '''
                . $VENV/bin/activate
                pytest
                '''
            }
        }

        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                sh '''
                echo "Deploying to staging..."
                # Example deployment
                # Could be systemd, docker, or simple copy
                '''
            }
        }
    }

    post {
        success {
            mail to: 'you@example.com',
                 subject: 'Jenkins Build SUCCESS',
                 body: "Build ${env.BUILD_NUMBER} succeeded."
        }

        failure {
            mail to: 'you@example.com',
                 subject: 'Jenkins Build FAILED',
                 body: "Build ${env.BUILD_NUMBER} failed. Check Jenkins."
        }
    }
}
