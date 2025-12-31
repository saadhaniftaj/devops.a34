#!/bin/bash
set -e

exec > >(tee /var/log/user-data.log)
exec 2>&1

echo "Starting web server setup..."

apt-get update -y
apt-get upgrade -y

apt-get install -y apache2
systemctl enable apache2
systemctl start apache2

cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>CS423 Assignment 4</title>
    <style>
        body { font-family: Arial; max-width: 800px; margin: 50px auto; padding: 20px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .container { background: rgba(255,255,255,0.1); padding: 30px; border-radius: 10px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>CS423 DevOps Assignment 4</h1>
        <h2>Web Server Running</h2>
        <p>Apache + Docker + AWS CLI configured</p>
    </div>
</body>
</html>
EOF

systemctl restart apache2

apt-get install -y ca-certificates curl gnupg lsb-release
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
apt-get install -y unzip
unzip awscliv2.zip
./aws/install
rm -rf aws awscliv2.zip

aws configure set default.region us-east-1
aws configure set default.output json

mkdir -p /opt/scripts
cat > /opt/scripts/pull-and-deploy.sh << 'SCRIPT_EOF'
#!/bin/bash
set -e
AWS_REGION="us-east-1"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
FRONTEND_REPO="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/cs423-frontend"
BACKEND_REPO="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/cs423-backend"

aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

docker pull ${FRONTEND_REPO}:latest || true
docker pull ${BACKEND_REPO}:latest || true

docker stop frontend backend || true
docker rm frontend backend || true

docker run -d --name frontend --restart unless-stopped -p 3000:80 ${FRONTEND_REPO}:latest || true
docker run -d --name backend --restart unless-stopped -p 5000:5000 ${BACKEND_REPO}:latest || true
SCRIPT_EOF

chmod +x /opt/scripts/pull-and-deploy.sh
(crontab -l 2>/dev/null; echo "*/5 * * * * /opt/scripts/pull-and-deploy.sh >> /var/log/auto-deploy.log 2>&1") | crontab -
/opt/scripts/pull-and-deploy.sh || true

echo "Web server setup complete"
