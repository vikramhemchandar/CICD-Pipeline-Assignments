# Jenkins Pipeline Documentation

This branch (`jenkins`) contains a Jenkins Pipeline configuration ([Jenkinsfile](cci:7://file:///Users/vikramhemchandar/RichyRocks/Code/HeroViredAssignments/CI:CD%20Assignment/Jenkins/CICD-Pipeline-Assignments/Jenkinsfile:0:0-0:0)) to automate the Build, Test, and Deployment of the Flask application.

## Prerequisites & Installation

Before running the pipeline, ensure the Jenkins server and the agent (if different) have the necessary tools installed.

### 1. Install Java (Jenkins Requirement)
Jenkins runs on Java. Install OpenJDK:
```bash
sudo apt update
sudo apt install openjdk-17-jre
java -version
```
**Output:**
> openjdk version "17.0.x" 202x-xx-xx  
> OpenJDK Runtime Environment ...

<img width="468" height="254" alt="image" src="https://github.com/user-attachments/assets/82e9cd6f-e7d4-4653-a0a1-3302ac3befa6" /><br>
<img width="468" height="49" alt="image" src="https://github.com/user-attachments/assets/80054d11-8c89-4404-ae9a-f4c47af2cb1b" /><Br>

### 2. Install Jenkins
Follow the official steps to install Jenkins on your server (e.g., Ubuntu/EC2):
```bash
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install jenkins
```
Once Jenkins installed, execute the below commands
```bash
sudo apt-get install jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
```
<kbd><img width="2956" height="1778" alt="image" src="https://github.com/user-attachments/assets/f3187f78-aa54-4aad-8b27-792476605599" /></kbd><br>
<kbd><img width="2982" height="1316" alt="image" src="https://github.com/user-attachments/assets/d1a03ea1-3728-42b3-beca-e216869afad0" /></kbd><br>
<kbd><img width="938" height="993" alt="image" src="https://github.com/user-attachments/assets/99e54a5d-be8d-40ea-827d-774d6d46baf1" /></kbd><br>
<kbd><img width="987" height="882" alt="image" src="https://github.com/user-attachments/assets/13c9ad49-8762-4b0e-bfcc-83735677983e" /></kbd><br>
<kbd><img width="987" height="880" alt="image" src="https://github.com/user-attachments/assets/9387e2fb-df27-41f0-af41-6cd88060a7f3" /></kbd><br>

### 3. Install Python 3 & venv
The pipeline uses Python 3 'virtual environments' to isolate dependencies.
```bash
sudo apt install python3 python3-pip python3-venv
python3 --version
```
**Output:**
> Python 3.x.x

### 4. Install Jenkins Plugins (to send email)
Go to **Manage Jenkins** > **Plugins** and ensure the following are installed:
- **Pipeline**: Core plugin for Jenkinsfile support.
- **Git**: To checkout the repository.
- **Email Extension Plugin**: To send email notifications (used in the `post` section).
  - Configure Gmail Account with the below steps -
      -  SMTP Server: smtp.gmail.com
      -  Port: 465
      -  Password: To generate Gmail Application password, visit https://myaccount.google.com
      -  The above link generates 16-character password; Copy and paste it in the Jenkins credentials
      -  Follow the below steps to configure Gmail on Jenkins
        
#### Configuration of Email Notification
-  Go to Manage Jenkins -> System -> Email Notifications
<kbd><img width="707" height="585" alt="image" src="https://github.com/user-attachments/assets/c24e7676-c871-4b05-9eac-6886de27fe90" /></kbd>
<kbd><img width="1071" height="1204" alt="image" src="https://github.com/user-attachments/assets/6059b5b8-c687-4cb6-a9ae-a7ed6b146429" /></kbd>
-  Test Email notification
<kbd><img width="947" height="338" alt="image" src="https://github.com/user-attachments/assets/d50ce272-b185-459f-9a36-aa84762b36c5" /></kbd>
-  Configure Extend email notification
<kbd><img width="707" height="585" alt="image" src="https://github.com/user-attachments/assets/23a32e26-634e-4aa1-8941-f34237d215c8" />
<img width="1075" height="525" alt="image" src="https://github.com/user-attachments/assets/2ae122a4-d3a5-45b8-a6b0-8ddc2d33b94b" /></kbd>
-  Add the email and password
<kbd><img width="807" height="858" alt="image" src="https://github.com/user-attachments/assets/b5be46c4-63b8-4cab-b7b7-771cd1bf273d" /></kbd>
 
## Pipeline Configuration ([Jenkinsfile])

The pipeline runs on `agent any` and triggers automatically on GitHub pushes.

### Variables & Configuration

| Variable | Location | Description |
| :--- | :--- | :--- |
| `githubPush()` | `triggers {}` | Triggers the build when code is pushed to GitHub. Ensure the **GitHub hook trigger for GITScm polling** is enabled in the Job configuration. |
| `emailext (to: ...)` | `post { success/failure }` | The recipient email address. **Update `vikramhemchandar@gmail.com` to your email.** |
| `from: ...` | `post { success/failure }` | The sender email address. Requires SMTP configuration in Manage Jenkins > System. |

#### githubPush()
```
    triggers {
        githubPush()
    }
```

#### Email - post {success / failure}
```
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
    
    always {
        echo 'Pipeline execution completed.'
    }
```

### Pipeline Stages

#### 1. Build
Sets up a Python virtual environment and installs dependencies from `Requirements.txt`.
```groovy
python3 -m venv venv
. venv/bin/activate
pip install -r Requirements.txt
```
- `Flask`
- `pytest`
- `pytest-flask`

<kbd><img width="1205" height="801" alt="image" src="https://github.com/user-attachments/assets/70c76d60-ea3a-4e1a-b8c5-bad5b29cf62d" /></kbd>


#### 2. Test
Runs the unit tests using `pytest`.
```groovy
. venv/bin/activate
pytest
```
**Output:** <br>
<kbd><img width="754" height="224" alt="image" src="https://github.com/user-attachments/assets/884588f0-d4d9-4611-bb08-29b6fb59b6d7" /></kbd>

#### 3. Deploy
Starts the Flask application in the background and verifies it with `curl`.
```groovy
python3 app.py &
sleep 5
curl http://localhost:5000/
```
**Output:**
> Serving Flask app 'app'  
> Running on http://127.0.0.1:5000  
> Hello, World! (or your app's response)

<kbd><img width="1140" height="470" alt="image" src="https://github.com/user-attachments/assets/64914c53-621d-486b-96b5-854b2091bea2" /></kbd>

#### 4. Post-Build Actions
- **Success**: Sends a "Build Successful" email.
<kbd><img width="1143" height="286" alt="image" src="https://github.com/user-attachments/assets/a1ebb4b4-d1f1-452b-9c65-48aa8ee79c75" /></kbd>
<kbd><img width="1177" height="498" alt="image" src="https://github.com/user-attachments/assets/a399afb9-858e-478d-aadf-66402959a9bf" /></kbd>
- **Failure**: Sends a "Build Failed" email
<kbd><img width="1136" height="314" alt="image" src="https://github.com/user-attachments/assets/8fdb38e5-2ae6-4837-a05f-86cdf33e76d2" /></kbd>
<kbd><img width="1182" height="571" alt="image" src="https://github.com/user-attachments/assets/89e4c96c-2ae7-4b7b-8006-b44a5644aaad" /></kbd>
