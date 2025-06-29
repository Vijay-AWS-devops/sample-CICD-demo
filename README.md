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
- 🔨 `AWSCodeBuildAdminAccess`: Create and manage CodeBuild projects.  
- 🚚 `AWSCodeDeployFullAccess`: Manage CodeDeploy applications and deployments.  
- 🛡️ `IAMFullAccess` (Use cautiously, for project purposes only).
- 🔐 `SecretsManagerReadWrite`:This allows you to store and rotate your secret keys for GitHub.

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
   - 🔨 `AWSCodeBuildAdminAccess`  
   - 🚚 `AWSCodeDeployFullAccess`  
   - 🛡️ `IAMFullAccess` *(optional, adjust based on security needs)*
   - 🔐 `SecretsManagerReadWrite`

   ![image](https://github.com/user-attachments/assets/3500c05e-d072-4d7b-af18-f72be9824afd)


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

![image](https://github.com/user-attachments/assets/d688d5b3-9447-4542-8bb2-2cfd30fc1f72)
---

## Step 4: Configure AWS CodeBuild

To begin configuring AWS CodeBuild, follow the steps below:

### 1. Create a Build Project

1. Log in to the [AWS Management Console](https://console.aws.amazon.com/).
2. Navigate to **CodeBuild** under the *Developer Tools* section.
3. Click on **Create build project**.

   - Give your project a name (e.g., `sample_python_demo`).
   - Select the **project type** as *Default*.

---

### 2. Set Source Repository

- Choose **Source provider** as **GitHub**.
- If prompted with “You have not connected to GitHub,” click **Manage account credentials**.

![image](https://github.com/user-attachments/assets/960883f4-505f-4cfd-ba77-53e9ea33ed30)


#### Connect to GitHub via OAuth

1. In the popup window:
   - Select **Credential type** as **OAuth app**.
   - Choose **Service** as **Secrets Manager**.
   - Select **Secrets** as **New Secret** and click **Connect to GitHub**.

![image](https://github.com/user-attachments/assets/10c04d97-552c-403a-9b1d-5aab83c09c8c)


2. A new window will appear asking you to sign in to GitHub:
   - Enter your **GitHub username and password**.
   - Click **Sign in**.
   - You’ll see a screen titled “Processing OAuth Request.”
  
![image](https://github.com/user-attachments/assets/b91958b2-98e4-46bb-9124-164e47e1ef54)


3. Complete the connection by entering:
   - A **Secret Key Name**.
   - A brief **Description**.
   - Click **Confirm**.

#### Provide Repository URL

After connecting, return to the CodeBuild setup and enter your GitHub repository URL in the following format:

```
https://github.com/<your-github-username>/<your-repository-name>
```

---

### 3. Configure Build Environment

In the **Environment** section:

- **Provisioning model:** On Demand
- **Environment image:** Managed Image
- **Compute:** EC2
- **Running mode:** Container
- **Operating system:** Ubuntu
- **Runtime(s):** Standard
- **Image:** `aws/codebuild/standard:7.0` *(always choose the latest version available)*

---

### 4. IAM Role Configuration

- Under the **Role** section, you can either:
  - Choose **New service role** — this allows CodeBuild to create and manage the role automatically.
  - Or select an existing IAM role with appropriate permissions.

For simplicity during this demo, select **New service role**.

![image](https://github.com/user-attachments/assets/4645bba6-611b-409a-92ce-99f293e07763)

---

### 5. Additional Configuration

Under **Additional configuration**:

- Enable the **Privileged flag** if you plan to:
  - Build Docker images.
  - Require elevated privileges during the build process.

---

### 6. BuildSpec Configuration

The **BuildSpec** defines how your code is built. You have two options:

- **Insert build commands manually**  
  Choose this option to define your build commands directly in the editor.

- **Use a buildspec file from GitHub**  
  This is recommended for more complex projects. Place a `buildspec.yml` file at the root of your repository.

If you choose to insert build commands manually, switch to the editor and input your commands accordingly.

![image](https://github.com/user-attachments/assets/55f5fad9-484a-4f43-b8ce-e6e6ab37dab1)

---

> ✅ **Tip:** For better maintainability and collaboration, always use a `buildspec.yml` file in your repository. It ensures that your build logic stays version-controlled and consistent across environments.

---
