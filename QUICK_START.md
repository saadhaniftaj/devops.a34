# Quick Start Guide

## 🚀 Quick Setup Steps

### 1. Push to GitHub
```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/saadhaniftaj/devops.a34.git
git push -u origin main
```

### 2. Configure GitHub Secrets
Go to: https://github.com/saadhaniftaj/devops.a34/settings/secrets/actions

**Minimum Required Secrets:**
- `AWS_ACCESS_KEY_ID`: Your AWS Access Key ID
- `AWS_SECRET_ACCESS_KEY`: Your AWS Secret Access Key
- `TESTING_EC2_HOST`: Your Testing EC2 IP
- `TESTING_EC2_USER`: `ubuntu`
- `TESTING_EC2_SSH_KEY`: Your .pem file content
- `STAGING_EC2_HOST`: Your Staging EC2 IP
- `STAGING_EC2_USER`: `ubuntu`
- `STAGING_EC2_SSH_KEY`: Your .pem file content
- `QA_EMAIL`: Instructor email
- `EMAIL_USERNAME`: Your Gmail
- `EMAIL_PASSWORD`: Gmail App Password

### 3. Protect Main Branch
Settings → Branches → Add rule for `main` → Require PR reviews

### 4. Test Workflow
1. Create feature branch
2. Make a change
3. Create Pull Request
4. Workflow auto-triggers!

---

## 📋 Assignment 3 Checklist

- [ ] Repository public
- [ ] Collaborators added
- [ ] Main branch protected
- [ ] EC2 instances created (Testing + Staging)
- [ ] GitHub Secrets configured
- [ ] Testing workflow works
- [ ] Staging workflow works
- [ ] Email notifications working

## 📋 Assignment 4 Checklist

- [ ] All Assignment 3 items complete
- [ ] ECR repositories created
- [ ] Dockerfiles working locally
- [ ] Docker Compose working
- [ ] Containerized workflows working
- [ ] Containers deployed on EC2

---

## 🔧 Local Testing

```bash
# Install dependencies
npm run install:all

# Run tests
npm run test:all

# Start frontend (port 3000)
npm run start:frontend

# Start backend (port 4000)
npm run start:backend

# Docker (Assignment 4)
docker-compose up --build
```

---

## 📧 Email Setup

1. Enable 2-Step Verification on Gmail
2. Generate App Password: Google Account → Security → App Passwords
3. Use 16-character password in `EMAIL_PASSWORD` secret

---

## 🆘 Troubleshooting

**Workflow fails?**
- Check Actions tab for logs
- Verify all secrets are set
- SSH into EC2 and check services

**Can't access app?**
- Check security group allows HTTP (port 80)
- Verify nginx is running: `sudo systemctl status nginx`
- Check backend: `pm2 logs` or `docker logs backend`

**Docker issues?**
- Install Docker on EC2: `sudo apt-get install docker.io docker-compose -y`
- Add user to docker group: `sudo usermod -aG docker ubuntu`

---

For detailed instructions, see [SETUP_GUIDE.md](SETUP_GUIDE.md)

