# CS423 DevOps Assignment 4

## Terraform Infrastructure + CI/CD Pipeline + Containerized Application

[![Terraform](https://img.shields.io/badge/Terraform-1.0+-purple?logo=terraform)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-orange?logo=amazon-aws)](https://aws.amazon.com/)
[![Docker](https://img.shields.io/badge/Docker-Containerized-blue?logo=docker)](https://www.docker.com/)
[![GitHub Actions](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-green?logo=github-actions)](https://github.com/features/actions)

---

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Detailed Setup](#detailed-setup)
- [GitHub Workflow](#github-workflow)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)
- [Cost Management](#cost-management)
- [Exam Preparation](#exam-preparation)

---

## 🎯 Overview

This project demonstrates a complete DevOps workflow combining:

1. **Infrastructure as Code (Terraform)**: Automated AWS infrastructure deployment
2. **CI/CD Pipeline (GitHub Actions)**: Automated build and deployment
3. **Containerization (Docker)**: Portable application packaging

### Assignment Components

✅ **Task 1**: IAM User (`terraform-cs423-devops`) with Administrator access  
✅ **Task 2**: VPC with 2 public + 2 private subnets across 2 Availability Zones  
✅ **Task 3**: Security Groups with least privilege principle  
✅ **Task 4**: SSH Key Pair (`cs423-assignment4-key`)  
✅ **Task 5**: 2 EC2 instances (web server + backend) with user data scripts  
✅ **Task 6**: Terraform outputs (IPs, IAM details, connection commands)  
✅ **Bonus**: GitHub Actions CI/CD pipeline with ECR integration

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         AWS CLOUD                                │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                    VPC (10.0.0.0/16)                      │  │
│  │                                                            │  │
│  │  ┌──────────────────────┐  ┌──────────────────────┐     │  │
│  │  │  Public Subnet 1     │  │  Public Subnet 2     │     │  │
│  │  │  (10.0.1.0/24)       │  │  (10.0.2.0/24)       │     │  │
│  │  │  AZ: us-east-1a      │  │  AZ: us-east-1b      │     │  │
│  │  │                      │  │                      │     │  │
│  │  │  ┌──────────────┐   │  │  ┌──────────────┐   │     │  │
│  │  │  │   EC2 Web    │   │  │  │ EC2 Backend  │   │     │  │
│  │  │  │   Server     │   │  │  │   Server     │   │     │  │
│  │  │  │  - Apache    │   │  │  │  - MySQL     │   │     │  │
│  │  │  │  - Docker    │   │  │  │  - Docker    │   │     │  │
│  │  │  │  Port: 80    │   │  │  │  Port: 5000  │   │     │  │
│  │  │  └──────────────┘   │  │  └──────────────┘   │     │  │
│  │  └──────────────────────┘  └──────────────────────┘     │  │
│  │                                                            │  │
│  │  ┌──────────────────────┐  ┌──────────────────────┐     │  │
│  │  │  Private Subnet 1    │  │  Private Subnet 2    │     │  │
│  │  │  (10.0.11.0/24)      │  │  (10.0.12.0/24)      │     │  │
│  │  │  (Reserved)          │  │  (Reserved)          │     │  │
│  │  └──────────────────────┘  └──────────────────────┘     │  │
│  │                                                            │  │
│  │  ┌──────────────────────────────────────────────────┐   │  │
│  │  │          Internet Gateway                         │   │  │
│  │  └──────────────────────────────────────────────────┘   │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                  │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                   ECR Repositories                        │  │
│  │  - cs423-frontend                                         │  │
│  │  - cs423-backend                                          │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                      GITHUB REPOSITORY                           │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  GitHub Actions Workflows                                 │  │
│  │  - frontend-deploy.yml → Build & Push to ECR             │  │
│  │  - backend-deploy.yml  → Build & Push to ECR             │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘

                              ↓ (Auto-pull every 5 min)
                        
                    EC2 Instances Deploy Containers
```

---

## 📁 Project Structure

```
/Users/applestore/Desktop/final/
├── terraform/                      # Infrastructure as Code
│   ├── main.tf                    # Provider and backend configuration
│   ├── variables.tf               # Input variables
│   ├── outputs.tf                 # Output values
│   ├── vpc.tf                     # VPC and networking
│   ├── security-groups.tf         # Security group rules
│   ├── ec2.tf                     # EC2 instances
│   ├── iam.tf                     # IAM user and policies
│   ├── key-pair.tf                # SSH key pair
│   ├── user_data_web.sh          # Web server initialization
│   ├── user_data_backend.sh      # Backend server initialization
│   ├── terraform.tfvars.example  # Example variables
│   └── README.md                  # Terraform documentation
├── frontend/                       # Frontend application
│   ├── Dockerfile                 # Frontend container config
│   ├── index.html                 # Welcome page
│   ├── styles.css                 # Styling
│   └── app.js                     # Frontend logic
├── backend/                        # Backend API
│   ├── Dockerfile                 # Backend container config
│   ├── server.js                  # Express API server
│   ├── package.json               # Node.js dependencies
│   └── .env.example               # Environment variables
├── .github/workflows/              # CI/CD pipelines
│   ├── frontend-deploy.yml        # Frontend deployment
│   └── backend-deploy.yml         # Backend deployment
├── docker-compose.yml             # Local development
├── scripts/                        # Utility scripts
│   ├── setup-ecr.sh               # Create ECR repositories
│   ├── ec2-docker-setup.sh        # EC2 Docker installation
│   └── pull-and-deploy.sh         # Container deployment
├── docs/                           # Documentation
│   ├── ARCHITECTURE.md            # Architecture details
│   ├── TERRAFORM-GUIDE.md         # Terraform guide
│   ├── CICD-GUIDE.md              # CI/CD guide
│   └── TROUBLESHOOTING.md         # Troubleshooting
├── README.md                       # This file
├── COMMANDS.md                     # Complete command reference
└── .gitignore                      # Git ignore file
```

---

## ✅ Prerequisites

### Required Software

- **Terraform** (>= 1.0): [Download](https://www.terraform.io/downloads)
- **AWS CLI** (>= 2.0): [Download](https://aws.amazon.com/cli/)
- **Docker** (>= 20.0): [Download](https://www.docker.com/get-started)
- **Git** (>= 2.0): [Download](https://git-scm.com/downloads)

### AWS Account

- Active AWS account with billing enabled
- Sufficient permissions to create VPC, EC2, IAM resources

### GitHub Account

- GitHub account for repository hosting
- Access to repository settings for secrets configuration

---

## 🚀 Quick Start

### 1. Clone Repository

```bash
git clone https://github.com/<your-username>/cs423-assignment-4.git
cd cs423-assignment-4
```

### 2. Deploy Infrastructure

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
terraform init
terraform apply
```

### 3. Create ECR Repositories

```bash
cd ..
bash scripts/setup-ecr.sh
```

### 4. Configure GitHub Secrets

Go to GitHub repository → Settings → Secrets and variables → Actions

Add secrets:
- `AWS_ACCESS_KEY_ID`: From `terraform output iam_access_key_id`
- `AWS_SECRET_ACCESS_KEY`: From `terraform output -raw iam_secret_access_key`
- `AWS_REGION`: `us-east-1`

### 5. Push Code to Trigger CI/CD

```bash
git add .
git commit -m "Initial deployment"
git push origin main
```

### 6. Verify Deployment

```bash
# Get EC2 public IP
terraform output web_server_public_ip

# Test web server
curl http://<WEB_SERVER_PUBLIC_IP>
```

---

## 📖 Detailed Setup

See [COMMANDS.md](COMMANDS.md) for complete command reference with detailed explanations.

### Step 1: Terraform Infrastructure

```bash
# Navigate to terraform directory
cd /Users/applestore/Desktop/final/terraform

# Copy and edit variables
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars  # Edit with your values

# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Preview changes
terraform plan

# Apply changes (creates infrastructure)
terraform apply

# View outputs
terraform output
```

**What gets created:**
- VPC with CIDR 10.0.0.0/16
- 2 public subnets (10.0.1.0/24, 10.0.2.0/24)
- 2 private subnets (10.0.11.0/24, 10.0.12.0/24)
- Internet Gateway
- Route tables
- Security groups
- 2 EC2 t2.micro instances
- IAM user with access keys
- SSH key pair

### Step 2: ECR Repositories

```bash
# Create ECR repositories for Docker images
cd /Users/applestore/Desktop/final
bash scripts/setup-ecr.sh
```

### Step 3: GitHub Configuration

1. Create repository on GitHub: `cs423-assignment-4`
2. Add secrets (Settings → Secrets → Actions):
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_REGION`

### Step 4: Push Code

```bash
cd /Users/applestore/Desktop/final
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/<username>/cs423-assignment-4.git
git push -u origin main
```

---

## 🔄 GitHub Workflow

### Branching Strategy

```bash
# Create feature branch
git checkout -b feature/new-feature

# Make changes
# ... edit files ...

# Commit changes
git add .
git commit -m "Add new feature"

# Push branch
git push origin feature/new-feature

# Create Pull Request on GitHub
# After review and approval, merge to main
# This triggers CI/CD pipeline
```

### CI/CD Pipeline Flow

1. **Push to main** → Triggers GitHub Actions
2. **Checkout code** → Downloads repository
3. **Configure AWS** → Sets up credentials
4. **Login to ECR** → Authenticates Docker
5. **Build image** → Creates Docker image
6. **Push to ECR** → Uploads to registry
7. **EC2 auto-pull** → Deploys within 5 minutes

---

## ✔️ Verification

### Check Infrastructure

```bash
# View Terraform outputs
cd terraform
terraform output

# SSH into web server
ssh -i terraform/cs423-assignment4-key.pem ubuntu@<WEB_SERVER_IP>

# SSH into backend server
ssh -i terraform/cs423-assignment4-key.pem ubuntu@<BACKEND_SERVER_IP>
```

### Test Applications

```bash
# Test web server
curl http://<WEB_SERVER_IP>

# Test backend API
curl http://<BACKEND_SERVER_IP>:5000/health

# Test frontend container
curl http://<WEB_SERVER_IP>:3000

# Test backend container
curl http://<BACKEND_SERVER_IP>:5000
```

### Check Logs

```bash
# On EC2 instance (after SSH)
sudo tail -f /var/log/cloud-init-output.log  # User data logs
sudo tail -f /var/log/auto-deploy.log        # Deployment logs
docker logs -f frontend                       # Frontend container logs
docker logs -f backend                        # Backend container logs
```

---

## 🔧 Troubleshooting

See [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) for detailed solutions.

### Common Issues

**Can't SSH into EC2:**
- Check security group allows port 22 from your IP
- Verify key permissions: `chmod 400 terraform/cs423-assignment4-key.pem`
- Check instance is running: `terraform output`

**GitHub Actions failing:**
- Verify secrets are set correctly
- Check ECR repositories exist
- Verify IAM user has ECR permissions

**Containers not deploying:**
- SSH into EC2 and check logs: `sudo tail -f /var/log/auto-deploy.log`
- Verify Docker is running: `sudo systemctl status docker`
- Check ECR authentication: `aws ecr get-login-password`

---

## 💰 Cost Management

### Estimated Monthly Costs

- **EC2 (2 × t2.micro)**: $0 (free tier) or ~$16/month
- **EBS (2 × 20GB gp3)**: ~$4/month
- **Data Transfer**: ~$1-5/month
- **Total**: ~$5-25/month

### Cost Optimization

```bash
# Stop instances when not in use (EBS still charged)
aws ec2 stop-instances --instance-ids <INSTANCE_ID>

# Destroy all infrastructure (stops all charges)
cd terraform
terraform destroy

# Set up billing alerts in AWS Console
```

---

## 📚 Exam Preparation

### Key Files to Study

1. **[COMMANDS.md](COMMANDS.md)**: Complete command reference
2. **Terraform files**: Understanding infrastructure as code
3. **GitHub workflows**: CI/CD pipeline concepts
4. **Dockerfiles**: Container configuration

### Practice Exercises

1. Deploy infrastructure from scratch
2. Make code changes and trigger CI/CD
3. SSH into instances and check logs
4. Destroy and recreate infrastructure
5. Troubleshoot common issues

### Important Concepts

- **Terraform**: `init`, `plan`, `apply`, `destroy`, `output`
- **Docker**: `build`, `run`, `ps`, `logs`, `push`, `pull`
- **Git**: `add`, `commit`, `push`, `branch`, `merge`
- **AWS**: VPC, EC2, ECR, IAM, Security Groups
- **CI/CD**: GitHub Actions, workflows, secrets

---

## 📞 Support

For issues or questions:
1. Check [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)
2. Review [COMMANDS.md](COMMANDS.md)
3. Check GitHub Actions logs
4. Review Terraform logs: `TF_LOG=DEBUG terraform apply`

---

## 📝 License

This project is for educational purposes as part of CS423 DevOps course.

---

## 👥 Contributors

- **Your Name** - CS423 Student

---

**Good luck with your exam! 🎓**
