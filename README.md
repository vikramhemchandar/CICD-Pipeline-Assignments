#CI/CD Pipeline Implementation for Jenkins & GitHub Action
This repository contains the CI/CD pipeline implementations for a simple Flask application. The pipelines are separated into different branches, each serving a specific purpose.
## Branch Overview
| Branch Name | Description | Goal |
| :--- | :--- | :--- |
| **[jenkins](https://github.com/vikramhemchandar/CICD-Pipeline-Assignments/tree/jenkins)** | Contains the Jenkins Pipeline configuration (`Jenkinsfile`). | Automate the Build, Test, and Deployment processes using **Jenkins**. It sets up a virtual environment, installs dependencies, runs tests, and deploys the app locally. |
| **[githubactions-staging](https://github.com/vikramhemchandar/CICD-Pipeline-Assignments/tree/githubactions-staging)** | Contains the GitHub Actions workflow for the Staging environment. | Automate the Continuous Integration and Deployment to the **Staging** environment. Triggered on every push, it builds the Docker image, runs tests, and deploys to the Staging EC2 instance. |
| **[githubactions_production](https://github.com/vikramhemchandar/CICD-Pipeline-Assignments/tree/githubactions_production)** | Contains the GitHub Actions workflow for the Production environment. | Automate the Release and Deployment to the **Production** environment. Triggered when a **Release** is created, it builds and pushes the release image to Docker Hub and deploys it to the Production EC2 instance. |
