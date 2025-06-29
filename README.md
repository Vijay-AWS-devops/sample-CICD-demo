# 🚀 Simple Flask Python App Deployment with AWS CI/CD

This project demonstrates a seamless CI/CD pipeline for deploying a simple Flask Python application using AWS services: **AWS CodeBuild**, **AWS CodePipeline**, and **AWS CodeDeploy**. The pipeline automates building, testing, and deploying the Flask app to an AWS environment.

---

## 🧭 Project Overview

🎯 **Objective**: Automate deployment of a Flask app using AWS CI/CD services.

---

## 🛠️ Services Used

🔧 **AWS CodeBuild**: Builds and tests the Flask app.  
🔄 **AWS CodePipeline**: Orchestrates the CI/CD workflow.  
📦 **AWS CodeDeploy**: Deploys the app to an EC2 instance or other compute services.  
🐋 **Docker**: Containerizes the Flask app for consistent deployment.  
📁 **Amazon S3**: Stores build artifacts.

---

## 📁 Repository Structure

📄 `app.py`: Main Flask application.  
📄 `Dockerfile`: Defines the Docker container for the Flask app.  
📄 `buildspec.yml`: Configuration for CodeBuild.  
📄 `appspec.yml`: Configuration for CodeDeploy.  
📄 `requirements.txt`: Python dependencies.

---

## ✅ Prerequisites

Before setting up the CI/CD pipeline, ensure the following are in place:

🔐 **AWS Account**: Active account with access to AWS Console.  
👥 **IAM User (Recommended)**: Create an IAM user with the following policies:

- 📁 `AmazonS3FullAccess`: Manage S3 buckets for artifacts.  
- 🔨 `AWSCodeBuildDeveloperAccess`: Create and manage CodeBuild projects.  
- 🚚 `AWSCodeDeployFullAccess`: Manage CodeDeploy applications and deployments.  
- 🛡️ `IAMFullAccess` (Use cautiously, for project purposes only).

🏷️ **IAM Role**: Create a role for AWS services (CodeBuild, CodePipeline, CodeDeploy) to interact with each other or you can allow the service to create on its own.

🐙 **GitHub Repository**: Contains the Flask app code, Dockerfile, buildspec.yml, and appspec.yml.  
🐋 **Docker Hub Account**: Create a Docker Hub account and repository to store the container image.

---

## 🛠️ Setup Instructions

### Step 1: Create IAM User 🧑‍💼

1. Log in to the AWS Console as the root user.  
2. Navigate to **IAM > Users > Create User**.  
3. Enter a username (e.g., `IAM_User_1`).

   ![image](https://github.com/user-attachments/assets/799e66b6-e73f-4cd8-a6b6-823ab7bfc82b)

4. Attach the required policies:

   - 📁 `AmazonS3FullAccess`  
   - 🔨 `AWSCodeBuildDeveloperAccess`  
   - 🚚 `AWSCodeDeployFullAccess`  
   - 🛡️ `IAMFullAccess` *(optional, adjust based on security needs)*

   ![image](https://github.com/user-attachments/assets/90716353-bd3b-490a-bb23-71cd3f1f6862)


6. Download the `.csv` file containing the IAM user’s credentials (username, password, and login URL).  

> 💡 **Tip**: Store credentials securely and avoid committing them to version control.

---

### Step 2: Configure GitHub Repository 🐙

1. Create a GitHub repository (e.g., `sample-python-demo`).  
2. Add the following files:

   - 📄 `app.py`: Flask application code.
   - 📄 `Dockerfile`: Docker configuration for the Flask app.
   - 📄 `buildspec.yml`: CodeBuild configuration.  
   - 📄 `appspec.yml`: CodeDeploy configuration.
   - 📄 `requirements.txt`: List of Python dependencies.
   - 📄 `start_container.sh`: To start the container.
   - 📄 `stop_container.sh`: To stop the container.

---

### Step 3: Set Up Docker Hub 🐳

1. Create a Docker Hub account if you don’t have one.  
2. Create a repository (e.g., `sample-python-app`) to store the Docker image.  
3. Note the repository name (e.g., `yourusername/sample-python-app`).

---
