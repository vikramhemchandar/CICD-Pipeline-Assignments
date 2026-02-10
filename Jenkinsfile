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

        stage('Deploy') {
            // when {
            //     branch '*/jenkins'
            // }
            steps {
                echo 'Deploying to Staging Environment...'
                // For a Python app, this might be a script to restart a service 
                // or a 'kubectl apply' command for your Kubernetes configs.
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