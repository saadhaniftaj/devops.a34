# Complete Setup Guide for DevOps Assignments 3 & 4

This guide will walk you through setting up the entire CI/CD pipeline for both assignments.

## Prerequisites Checklist

- [ ] GitHub account with repository: https://github.com/saadhaniftaj/devops.a34
- [ ] AWS account with EC2 access
- [ ] AWS Access Key ID: (Your AWS Access Key ID)
- [ ] AWS Secret Access Key: (Your AWS Secret Access Key)
- [ ] Email account for notifications (Gmail recommended)
- [ ] SSH keys for EC2 instances

---

## Step 1: Initial Repository Setup

### 1.1 Initialize Git Repository

```bash
cd /Users/applestore/Desktop/dev34
git init
git add .
git commit -m "Initial commit: React + Node.js app with CI/CD workflows"
git branch -M main
git remote add origin https://github.com/saadhaniftaj/devops.a34.git
git push -u origin main
```

### 1.2 Add Collaborators

1. Go to: https://github.com/saadhaniftaj/devops.a34/settings/access
2. Click "Add people"
3. Add your teammate and instructor as collaborators

### 1.3 Protect Main Branch

1. Go to: https://github.com/saadhaniftaj/devops.a34/settings/branches
2. Click "Add rule" for `main` branch
3. Enable:
   - ✅ Require pull request reviews before merging
   - ✅ Require status checks to pass before merging
   - ✅ Do not allow bypassing the above settings

---

## Step 2: AWS EC2 Setup (Assignment 3)

### 2.1 Create Security Group

1. Go to AWS Console → EC2 → Security Groups
2. Create new security group named: `devops-assignment-sg`
3. Add inbound rules:
   - **SSH (22)**: Your IP address
   - **HTTP (80)**: 0.0.0.0/0 (all traffic)
   - **Custom TCP (5000)**: 0.0.0.0/0 (for backend API)

### 2.2 Create Testing EC2 Instance

1. Launch EC2 instance:
   - **Name**: `testing-environment`
   - **AMI**: Ubuntu Server 24.04 LTS (HVM)
   - **Instance Type**: t2.micro (free tier) or t2.small
   - **Security Group**: `devops-assignment-sg`
   - **Key Pair**: Create/download new key pair (save `.pem` file securely)

2. Note the **Public IP** address

### 2.3 Create Staging EC2 Instance

1. Launch another EC2 instance:
   - **Name**: `staging-environment`
   - **AMI**: Ubuntu Server 24.04 LTS (HVM)
   - **Instance Type**: t2.micro (free tier) or t2.small
   - **Security Group**: `devops-assignment-sg` (same as Testing)
   - **Key Pair**: Use same key pair or create new one

2. Note the **Public IP** address

### 2.4 Configure EC2 Instances

SSH into each instance and run:

```bash
# Update system
sudo apt-get update && sudo apt-get upgrade -y

# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install PM2 (process manager)
sudo npm install -g pm2

# Install Nginx
sudo apt-get install -y nginx

# Install Git
sudo apt-get install -y git

# Start Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Verify installations
node --version
npm --version
pm2 --version
nginx -v
```

---

## Step 3: AWS ECR Setup (Assignment 4)

### 3.1 Create ECR Repositories

1. Go to AWS Console → ECR (Elastic Container Registry)
2. Create two repositories:
   - **Repository 1**: `devops-frontend`
   - **Repository 2**: `devops-backend`
3. Note the repository URIs (format: `123456789012.dkr.ecr.us-east-1.amazonaws.com/devops-frontend`)

### 3.2 Create IAM Role for EC2 (Optional but Recommended)

1. Go to IAM → Roles → Create Role
2. Select "EC2" as trusted entity
3. Attach policy: `AmazonEC2ContainerRegistryReadOnly`
4. Name: `EC2-ECR-Access-Role`
5. Attach this role to your EC2 instances:
   - EC2 → Instances → Select instance → Actions → Security → Modify IAM role

---

## Step 4: Configure GitHub Secrets

**CRITICAL**: Never commit these credentials to the repository!

### 4.1 Navigate to Secrets

Go to: https://github.com/saadhaniftaj/devops.a34/settings/secrets/actions

### 4.2 Add Required Secrets

Click "New repository secret" for each:

#### AWS Credentials
- **Name**: `AWS_ACCESS_KEY_ID`
- **Value**: Your AWS Access Key ID

- **Name**: `AWS_SECRET_ACCESS_KEY`
- **Value**: Your AWS Secret Access Key

- **Name**: `AWS_REGION`
- **Value**: `us-east-1` (or your region)

#### EC2 Testing Environment
- **Name**: `TESTING_EC2_HOST`
- **Value**: Your Testing EC2 public IP (e.g., `54.123.45.67`)

- **Name**: `TESTING_EC2_USER`
- **Value**: `ubuntu`

- **Name**: `TESTING_EC2_SSH_KEY`
- **Value**: Contents of your `.pem` file (copy entire content including `-----BEGIN RSA PRIVATE KEY-----`)

#### EC2 Staging Environment
- **Name**: `STAGING_EC2_HOST`
- **Value**: Your Staging EC2 public IP

- **Name**: `STAGING_EC2_USER`
- **Value**: `ubuntu`

- **Name**: `STAGING_EC2_SSH_KEY`
- **Value**: Contents of your `.pem` file

#### ECR Repositories (Assignment 4)
- **Name**: `ECR_REPOSITORY_FRONTEND`
- **Value**: `devops-frontend` (just the name, not full URI)

- **Name**: `ECR_REPOSITORY_BACKEND`
- **Value**: `devops-backend`

#### Email Notifications
- **Name**: `EMAIL_USERNAME`
- **Value**: Your Gmail address (e.g., `yourname@gmail.com`)

- **Name**: `EMAIL_PASSWORD`
- **Value**: Gmail App Password (see below for setup)

- **Name**: `QA_EMAIL`
- **Value**: Instructor's email address

- **Name**: `DEVELOPER_EMAIL`
- **Value**: Your email address

### 4.3 Gmail App Password Setup

1. Go to Google Account → Security
2. Enable 2-Step Verification
3. Go to App Passwords
4. Generate new app password for "Mail"
5. Use this 16-character password in `EMAIL_PASSWORD` secret

---

## Step 5: Test Local Setup

### 5.1 Test Frontend Locally

```bash
cd frontend
npm install
npm start
# Open http://localhost:3000
```

### 5.2 Test Backend Locally

```bash
cd backend
npm install
npm start
# API available at http://localhost:5000/api/hello
```

### 5.3 Run Tests

```bash
# Frontend tests
cd frontend
npm test

# Backend tests
cd backend
npm test
```

### 5.4 Test Docker (Assignment 4)

```bash
# Build and run with Docker Compose
docker-compose up --build

# Access:
# Frontend: http://localhost:3000
# Backend: http://localhost:5000
```

---

## Step 6: Test CI/CD Pipeline

### 6.1 Test Testing Workflow (Assignment 3)

1. Create a feature branch:
   ```bash
   git checkout -b feature/test-deployment
   git add .
   git commit -m "Test: Add test feature"
   git push origin feature/test-deployment
   ```

2. Create Pull Request:
   - Go to GitHub repository
   - Click "New Pull Request"
   - Select `feature/test-deployment` → `main`
   - Create PR

3. The workflow should automatically trigger
4. Check Actions tab: https://github.com/saadhaniftaj/devops.a34/actions
5. Once complete, access: `http://<TESTING_EC2_IP>`

### 6.2 Test Staging Workflow (Assignment 3)

1. Merge the PR created above
2. This triggers staging deployment
3. Access: `http://<STAGING_EC2_IP>`

### 6.3 Test Docker Workflows (Assignment 4)

Same process as above, but workflows will:
- Build Docker images
- Push to ECR
- Deploy containers on EC2

---

## Step 7: Troubleshooting

### Common Issues

#### SSH Connection Failed
- Verify security group allows SSH from your IP
- Check SSH key is correct in GitHub Secrets
- Ensure EC2 instance is running

#### Deployment Fails
- Check EC2 has Node.js, PM2, Nginx installed
- Verify security group allows HTTP (port 80)
- Check workflow logs in GitHub Actions

#### Email Notifications Not Working
- Verify Gmail App Password is correct
- Check email secrets are set correctly
- Ensure 2-Step Verification is enabled on Gmail

#### Docker Deployment Fails (Assignment 4)
- Verify ECR repositories exist
- Check IAM permissions for ECR access
- Ensure Docker is installed on EC2 instances:
  ```bash
  sudo apt-get install docker.io docker-compose -y
  sudo usermod -aG docker ubuntu
  ```

#### ECR Login Fails
- Verify AWS credentials in GitHub Secrets
- Check AWS region matches ECR region
- Ensure IAM user has ECR permissions

---

## Step 8: Assignment Submission Checklist

### Assignment 3
- [ ] Repository is public
- [ ] Instructor added as collaborator
- [ ] Main branch is protected
- [ ] Testing workflow works on PR
- [ ] Staging workflow works on merge
- [ ] Email notifications working
- [ ] App accessible on both EC2 instances
- [ ] Screenshots captured for report

### Assignment 4
- [ ] All Assignment 3 requirements met
- [ ] Dockerfiles created for frontend and backend
- [ ] Docker Compose file created
- [ ] ECR repositories set up
- [ ] Containerized workflows working
- [ ] Containers running on EC2 instances
- [ ] Deployment diagram created
- [ ] Screenshots captured for report

---

## Support

If you encounter issues:
1. Check GitHub Actions logs
2. SSH into EC2 and check logs: `pm2 logs` or `docker logs`
3. Verify all secrets are set correctly
4. Check AWS console for any permission issues

Good luck with your assignments! 🚀

