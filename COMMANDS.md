# ============================================================================
# COMPLETE COMMAND REFERENCE - CS423 DevOps Assignment 4
# ============================================================================
# This document contains ALL commands you need to know for the exam
# Each command includes:
# - WHERE to execute it (location/context)
# - WHAT it does (purpose and explanation)
# - WHEN to use it (workflow step)
# - Expected output or result
# ============================================================================

## TABLE OF CONTENTS
1. [Local Development Commands](#local-development-commands)
2. [Terraform Commands](#terraform-commands)
3. [AWS CLI Commands](#aws-cli-commands)
4. [Docker Commands](#docker-commands)
5. [Git & GitHub Commands](#git--github-commands)
6. [EC2 Instance Commands](#ec2-instance-commands)
7. [Troubleshooting Commands](#troubleshooting-commands)

---

## LOCAL DEVELOPMENT COMMANDS

### Initial Setup

```bash
# ============================================================================
# WHERE: Your local machine terminal
# WHAT: Navigate to project directory
# WHEN: Before starting any work
# ============================================================================
cd /Users/applestore/Desktop/final
```

```bash
# ============================================================================
# WHERE: Project root directory
# WHAT: List all files and directories (including hidden files)
# WHEN: To see project structure
# FLAGS:
#   -la: Long format + show hidden files
#   -lh: Long format + human-readable sizes
# ============================================================================
ls -la
```

```bash
# ============================================================================
# WHERE: Project root directory
# WHAT: Display directory tree structure
# WHEN: To visualize project organization
# NOTE: Install with: brew install tree (Mac) or apt install tree (Linux)
# ============================================================================
tree -L 2  # Show 2 levels deep
```

### Docker Compose (Local Testing)

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final
# WHAT: Build and start all containers defined in docker-compose.yml
# WHEN: Testing application locally before deployment
# FLAGS:
#   --build: Force rebuild of images
#   -d: Detached mode (run in background)
# ============================================================================
docker-compose up --build
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final
# WHAT: Stop and remove all containers
# WHEN: Stopping local development environment
# ============================================================================
docker-compose down
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final
# WHAT: View logs from all containers
# WHEN: Debugging issues
# FLAGS:
#   -f: Follow log output (live updates)
#   --tail=100: Show last 100 lines
# ============================================================================
docker-compose logs -f
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final
# WHAT: List running containers
# WHEN: Checking container status
# ============================================================================
docker-compose ps
```

---

## TERRAFORM COMMANDS

### Initialization and Setup

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final/terraform
# WHAT: Initialize Terraform working directory
# WHEN: First time setup OR after adding new providers
# DOES:
#   - Downloads required providers (AWS, TLS, Local)
#   - Creates .terraform directory
#   - Creates .terraform.lock.hcl (dependency lock file)
# OUTPUT: "Terraform has been successfully initialized!"
# ============================================================================
terraform init
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final/terraform
# WHAT: Upgrade providers to latest versions
# WHEN: Updating provider versions
# ============================================================================
terraform init -upgrade
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final/terraform
# WHAT: Copy example variables file
# WHEN: First time setup
# ============================================================================
cp terraform.tfvars.example terraform.tfvars
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final/terraform
# WHAT: Edit variables file with your values
# WHEN: Customizing configuration
# ============================================================================
nano terraform.tfvars
# OR
code terraform.tfvars  # If using VS Code
```

### Validation and Planning

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final/terraform
# WHAT: Validate Terraform configuration syntax
# WHEN: After writing/modifying Terraform files
# DOES: Checks for syntax errors, missing variables, invalid references
# OUTPUT: "Success! The configuration is valid." OR error messages
# ============================================================================
terraform validate
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final/terraform
# WHAT: Format Terraform files to canonical style
# WHEN: Before committing code
# DOES: Auto-formats .tf files for consistency
# ============================================================================
terraform fmt
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final/terraform
# WHAT: Show execution plan (preview changes)
# WHEN: Before applying changes
# DOES:
#   - Shows what will be created (+)
#   - Shows what will be modified (~)
#   - Shows what will be destroyed (-)
# OUTPUT: Detailed plan of all changes
# ============================================================================
terraform plan
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final/terraform
# WHAT: Save execution plan to file
# WHEN: Want to review plan later or apply exact plan
# ============================================================================
terraform plan -out=tfplan
```

### Applying Changes

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final/terraform
# WHAT: Apply changes to create/update infrastructure
# WHEN: Ready to deploy infrastructure
# DOES:
#   - Creates VPC, subnets, security groups
#   - Launches EC2 instances
#   - Creates IAM user and access keys
#   - Generates SSH key pair
# DURATION: 2-5 minutes
# COST: Starts billing for EC2 instances
# ============================================================================
terraform apply
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final/terraform
# WHAT: Apply without confirmation prompt
# WHEN: Automating deployments (CI/CD)
# WARNING: Use with caution - no confirmation!
# ============================================================================
terraform apply -auto-approve
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final/terraform
# WHAT: Apply a saved plan file
# WHEN: Applying previously reviewed plan
# ============================================================================
terraform apply tfplan
```

### Viewing Outputs

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final/terraform
# WHAT: Display all output values
# WHEN: After terraform apply completes
# SHOWS:
#   - EC2 public/private IPs
#   - SSH commands
#   - IAM user credentials
#   - Quick start guide
# ============================================================================
terraform output
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final/terraform
# WHAT: Display specific output value
# WHEN: Need one specific value
# EXAMPLE: terraform output web_server_public_ip
# ============================================================================
terraform output <output_name>
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final/terraform
# WHAT: Display output in raw format (no quotes)
# WHEN: Using output in scripts
# EXAMPLE: WEB_IP=$(terraform output -raw web_server_public_ip)
# ============================================================================
terraform output -raw <output_name>
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final/terraform
# WHAT: Display all outputs in JSON format
# WHEN: Parsing outputs programmatically
# ============================================================================
terraform output -json
```

### State Management

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final/terraform
# WHAT: List all resources in Terraform state
# WHEN: Checking what Terraform is managing
# ============================================================================
terraform state list
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final/terraform
# WHAT: Show details of specific resource
# WHEN: Debugging or inspecting resource attributes
# EXAMPLE: terraform state show aws_instance.web_server
# ============================================================================
terraform state show <resource_address>
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final/terraform
# WHAT: Refresh state to match real infrastructure
# WHEN: State is out of sync with actual resources
# ============================================================================
terraform refresh
```

### Destroying Infrastructure

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final/terraform
# WHAT: Destroy all managed infrastructure
# WHEN: Cleaning up / stopping costs
# DOES:
#   - Terminates EC2 instances
#   - Deletes VPC and subnets
#   - Removes security groups
#   - Deletes IAM user and access keys
# WARNING: This is irreversible!
# SAVES: Stops all AWS charges
# ============================================================================
terraform destroy
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final/terraform
# WHAT: Destroy without confirmation
# WHEN: Automating cleanup
# WARNING: Very dangerous - use carefully!
# ============================================================================
terraform destroy -auto-approve
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final/terraform
# WHAT: Destroy specific resource
# WHEN: Want to recreate just one resource
# EXAMPLE: terraform destroy -target=aws_instance.web_server
# ============================================================================
terraform destroy -target=<resource_address>
```

---

## AWS CLI COMMANDS

### Configuration

```bash
# ============================================================================
# WHERE: Local machine terminal (anywhere)
# WHAT: Configure AWS CLI with credentials
# WHEN: First time setup OR changing credentials
# PROMPTS:
#   - AWS Access Key ID: From terraform output
#   - AWS Secret Access Key: From terraform output -raw iam_secret_access_key
#   - Default region: us-east-1
#   - Default output format: json
# ============================================================================
aws configure
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: Verify AWS CLI configuration
# WHEN: Testing credentials
# OUTPUT: Account ID, User ARN, User ID
# ============================================================================
aws sts get-caller-identity
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: List AWS CLI configuration
# WHEN: Checking current settings
# ============================================================================
aws configure list
```

### ECR (Elastic Container Registry)

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: Create ECR repository for frontend
# WHEN: Before pushing Docker images
# ============================================================================
aws ecr create-repository \
    --repository-name cs423-frontend \
    --region us-east-1
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: Create ECR repository for backend
# WHEN: Before pushing Docker images
# ============================================================================
aws ecr create-repository \
    --repository-name cs423-backend \
    --region us-east-1
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: List all ECR repositories
# WHEN: Verifying repositories exist
# ============================================================================
aws ecr describe-repositories --region us-east-1
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: Get Docker login command for ECR
# WHEN: Before pushing/pulling images
# DOES: Authenticates Docker with ECR
# VALID: 12 hours
# ============================================================================
aws ecr get-login-password --region us-east-1 | \
    docker login --username AWS --password-stdin \
    <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: List images in ECR repository
# WHEN: Checking what images are available
# ============================================================================
aws ecr list-images \
    --repository-name cs423-frontend \
    --region us-east-1
```

### EC2 Commands

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: List all EC2 instances
# WHEN: Checking instance status
# ============================================================================
aws ec2 describe-instances --region us-east-1
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: List running EC2 instances (formatted)
# WHEN: Quick status check
# ============================================================================
aws ec2 describe-instances \
    --region us-east-1 \
    --filters "Name=instance-state-name,Values=running" \
    --query 'Reservations[*].Instances[*].[InstanceId,PublicIpAddress,Tags[?Key==`Name`].Value|[0]]' \
    --output table
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: Stop EC2 instance (to save costs)
# WHEN: Not using instance but want to keep it
# NOTE: EBS volumes still incur charges
# ============================================================================
aws ec2 stop-instances \
    --instance-ids <INSTANCE_ID> \
    --region us-east-1
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: Start stopped EC2 instance
# WHEN: Resuming work
# NOTE: Public IP will change
# ============================================================================
aws ec2 start-instances \
    --instance-ids <INSTANCE_ID> \
    --region us-east-1
```

---

## DOCKER COMMANDS

### Building Images

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final/frontend
# WHAT: Build frontend Docker image
# WHEN: After changing frontend code
# FLAGS:
#   -t: Tag the image with a name
#   .: Build context (current directory)
# ============================================================================
docker build -t cs423-frontend .
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final/backend
# WHAT: Build backend Docker image
# WHEN: After changing backend code
# ============================================================================
docker build -t cs423-backend .
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: Build image without using cache
# WHEN: Want fresh build (troubleshooting)
# ============================================================================
docker build --no-cache -t cs423-frontend .
```

### Tagging and Pushing

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: Tag image for ECR
# WHEN: Before pushing to ECR
# FORMAT: <account_id>.dkr.ecr.<region>.amazonaws.com/<repo>:<tag>
# ============================================================================
docker tag cs423-frontend:latest \
    <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/cs423-frontend:latest
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: Push image to ECR
# WHEN: After tagging
# REQUIRES: Docker login to ECR first
# ============================================================================
docker push <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/cs423-frontend:latest
```

### Running Containers

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: Run frontend container locally
# WHEN: Testing locally
# FLAGS:
#   -d: Detached mode (background)
#   -p: Port mapping (host:container)
#   --name: Container name
#   --rm: Remove container when stopped
# ============================================================================
docker run -d -p 3000:80 --name frontend cs423-frontend
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: Run backend container locally
# WHEN: Testing locally
# ============================================================================
docker run -d -p 5000:5000 --name backend cs423-backend
```

### Managing Containers

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: List running containers
# WHEN: Checking container status
# ============================================================================
docker ps
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: List all containers (including stopped)
# WHEN: Finding stopped containers
# ============================================================================
docker ps -a
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: View container logs
# WHEN: Debugging issues
# FLAGS:
#   -f: Follow (live updates)
#   --tail=100: Show last 100 lines
# ============================================================================
docker logs -f <container_name>
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: Execute command inside running container
# WHEN: Debugging or inspecting container
# EXAMPLE: docker exec -it frontend /bin/bash
# FLAGS:
#   -it: Interactive terminal
# ============================================================================
docker exec -it <container_name> <command>
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: Stop running container
# WHEN: Stopping container
# ============================================================================
docker stop <container_name>
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: Remove container
# WHEN: Cleaning up
# NOTE: Container must be stopped first
# ============================================================================
docker rm <container_name>
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: Stop and remove container in one command
# WHEN: Quick cleanup
# FLAGS:
#   -f: Force (stop if running)
# ============================================================================
docker rm -f <container_name>
```

### Image Management

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: List all Docker images
# WHEN: Checking available images
# ============================================================================
docker images
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: Remove Docker image
# WHEN: Cleaning up old images
# ============================================================================
docker rmi <image_name>
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: Remove all unused images
# WHEN: Freeing disk space
# FLAGS:
#   -a: Remove all unused images (not just dangling)
# ============================================================================
docker image prune -a
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: View image layers and size
# WHEN: Optimizing image size
# ============================================================================
docker history <image_name>
```

---

## GIT & GITHUB COMMANDS

### Initial Setup

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final
# WHAT: Initialize Git repository
# WHEN: First time setup
# ============================================================================
git init
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final
# WHAT: Add remote repository
# WHEN: Connecting to GitHub
# REPLACE: <your-username> with your GitHub username
# ============================================================================
git remote add origin https://github.com/<your-username>/cs423-assignment-4.git
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final
# WHAT: Verify remote repository
# WHEN: Checking remote configuration
# ============================================================================
git remote -v
```

### Basic Workflow

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final
# WHAT: Check status of working directory
# WHEN: Before committing
# SHOWS: Modified, staged, untracked files
# ============================================================================
git status
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final
# WHAT: Add all files to staging area
# WHEN: Preparing to commit
# ============================================================================
git add .
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final
# WHAT: Add specific file to staging
# WHEN: Want to commit specific files only
# ============================================================================
git add <filename>
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final
# WHAT: Commit staged changes
# WHEN: Saving changes with message
# ============================================================================
git commit -m "Your commit message here"
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final
# WHAT: Push commits to GitHub
# WHEN: Uploading changes to remote repository
# TRIGGERS: GitHub Actions workflows
# ============================================================================
git push origin main
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final
# WHAT: Pull latest changes from GitHub
# WHEN: Syncing with remote repository
# ============================================================================
git pull origin main
```

### Branching Strategy

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final
# WHAT: Create new branch
# WHEN: Starting new feature
# BEST PRACTICE: Use descriptive names (feature/add-auth, fix/bug-123)
# ============================================================================
git checkout -b <branch-name>
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final
# WHAT: Switch to existing branch
# WHEN: Changing branches
# ============================================================================
git checkout <branch-name>
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final
# WHAT: List all branches
# WHEN: Viewing available branches
# ============================================================================
git branch
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final
# WHAT: Merge branch into current branch
# WHEN: Integrating feature branch
# ============================================================================
git merge <branch-name>
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final
# WHAT: Delete branch
# WHEN: After merging feature
# ============================================================================
git branch -d <branch-name>
```

### Pull Requests (GitHub Web UI)

```
1. Push branch to GitHub:
   git push origin <branch-name>

2. Go to GitHub repository in browser

3. Click "Pull requests" tab

4. Click "New pull request"

5. Select base branch (main) and compare branch (your-branch)

6. Click "Create pull request"

7. Add title and description

8. Request reviewers (optional)

9. Click "Create pull request"

10. After review, click "Merge pull request"
```

---

## EC2 INSTANCE COMMANDS

### Connecting to EC2

```bash
# ============================================================================
# WHERE: Local machine terminal
# WHAT: SSH into web server
# WHEN: Need to access web server
# REQUIRES: Private key file (cs423-assignment4-key.pem)
# ============================================================================
ssh -i terraform/cs423-assignment4-key.pem ubuntu@<WEB_SERVER_PUBLIC_IP>
```

```bash
# ============================================================================
# WHERE: Local machine terminal
# WHAT: SSH into backend server
# WHEN: Need to access backend server
# ============================================================================
ssh -i terraform/cs423-assignment4-key.pem ubuntu@<BACKEND_SERVER_PUBLIC_IP>
```

```bash
# ============================================================================
# WHERE: Local machine terminal
# WHAT: Copy file to EC2 instance
# WHEN: Transferring files
# EXAMPLE: scp -i key.pem file.txt ubuntu@<IP>:~/
# ============================================================================
scp -i terraform/cs423-assignment4-key.pem <local-file> ubuntu@<IP>:<remote-path>
```

```bash
# ============================================================================
# WHERE: Local machine terminal
# WHAT: Copy file from EC2 instance
# WHEN: Downloading files
# ============================================================================
scp -i terraform/cs423-assignment4-key.pem ubuntu@<IP>:<remote-file> <local-path>
```

### On EC2 Instance

```bash
# ============================================================================
# WHERE: Inside EC2 instance (after SSH)
# WHAT: Check user data script logs
# WHEN: Troubleshooting instance initialization
# ============================================================================
sudo tail -f /var/log/cloud-init-output.log
```

```bash
# ============================================================================
# WHERE: Inside EC2 instance
# WHAT: Check auto-deployment logs
# WHEN: Troubleshooting container deployment
# ============================================================================
sudo tail -f /var/log/auto-deploy.log
```

```bash
# ============================================================================
# WHERE: Inside EC2 instance
# WHAT: Check Apache status
# WHEN: Troubleshooting web server
# ============================================================================
sudo systemctl status apache2
```

```bash
# ============================================================================
# WHERE: Inside EC2 instance
# WHAT: Check Docker status
# WHEN: Troubleshooting Docker
# ============================================================================
sudo systemctl status docker
```

```bash
# ============================================================================
# WHERE: Inside EC2 instance
# WHAT: List running Docker containers
# WHEN: Checking deployed containers
# ============================================================================
docker ps
```

```bash
# ============================================================================
# WHERE: Inside EC2 instance
# WHAT: View container logs
# WHEN: Debugging container issues
# ============================================================================
docker logs -f <container-name>
```

```bash
# ============================================================================
# WHERE: Inside EC2 instance
# WHAT: Manually run deployment script
# WHEN: Testing deployment
# ============================================================================
sudo /opt/scripts/pull-and-deploy.sh
```

```bash
# ============================================================================
# WHERE: Inside EC2 instance
# WHAT: Check cron jobs
# WHEN: Verifying auto-deployment schedule
# ============================================================================
crontab -l
```

```bash
# ============================================================================
# WHERE: Inside EC2 instance
# WHAT: Check disk usage
# WHEN: Monitoring storage
# FLAGS:
#   -h: Human-readable sizes
# ============================================================================
df -h
```

```bash
# ============================================================================
# WHERE: Inside EC2 instance
# WHAT: Check memory usage
# WHEN: Monitoring resources
# ============================================================================
free -h
```

```bash
# ============================================================================
# WHERE: Inside EC2 instance
# WHAT: Check CPU and process usage
# WHEN: Monitoring performance
# ============================================================================
top
# Press 'q' to quit
```

---

## TROUBLESHOOTING COMMANDS

### Network Connectivity

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: Test HTTP connection to web server
# WHEN: Verifying web server is accessible
# ============================================================================
curl http://<WEB_SERVER_PUBLIC_IP>
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: Test backend API
# WHEN: Verifying backend is running
# ============================================================================
curl http://<BACKEND_SERVER_PUBLIC_IP>:5000/health
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: Test port connectivity
# WHEN: Checking if port is open
# ============================================================================
telnet <IP> <PORT>
# Example: telnet 54.123.45.67 80
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: Test port with nc (netcat)
# WHEN: Telnet not available
# ============================================================================
nc -zv <IP> <PORT>
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: Ping instance
# WHEN: Testing basic connectivity
# NOTE: Security group must allow ICMP
# ============================================================================
ping <IP>
```

### Docker Troubleshooting

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: View Docker system information
# WHEN: Checking Docker installation
# ============================================================================
docker info
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: Check Docker disk usage
# WHEN: Running out of space
# ============================================================================
docker system df
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: Clean up Docker resources
# WHEN: Freeing disk space
# REMOVES: Stopped containers, unused networks, dangling images
# ============================================================================
docker system prune
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: Inspect container details
# WHEN: Debugging container configuration
# ============================================================================
docker inspect <container-name>
```

```bash
# ============================================================================
# WHERE: Anywhere
# WHAT: View container resource usage
# WHEN: Monitoring performance
# ============================================================================
docker stats
```

### Terraform Troubleshooting

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final/terraform
# WHAT: Show detailed logs
# WHEN: Debugging Terraform issues
# ============================================================================
TF_LOG=DEBUG terraform apply
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final/terraform
# WHAT: Show dependency graph
# WHEN: Understanding resource relationships
# REQUIRES: graphviz (brew install graphviz)
# ============================================================================
terraform graph | dot -Tpng > graph.png
```

```bash
# ============================================================================
# WHERE: /Users/applestore/Desktop/final/terraform
# WHAT: Import existing resource into Terraform state
# WHEN: Managing existing resources with Terraform
# ============================================================================
terraform import <resource_address> <resource_id>
```

---

## EXAM PREPARATION CHECKLIST

### Before Exam - Practice These Commands:

1. **Terraform Workflow**
   ```bash
   cd terraform
   terraform init
   terraform validate
   terraform plan
   terraform apply
   terraform output
   terraform destroy
   ```

2. **Docker Workflow**
   ```bash
   docker build -t app .
   docker run -d -p 8080:80 app
   docker ps
   docker logs <container>
   docker stop <container>
   ```

3. **Git Workflow**
   ```bash
   git status
   git add .
   git commit -m "message"
   git push origin main
   git checkout -b feature-branch
   ```

4. **AWS CLI Workflow**
   ```bash
   aws configure
   aws sts get-caller-identity
   aws ecr create-repository --repository-name app
   aws ecr get-login-password | docker login ...
   ```

5. **EC2 Access**
   ```bash
   ssh -i key.pem ubuntu@<IP>
   sudo tail -f /var/log/cloud-init-output.log
   docker ps
   ```

### Key Concepts to Remember:

- **Terraform**: Infrastructure as Code, state management, plan before apply
- **Docker**: Containerization, images vs containers, port mapping
- **Git**: Version control, branching, pull requests
- **AWS**: VPC, EC2, ECR, IAM, security groups
- **CI/CD**: Automated builds, testing, deployment

### Common Exam Questions:

1. How do you initialize a Terraform project? → `terraform init`
2. How do you preview Terraform changes? → `terraform plan`
3. How do you build a Docker image? → `docker build -t name .`
4. How do you push code to GitHub? → `git push origin main`
5. How do you SSH into EC2? → `ssh -i key.pem ubuntu@IP`
6. How do you create a Git branch? → `git checkout -b branch-name`
7. How do you view Terraform outputs? → `terraform output`
8. How do you check Docker logs? → `docker logs container-name`

---

**Remember**: Practice these commands multiple times before the exam!
**Tip**: Create a cheat sheet with the most common commands.
**Note**: Always read error messages carefully - they usually tell you what's wrong.

============================================================================
