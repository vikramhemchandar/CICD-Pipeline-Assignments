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

    post {
        success {
            emailext (
                subject: "✅ SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: """
                    <html>
                    <body>
                        <h2 style="color: green;">Build Successful! ✅</h2>
                        <p><strong>Job Name:</strong> ${env.JOB_NAME}</p>
                        <p><strong>Build Number:</strong> ${env.BUILD_NUMBER}</p>
                        <p><strong>Build Status:</strong> SUCCESS</p>
                        <p><strong>Console Output:</strong> <a href="${env.BUILD_URL}console">${env.BUILD_URL}console</a></p>
                        <p><strong>Build URL:</strong> <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
                    </body>
                    </html>
                """,
                to: 'vikramhemchandar@gmail.com',
                from: 'vikramhemchandar@gmail.com',
                replyTo: 'vikramhemchandar@gmail.com',
                mimeType: 'text/html'
            )
        }
        
        failure {
            emailext (
                subject: "❌ FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: """
                    <html>
                    <body>
                        <h2 style="color: red;">Build Failed! ❌</h2>
                        <p><strong>Job Name:</strong> ${env.JOB_NAME}</p>
                        <p><strong>Build Number:</strong> ${env.BUILD_NUMBER}</p>
                        <p><strong>Build Status:</strong> FAILURE</p>
                        <p><strong>Console Output:</strong> <a href="${env.BUILD_URL}console">${env.BUILD_URL}console</a></p>
                        <p><strong>Build URL:</strong> <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
                        <p>Please check the console output for error details.</p>
                    </body>
                    </html>
                """,
                to: 'vikramhemchandar@gmail.com',
                from: 'vikramhemchandar@gmail.com',
                replyTo: 'vikramhemchandar@gmail.com',
                mimeType: 'text/html'
            )
        }
    }

always {
        echo 'Pipeline execution completed.'
    }
}