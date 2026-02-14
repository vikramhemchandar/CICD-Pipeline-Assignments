# Production Branch Documentation

This branch (`githubactions_production`) is dedicated to the **Production Environment**. It contains a GitHub Actions workflow that automates the deployment process when a new **Release** is created.

## Workflow Overview

**File**: `.github/workflows/production-pipeline.yml`  
**Trigger**: **Release Created** (The pipeline runs only when you create a new release in GitHub).

### Required GitHub Secrets

The following secrets must be configured in the repository settings (**Settings** > **Secrets and variables** > **Actions**) for the pipeline to function:

| Secret Name | Description |
| :--- | :--- |
| `DOCKER_USERNAME` | Docker Hub username for pushing/pulling images. |
| `DOCKER_PASSWORD` | Docker Hub password or access token. |
| `EC2_HOST` | Public IP address or DNS of the Production EC2 instance. |
| `EC2_USERNAME` | SSH username for the EC2 instance (e.g., `ubuntu`). |
| `EC2_SSH_KEY` | Private SSH key (`.pem` content) for authentication. |

---

### Execution Steps

The pipeline consists of two main jobs: `build` and `deploy`.

### 1. Build Job

This job runs on an `ubuntu-latest` runner and handles building and pushing the Docker image.<br>

<kbd><img width="1500" height="696" alt="image" src="https://github.com/user-attachments/assets/e3f76595-0c84-4e02-9b51-874219d6b011" /></kbd><br>


#### Step 1.1: Checkout Code
The workflow uses `actions/checkout@v4` to clone the repository code into the runner.<br>
<kbd><img width="1140" height="408" alt="image" src="https://github.com/user-attachments/assets/c03180cd-1be4-4929-8e6c-25fd89e26dfb" /></kbd>

#### Step 1.2: Build Docker Image
It builds the Docker image using the release tag (e.g., `v1.0.0`) as the tag.
```bash
docker build -t flask-app:<release_tag> .
```
<kbd><img width="1141" height="658" alt="image" src="https://github.com/user-attachments/assets/fc1449fc-fe60-4ce5-8fb6-0095651fff71" /></kbd>

#### Step 1.3: Run Tests
The pipeline runs `pytest` inside the Docker container to ensure the application logic is correct before pushing.
```bash
docker run --rm flask-app:<release_tag> pytest
```
<kbd><img width="1136" height="250" alt="image" src="https://github.com/user-attachments/assets/69ec427d-1689-4e1d-a77b-a878ac072369" /></kbd>

#### Step 1.4: Login to Docker Hub
It logs in to Docker Hub using the secrets `DOCKER_USERNAME` and `DOCKER_PASSWORD`.

<kbd><img width="1144" height="126" alt="image" src="https://github.com/user-attachments/assets/5c4d3cda-f843-424d-920d-f824484d3f34" /></kbd>

#### Step 1.5: Push to Docker Hub
It pushes the Docker image to Docker Hub with **two tags**:
1.  `:latest` (for general usage)
2.  `:<release_tag>` (e.g., `:v1.0.0` for version tracking)

```bash
docker push <username>/flask-app:latest
docker push <username>/flask-app:<release_tag>
```
<kbd><img width="1135" height="1736" alt="image" src="https://github.com/user-attachments/assets/3279e69a-536f-45f7-bb9a-f5495c302322" /></kbd>
---

### 2. Deploy Job

This job runs only after the `build` job completes successfully.

#### Step 2.1: Deploy to EC2
The workflow uses `appleboy/ssh-action` to SSH into the Production EC2 instance and execute the deployment script.

**Script Execution:**
1.  **Pull Image**: Pulls the specific release image from Docker Hub.
    ```bash
    docker pull <username>/flask-app:<release_tag>
    ```
2.  **Stop Container**: Stops the running `flask-app` container (if any).
    ```bash
    docker stop flask-app || true
    docker rm flask-app || true
    ```
3.  **Run Container**: Starts the application using the release tag.
    ```bash
    docker run -d --name flask-app -p 5000:5000 <username>/flask-app:<release_tag>
    ```
<kbd><img width="2262" height="5847" alt="image" src="https://github.com/user-attachments/assets/70ac92ef-7c2b-44bd-aa00-1b18f2aca78f" /></kbd>

---

## Configuration Verification

To verify the deployment:
1.  Go to your Production EC2 instance IP address: `http://<PROD_EC2_IP>:5000`
2.  You should see the deployed application version. <br>
<kbd><img width="457" height="165" alt="image" src="https://github.com/user-attachments/assets/02baad7d-fa95-4f1d-973d-5116c35a161e" /></kbd><br>
<kbd><img width="461" height="156" alt="image" src="https://github.com/user-attachments/assets/517596fc-8689-43ff-9450-5393f69c3bb9" /></kbd>


