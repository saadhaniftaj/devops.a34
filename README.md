# DevOps Assignment 3 & 4 - CI/CD Pipeline

This repository contains a React + Node.js application with automated CI/CD pipelines for Testing and Staging environments.

## Project Structure

```
.
├── frontend/          # React frontend application
├── backend/           # Node.js backend API
├── .github/
│   └── workflows/     # GitHub Actions workflows
├── docker-compose.yml # Docker Compose for local development
└── README.md

```

## Prerequisites

- Node.js 18+ and npm
- Docker and Docker Compose (for Assignment 4)
- AWS Account with EC2 instances set up
- GitHub repository with Actions enabled

## Local Setup

### Frontend
```bash
cd frontend
npm install
npm start
```

### Backend
```bash
cd backend
npm install
npm start
```

## GitHub Secrets Configuration

**IMPORTANT**: Never commit AWS credentials to the repository. Add them as GitHub Secrets:

1. Go to your repository: https://github.com/saadhaniftaj/devops.a34
2. Navigate to **Settings** > **Secrets and variables** > **Actions**
3. Add the following secrets:

### Required Secrets for Assignment 3:
- `AWS_ACCESS_KEY_ID`: Your AWS Access Key ID
- `AWS_SECRET_ACCESS_KEY`: Your AWS Secret Access Key
- `TESTING_EC2_HOST`: Your Testing EC2 instance public IP
- `TESTING_EC2_USER`: `ubuntu` (for Ubuntu Server)
- `TESTING_EC2_SSH_KEY`: Your private SSH key for Testing instance
- `STAGING_EC2_HOST`: Your Staging EC2 instance public IP
- `STAGING_EC2_USER`: `ubuntu`
- `STAGING_EC2_SSH_KEY`: Your private SSH key for Staging instance
- `QA_EMAIL`: Instructor's email for notifications
- `DEVELOPER_EMAIL`: Developer email for notifications
- `EMAIL_USERNAME`: Your Gmail address (for sending notifications)
- `EMAIL_PASSWORD`: Gmail App Password (see SETUP_GUIDE.md)

### Additional Secrets for Assignment 4:
- `AWS_REGION`: Your AWS region (e.g., `us-east-1`)
- `ECR_REPOSITORY_FRONTEND`: ECR repository name for frontend (e.g., `devops-frontend`)
- `ECR_REPOSITORY_BACKEND`: ECR repository name for backend (e.g., `devops-backend`)

**📖 For detailed setup instructions, see [SETUP_GUIDE.md](SETUP_GUIDE.md)**

## Branch Protection

Ensure the main branch is protected:
1. Go to **Settings** > **Branches**
2. Add rule for `main` branch
3. Enable: "Require pull request reviews before merging"
4. Enable: "Do not allow bypassing the above settings"

## Workflows

### Assignment 3 Workflows:
- `.github/workflows/testing-deploy.yml` - Deploys to Testing on PR
- `.github/workflows/staging-deploy.yml` - Deploys to Staging on merge to main

### Assignment 4 Workflows:
- `.github/workflows/testing-docker-deploy.yml` - Containerized Testing deployment
- `.github/workflows/staging-docker-deploy.yml` - Containerized Staging deployment

## Running Locally with Docker (Assignment 4)

```bash
docker-compose up
```

Access:
- Frontend: http://localhost:3000
- Backend: http://localhost:5000

