# Staging Branch Documentation

This branch (`githubactions-staging`) is dedicated to the **Staging Environment**. It contains a GitHub Actions workflow that automatically builds, tests, and deploys the application whenever code is pushed to this branch.

## Workflow Overview

**File**: [.github/workflows/staging-pipeline.yml](https://github.com/vikramhemchandar/CICD-Pipeline-Assignments/blob/882cdaab2276b098a1e5f292104ad867e78dd4f0/.github/workflows/staging-pipeline.yml)  
**Trigger**: Push to `githubactions-staging` branch.

### Required GitHub Secrets
The following secrets must be configured in the repository settings (**Settings** > **Secrets and variables** > **Actions**) for the pipeline to function:
| Secret Name | Description |
| :--- | :--- |
| `DOCKER_USERNAME` | Docker Hub username for pushing/pulling images. |
| `DOCKER_PASSWORD` | Docker Hub password or access token. |
| `EC2_HOST` | Public IP address or DNS of the Staging EC2 instance. |
| `EC2_USERNAME` | SSH username for the EC2 instance (e.g., `ubuntu`). |
| `EC2_SSH_KEY` | Private SSH key (`.pem` content) for authentication. |

---

### Execution Steps

The pipeline consists of two main jobs: `build` and `deploy`.

### 1. Build Job

This job runs on an `ubuntu-latest` runner and handles the continuous integration tasks.

#### Step 1.1: Checkout Code
The workflow uses `actions/checkout@v4` to clone the repository code into the runner.

<kbd><img width="1141" height="407" alt="image" src="https://github.com/user-attachments/assets/6e6709dc-fda5-43c4-9798-3dfe07a498a6" /></kbd>


#### Step 1.2: Build Docker Image (Test)
It builds a temporary Docker image tagged `flask-app:test` to run unit tests.
```bash
docker build -t flask-app:test .
```

<kbd><img width="1149" height="656" alt="image" src="https://github.com/user-attachments/assets/8fbcff64-a991-4db6-81ff-22e26b73eee3" /></kbd>


#### Step 1.3: Run Tests
The pipeline runs `pytest` inside the Docker container to ensure the application logic is correct before deploying.
```bash
docker run --rm flask-app:test pytest
```
*If tests fail, the pipeline stops here.* <br>

<kbd><img width="1141" height="250" alt="image" src="https://github.com/user-attachments/assets/93fb4322-0451-4341-95c6-8bce5643d859" /></kbd>

#### Step 1.4: Login to Docker Hub
It logs in to Docker Hub using the secrets `DOCKER_USERNAME` and `DOCKER_PASSWORD`.<br>
<kbd><img width="1145" height="126" alt="image" src="https://github.com/user-attachments/assets/f627a0a7-ad4a-4f07-a58c-b88e1e8e61a3" /></kbd>

#### Step 1.5: Build and Push (Staging Image)
After tests pass, it builds the final image and pushes it to Docker Hub with the `:staging` tag.
```bash
docker push <username>/flask-app:staging
```
<kbd><img width="1137" height="548" alt="image" src="https://github.com/user-attachments/assets/9fe07668-992c-4e8c-9cd8-84d77168fcaf" /></kbd>

---

### 2. Deploy Job

This job runs only after the `build` job completes successfully.

#### Step 2.1: Deploy to EC2
The workflow uses `appleboy/ssh-action` to SSH into the Staging EC2 instance and execute the deployment script.

**Script Execution:**
1.  **Pull Image**: Pulls the latest `:staging` image from Docker Hub.
    ```bash
    docker pull <username>/flask-app:staging
    ```
2.  **Stop Container**: Stops the running `flask-app` container (if any).
    ```bash
    docker stop flask-app || true
    docker rm flask-app || true
    ```
3.  **Run Container**: Starts the new version of the application.
    ```bash
    docker run -d --name flask-app -p 5000:5000 <username>/flask-app:staging
    ```
<kbd><img width="2264" height="3319" alt="image" src="https://github.com/user-attachments/assets/b6bf3fc2-8389-46de-84fb-73204c5bdda8" /></kbd>


---

## Configuration Verification

To verify the deployment:
1.  Go to your EC2 instance IP address: `http://<EC2_PUBLIC_IP>:5000`
2.  You should see the updated application.<br>

<kbd><img width="457" height="165" alt="image" src="https://github.com/user-attachments/assets/34de0475-c001-4033-b330-0f3f759207cb" /></kbd><br>
<kbd><img width="461" height="156" alt="image" src="https://github.com/user-attachments/assets/aae149c5-40fd-4b7d-bd1e-935f188df6e4" /></kbd>

