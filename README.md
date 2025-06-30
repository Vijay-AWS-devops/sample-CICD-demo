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
- 📋 `AmazonSSMFullAcess`:This allows you to create parameters to store the credentials for Docker.

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

# CodeBuild Configuration

Below is the configuration used for building a Python application using AWS CodeBuild and Docker.

## Build Specification

```yaml
version: 0.2

env:
  parameter-store:
    DOCKER_USERNAME: 
    DOCKER_PASSWORD: 
    DOCKER_URL: 

phases:
  install:
    runtime-versions:
      python: 3.11

  pre_build:
    commands:
      - pip install -r requirements.txt

  build:
    commands:
      - echo "Building Docker image"
      - echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin "$DOCKER_URL"
      - docker build -t "$DOCKER_URL/$DOCKER_USERNAME/sample-python-app:latest" .
      - docker push "$DOCKER_URL/$DOCKER_USERNAME/sample-python-app:latest"

  post_build:
    commands:
      - echo "Build is successful"
```

---

## Setup Instructions

> Note: Parameter values are not included as CodeBuild lacks permission to access the System Manager.

### CodeBuild Role

AWS CodeBuild will either:
- Automatically create a role for you, **or**
- You can create and attach the necessary policies and add an existing IAM role.

After creating the project: (If the Codebuilder creates a Role)

1. Go to **IAM Console > Roles**.
2. Search for the role created by CodeBuild.
3. Attach the following permissions to that role:

- `AmazonS3FullAccess`
- `AmazonSSMFullAccess`

After setting up your IAM role, navigate to **AWS Systems Manager > Parameter Store** and create the following secure parameters:

## Step-by-Step Setup Instructions

### 1. Create Parameters in SSM Parameter Store

![image](https://github.com/user-attachments/assets/9738eced-5a87-4743-956c-565748d6023c)

---

#### 🔐 Docker Username

- **Name**: `/myapp/docker-credentials/username`
- **Tier**: Standard
- **Type**: SecureString
- **KMS Key source**: Leave as default
- **Value**: `<Your_DockerAccount_username>`

Click **Create parameter**.

![image](https://github.com/user-attachments/assets/ecee18ec-a282-4506-85d1-eb398eb0a94d)

---

#### 🔒 Docker Password

- **Name**: `/myapp/docker-credentials/password`
- **Tier**: Standard
- **Type**: SecureString
- **KMS Key source**: Leave as default
- **Value**: `<Your_DockerAccount_password>`

Click **Create parameter**.

---

#### 🌐 Docker Registry URL

- **Name**: `/myapp/docker-registry/url`
- **Tier**: Standard
- **Type**: SecureString
- **KMS Key source**: Leave as default
- **Value**: `docker.io` *(default registry URL for Docker Hub)*

Click **Create parameter**.

![image](https://github.com/user-attachments/assets/c12a7549-1d4e-4df0-b754-2dd04d187fc8)

---

### 2. Update CodeBuild Buildspec with Parameter Store Paths

Once the parameters are created, update the `buildspec.yml` file with the correct paths so CodeBuild can access them during the build process.

```yaml
version: 0.2

env:
  parameter-store:
    DOCKER_USERNAME: /myapp/docker-credentials/username
    DOCKER_PASSWORD: /myapp/docker-credentials/password
    DOCKER_URL: /myapp/docker-registry/url
```

---

### 3. Full `buildspec.yml` File

Below is the full configuration used to build and push the Docker image using AWS CodeBuild.

```yaml
version: 0.2

env:
  parameter-store:
    DOCKER_USERNAME: /myapp/docker-credentials/username
    DOCKER_PASSWORD: /myapp/docker-credentials/password 
    DOCKER_URL: /myapp/docker-registry/url

phases:
  install:
    runtime-versions:
      python: 3.11
  
  pre_build:
    commands:
      - pip install -r requirements.txt
      
  build:
    commands:
       - echo "Building Docker image"
       - echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin "$DOCKER_URL"
       - docker build -t "$DOCKER_URL/$DOCKER_USERNAME/sample-python-app:latest" .
       - docker push "$DOCKER_URL/$DOCKER_USERNAME/sample-python-app"
      
  post_build:
    commands:
      - echo "Build is successful"
```
This YAML file is typically used for **AWS CodeBuild**, a fully managed continuous integration service that compiles source code, runs tests, and produces software packages ready for deployment.

Let me explain **each line** of this file so you can understand what it does and how to use it in your GitHub README or documentation:

---

### 🧾 Full File Overview

```yaml
version: 0.2
```

> This specifies the **version of the AWS CodeBuild specification** being used. Version `0.2` is the current standard and supports most modern features.

---

### 🔐 Environment Configuration (Parameter Store)

```yaml
env:
  parameter-store:
    DOCKER_USERNAME: /myapp/docker-credentials/username
    DOCKER_PASSWORD: /myapp/docker-credentials/password 
    DOCKER_URL: /myapp/docker-registry/url
```

#### Explanation:

- `env`: Configures environment variables for the build process.
- `parameter-store`: Tells AWS CodeBuild to fetch these values from **AWS Systems Manager Parameter Store**, which is a secure way to store sensitive data like credentials.
  
Each line maps an environment variable inside the build container to a secure parameter in AWS SSM:

- `DOCKER_USERNAME`: The username to authenticate with a Docker registry (e.g., Docker Hub, ECR).
- `DOCKER_PASSWORD`: The password associated with the Docker username.
- `DOCKER_URL`: URL of the Docker registry (e.g., `https://index.docker.io/v1/` for Docker Hub).

These are **not hard-coded** here for security reasons — they're fetched securely during the build.

---

### ⚙️ Phases of the Build Process

The build process in CodeBuild is broken into **phases**: `install`, `pre_build`, `build`, and `post_build`.

---

#### 📦 Phase: `install`

```yaml
install:
  runtime-versions:
    python: 3.11
```

- This tells CodeBuild to use **Python version 3.11** during the build process.
- It ensures the correct language runtime is installed before any commands run.

---

#### 🛠️ Phase: `pre_build`

```yaml
pre_build:
  commands:
    - pip install -r requirements.txt
```

- Runs before the actual build.
- Installs Python dependencies listed in `requirements.txt`.
- Useful if your app needs certain tools or libraries to build successfully.

---

#### 🏗️ Phase: `build`

```yaml
build:
  commands:
    - echo "Building Docker image"
```

- Prints a message to indicate that the Docker image build is starting.

```bash
    - echo "DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin "$DOCKER_URL"
```

- `echo "DOCKER_PASSWORD"`: Outputs the password stored in the `DOCKER_PASSWORD` environment variable.
  
- `|`: Pipes the output (the password) into the next command as standard input.
  
- `docker login`: Command to log in to a Docker registry.
  
- `-u "$DOCKER_USERNAME"`: Specifies the username from the `DOCKER_USERNAME` environment variable.
  
- `--password-stdin`: Tells Docker to read the password from standard input (i.e., the value piped from `echo`), which is more secure than passing the password directly in the command.
  
- `"$DOCKER_URL"`: Specifies the URL of the Docker registry to log in to (e.g., `https://index.docker.io/v1/` for Docker Hub or a private registry URL).

```bash
    - docker build -t "$DOCKER_URL/$DOCKER_USERNAME/sample-python-app:latest" .
```

- Builds a Docker image from the `Dockerfile` in the current directory (`.`).
- Tags the image as: `registry-url/username/sample-python-app:latest`

```bash
    - docker push "$DOCKER_URL/$DOCKER_USERNAME/sample-python-app"
```

- Pushes the built Docker image to the specified Docker registry.
- This makes the image available for deployment elsewhere (like ECS, Kubernetes, etc.).

---

#### ✅ Phase: `post_build`

```yaml
post_build:
  commands:
    - echo "Build is successful"
```

- Runs after the build completes.
- Outputs a success message to the logs.
- You could also trigger notifications or deploy the image here.


