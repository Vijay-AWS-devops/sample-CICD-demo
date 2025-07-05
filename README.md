# 🚀 Simple Flask Python App Deployment with AWS CI/CD

This project demonstrates a seamless CI/CD pipeline for deploying a simple Flask Python application using AWS services: **AWS CodeBuild**, **AWS CodePipeline**, and **AWS CodeDeploy**. The pipeline automates building, testing, and deploying the Flask app to an AWS environment.

![Picsart_25-07-02_22-54-19-380](https://github.com/user-attachments/assets/5ec33a02-dd98-4c92-8feb-bea7928540be)


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
- 🔄 `AWSCodePipeline_FullAccess`:This allows you to create and manage AWS CodePipeline for continuous integration.
- 💻 `AmazonEC2FullAccess`:This allows you to create and deploy an application on an EC2 instance.

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
  

After completing the code build, click Start Build in AWS CodeBuild. If it succeeds, it will display the status as Succeeded.

![image](https://github.com/user-attachments/assets/0bf0a079-1c3c-48fe-9520-bd256fca6cbc)

Here's an enhanced version of your content formatted as a **GitHub README.md** file, with improved structure, visuals (like badges and emojis), and additional context to make it more professional and user-friendly:

---

### 🚀 AWS CodePipeline Setup Guide

AWS CodePipeline is a fully managed continuous delivery service that helps automate your release pipelines. It orchestrates various stages like source control, build, test, and deployment so you can rapidly and reliably release updates to your applications.


## 🛠️ Step-by-Step Pipeline Creation

### 1. **Create a New Pipeline**

1. Go to the [AWS CodePipeline Console](https://console.aws.amazon.com/codepipeline/)
2. Click **Create pipeline**
3. Under **Creation options**, select **Build a custom pipeline**
4. Fill in the details:
   - **Pipeline name**: e.g., `MyAppPipeline`
   - **Execution mode**: Choose **Queued**
   - **Service role**: Select either:
     - Create a new service role (recommended for simplicity)
     - Or use an existing IAM role with proper CodePipeline permissions

     ![image](https://github.com/user-attachments/assets/444ccaae-3899-48ef-8265-b268558babd5)


Click **Next**

---

### 2. **Add Source Stage: GitHub**

1. **Source provider**: Select **GitHub (OAuth)**
2. Connect your GitHub account if not already connected
3. Choose the **Repository** and **Branch** you want to monitor
4. Select or create a webhook to enable automatic pipeline triggers on push events

![image](https://github.com/user-attachments/assets/15221e03-8293-4b48-9127-ead1a34e2539)


Click **Next**

---

### 3. **Add Build Stage: AWS CodeBuild**

1. **Build provider**: Choose **Other build providers**
2. Select **AWS CodeBuild**
3. Configure the following:
   - **Project name**: Choose an existing CodeBuild project or create one
   - **Build type**: Select **Single build**
   - **Region**: Ensure it matches where your CodeBuild project exists

   ![image](https://github.com/user-attachments/assets/ebdcae8a-fc89-4abc-adde-a5abb93a50f5)


Click **Next**

---

### 4. **Skip Test & Deploy Stages (Optional for Now)**

For initial CI validation:
- Leave **Test** and **Deploy** stages unchecked
- We'll add them later once the base pipeline is verified

Click **Next**, review all settings, and click **Create pipeline**

---

## 🧪 Verifying the Pipeline

After creation, the pipeline will automatically start running:

✅ If successful:
- The build status will show as **Succeeded**
- You should see a Docker image pushed to your container registry (if configured in your buildspec)

![image](https://github.com/user-attachments/assets/58d7487e-a6ed-494c-a7ae-64210bf318ba)

Latest Image in Docker repository

![image](https://github.com/user-attachments/assets/cdfc8a7b-b0c5-46af-af2f-9cc0895dae28)

💡 Tip: Check the CodeBuild logs for detailed output if any stage fails.

Here's a **GitHub README.md** version of your content, with enhanced formatting, structure, and explanations to make it more professional and easy to follow:

---

# 🚀 Continuous Deployment with AWS CodeDeploy (Ubuntu EC2 Setup)

## ✅ Step-by-Step Guide

### 1. Create an Application in AWS CodeDeploy

1. Go to the [AWS CodeDeploy Console](https://console.aws.amazon.com/codedeploy).
2. Click **Create application**.
3. Enter:
   - **Application name**: e.g., `MyApp`
   - **Compute platform**: Select `EC2`
4. Click **Create application**.

![image](https://github.com/user-attachments/assets/c3910205-1d28-4877-ab3e-0f30542bd3cc)


---

### 2. Launch an Ubuntu EC2 Instance

1. Navigate to the **EC2 Dashboard**.
2. Click **Launch Instance**.
3. Choose **Ubuntu Server** as your AMI.
4. Choose an appropriate instance type.
5. Configure instance details (ensure VPC and subnet are correctly selected).
6. Add storage if needed.
7. Tag your instance appropriately (we’ll use tags later for CodeDeploy).

---

### 3. Set Up IAM Roles for Communication

To allow communication between EC2 and CodeDeploy:

#### Create IAM Roles:
- **Role for EC2 Instance (`EC2CodeDeployRole`)**:
  - Attach the policy: `AmazonEC2RoleforAWSCodeDeploy`
  - This allows the instance to communicate with CodeDeploy.

- **Role for CodeDeploy Service**:
  - Create a service role for CodeDeploy.
  - Attach the policy: `AWSCodeDeployRole`
  - Trust relationship should allow CodeDeploy to assume this role.

> 🔐 You can combine both permissions into one role if needed, but it's best practice to separate concerns.

---

### 4. Tag Your EC2 Instance

Tags help CodeDeploy identify which instances to deploy to.

1. In the EC2 console, select your instance.
2. Click **Actions > Instance Settings > Manage Tags**.
3. Add a tag like:
   - Key: `Name`
   - Value: `CodeDeployInstance`
   - Or any custom key-value pair that helps identify the target environment.

---

### 6. Install the AWS CodeDeploy Agent

Follow these steps to install the agent on your Ubuntu instance:

> 📌 For more details, refer to the official documentation:  
> [Install the CodeDeploy Agent on Ubuntu](https://docs.aws.amazon.com/codedeploy/latest/userguide/codedeploy-agent-operations-install-ubuntu.html)
---

### 7. Check and Restart the CodeDeploy Agent

#### Check Status

```bash
sudo systemctl status codedeploy-agent
```

If not running, start or restart the service:

```bash
sudo systemctl restart codedeploy-agent
```

#### Verify Again

```bash
sudo systemctl status codedeploy-agent
```

You should see `active (running)` in the output.

![image](https://github.com/user-attachments/assets/0c88e6cc-e29c-4c4c-a1eb-d2b4b1f272df)

---

### 8. Install Docker on the EC2 Instance

Most modern applications are containerized using Docker. Install Docker with the following command:

```bash
sudo apt install docker.io -y
```

#### Verify Docker Installation

```bash
docker --version
```

You should see output like:

```
Docker version 20.xx.x, build abcdefg
```

---

Now that your EC2 instance is ready with the CodeDeploy agent and Docker installed. Now we need to create a Deployment group.

 
 **Deployment Group in AWS CodeDeploy**:
---

## 🛠️ Step: Create a Deployment Group

Now that your application and EC2 instance are set up, it’s time to create a **Deployment Group**. This group defines which instances will receive deployments, how they’ll be updated, and what deployment settings to use.

### 🔧 Steps to Create a Deployment Group

1. **Go to the AWS CodeDeploy Console**
   - Navigate to your previously created application.

2. **Click on "Create deployment group"**

3. **Enter Deployment Group Name**
   - Example: `Production-Deployment-Group`

4. **Service Role**
   - Choose the **service role** you created earlier (e.g., `CodeDeployServiceRole`)
   - This role gives CodeDeploy permissions to interact with your EC2 instances.

5. **Deployment Type**
   - Select **In-place deployment**
     - This updates instances in place by stopping the application, deploying the latest version, and restarting it.
    
   ![image](https://github.com/user-attachments/assets/d39a4b36-b26a-4df8-90b5-f870a5664532)


6. **Environment Configuration**
   - Select **Amazon EC2 instances**
   - Choose the **tag(s)** you applied to your Ubuntu EC2 instance
     - Example:
       - Key: `Name`
       - Value: `CodeDeployInstance`
      
   ![image](https://github.com/user-attachments/assets/8931c75e-5e30-45d1-a532-f46b77e99253)


7. **Load Balancer**
   - Leave **Disable load balancer** selected (unless you're using one)

8. **Review & Create**
   - Double-check all settings
   - Click **Create deployment group**

![image](https://github.com/user-attachments/assets/0ead4d46-9190-44d3-a090-218981ff0a1f)

---

### ✅ You're Almost There!

With your deployment group now configured, you're just one step away from completing your continuous delivery pipeline. The final piece is preparing your **application revision** (your code or Docker image) and triggering your first deployment.

---

Here's a **GitHub README.md** section that explains how to create the three essential files needed for your AWS CodeDeploy deployment: `appspec.yml`, `start_container.sh`, and `stop_container.sh`.

---

## 📁 Required Deployment Files

To successfully deploy your application using **AWS CodeDeploy**, you need the following 3 files in your repository:

> ✅ **Important:** Place the `appspec.yml` file in the **root directory** of your repository.

---

### 1. `appspec.yml`

This is the main configuration file used by CodeDeploy to understand what actions to perform during deployment.

```yaml
version: 0.0
os: linux

hooks:
  ApplicationStop:
    - location: scripts/stop_container.sh
      timeout: 300
      runas: root
  AfterInstall:
    - location: scripts/start_container.sh
      timeout: 300
      runas: root
```

- `ApplicationStop`: Stops any running Docker containers before deploying new code.
- `AfterInstall`: Starts the new Docker container after the latest image is pulled.

---

### 2. `scripts/start_container.sh`

This script pulls the Docker image from your registry and starts it as a container.

Create a folder named `scripts` in the root directory, and place this file inside.

```bash
#!/bin/bash
set -e

# Pull the latest Docker image
docker pull dockermvk18/sample-python-app

# Run the Docker container
docker run -d -p 5000:5000 dockermvk18/sample-python-app
```

Make sure to make the script executable:

```bash
chmod +x scripts/start_container.sh
```

---

### 3. `scripts/stop_container.sh`

This script stops and removes any currently running container before a new version is deployed.

```bash
#!/bin/bash
set -e

# Stop and remove the running container
container_id=$(docker ps -q)
if [ -n "$container_id" ]; then
  docker rm -f "$container_id"
fi
```

Make this script executable too:

```bash
chmod +x scripts/stop_container.sh
```

---

## 🔐 Permissions Tip

Ensure that your EC2 instance has proper IAM permissions to:
- Pull images from Docker Hub or ECR
- Manage Docker containers via CodeDeploy

---

Here's a **GitHub README.md** section that walks users through creating a deployment in AWS CodeDeploy and integrating it with **AWS CodePipeline** for continuous delivery.

---

# 🚀 Creating a Deployment and Integrating with CodePipeline

Now that your application, EC2 instance, and deployment group are set up, it’s time to create a **deployment** and integrate everything into a **CI/CD pipeline** using **AWS CodePipeline**.

---

## 📦 Step 1: Create a Deployment in CodeDeploy

1. Go to the **AWS CodeDeploy Console**.
2. Select your application.
3. Click **Create deployment**.
4. Choose your **Deployment group** (e.g., `Production-Deployment-Group`).
5. Under **Revision type**, select:
   - **My application is stored in GitHub**
6. Connect to GitHub by clicking **Connect to GitHub** and authorize the connection if prompted.

![image](https://github.com/user-attachments/assets/59b6118b-082f-4f59-befa-b34528bfaf5b)


### 🔍 Enter GitHub Repository Details

- **Repository name**: e.g., `your-github-username/sample-python-app`
- **Commit ID**: Copy the latest commit hash from your GitHub repository
  - This ensures you're deploying a known version of your code
  - You can find this under the "Insights" tab or on the "Commits" page in GitHub. The purpose of providing a commit ID is to verify whether Continuous Delivery is working or not.
 
 ![image](https://github.com/user-attachments/assets/2a08b1c4-10da-4ced-92ab-55c33f540688)


7. Click **Create deployment**

   ![image](https://github.com/user-attachments/assets/1cec8684-e52b-4840-bbde-be06873eea44)


---

## 🔄 Step 2: Integrate CodeDeploy with AWS CodePipeline

To automate deployments on every commit, add a **CodeDeploy stage** in **AWS CodePipeline**.

### ✅ Add a Stage in CodePipeline

![image](https://github.com/user-attachments/assets/127c0f98-2ff3-49f2-a50e-943498d39626)


1. Open the **AWS CodePipeline Console**
2. Select your pipeline
3. Click **Edit**
4. Scroll down and click **Add stage**
   - Name the stage: `Deploy` or `CodeDeploy`

### ➕ Add Action to the Stage

1. Click **Add action**
2. Configure the action:
   - **Action name**: `DeployToEC2`
   - **Action provider**: `AWS CodeDeploy`
   - **Input artifacts**: Select the source artifact from the previous stage (usually named `SourceArtifact`)
   - **Application name**: Your CodeDeploy application name
   - **Deployment group**: The deployment group you created earlier
3. Click **Done**

![image](https://github.com/user-attachments/assets/d49c5a3a-9293-4c6f-acab-f85f3f7c50ba)


### 💾 Save Pipeline Changes

- Click **Save** at the top of the editor
- Confirm changes when prompted

---

## 🧪 Step 3: Test the CI/CD Flow

1. Make a small change in your application code (e.g., update a message or comment).
2. Commit and push the change to your GitHub repository.
3. Go to the **CodePipeline Console**
   - Watch as the pipeline automatically triggers:
     - Source → Build (if applicable) → Deploy

![image](https://github.com/user-attachments/assets/6fa18e37-4241-46b5-8ee7-a45ba2f396ee)

---

## ✅ Success!

If all stages pass successfully in CodePipeline, you’ve successfully built a **Continuous Integration and Continuous Delivery (CI/CD)** pipeline using:

- GitHub (as source)
- AWS CodePipeline (orchestration)
- AWS CodeDeploy (automated deployment)
- EC2 with Docker (target environment)

---

## 📌 Tips

- Ensure your GitHub repository contains the required files (`appspec.yml`, `start_container.sh`, `stop_container.sh`) in the root directory.
- Always test deployments manually before enabling full automation.
---


