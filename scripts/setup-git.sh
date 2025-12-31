#!/bin/bash

echo "=========================================="
echo "Preparing Repository for GitHub Push"
echo "=========================================="
echo ""

cd /Users/applestore/Desktop/final

# Remove existing git if any
if [ -d ".git" ]; then
    echo "Removing existing .git directory..."
    rm -rf .git
fi

# Initialize new git repository
echo "Initializing new Git repository..."
git init

# Add all files
echo "Adding all files to Git..."
git add .

# Create initial commit
echo "Creating initial commit..."
git commit -m "Initial commit: Complete DevOps Assignment 4

- Terraform infrastructure (VPC, EC2, IAM, Security Groups)
- Frontend application (HTML, CSS, JS, Nginx Docker)
- Backend API (Node.js, Express, Docker)
- CI/CD pipelines (GitHub Actions for frontend and backend)
- Docker Compose for local development
- Comprehensive documentation"

# Set main as default branch
echo "Setting main as default branch..."
git branch -M main

# Add remote repository
echo "Adding remote repository..."
git remote add origin https://github.com/saadhaniftaj/devops.a34.git

echo ""
echo "=========================================="
echo "Repository Prepared!"
echo "=========================================="
echo ""
echo "Next steps:"
echo ""
echo "1. Make sure the GitHub repository is empty"
echo "   Visit: https://github.com/saadhaniftaj/devops.a34"
echo ""
echo "2. Push to GitHub with:"
echo "   git push -u origin main --force"
echo ""
echo "   (Use --force only if repo has existing content to overwrite)"
echo ""
echo "3. Or if repo is empty:"
echo "   git push -u origin main"
echo ""
echo "=========================================="
