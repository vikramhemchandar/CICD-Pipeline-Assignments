pipeline {
    agent any

    environment {
        PYTHON_APP = "Flask_App.py"
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
                    pytest tests/
                '''
            }
        }

        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                echo 'Deploying to Staging Environment...'
                // For a Python app, this might be a script to restart a service 
                // or a 'kubectl apply' command for your Kubernetes configs.
                sh './deploy_staging.sh'
            }
        }
    }

    // post {
    //     success {
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