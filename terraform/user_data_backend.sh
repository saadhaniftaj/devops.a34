#!/bin/bash
set -e

exec > >(tee /var/log/user-data.log)
exec 2>&1

echo "Starting backend server setup..."

apt-get update -y
apt-get upgrade -y

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

export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< 'mysql-server mysql-server/root_password password RootPassword123!'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password RootPassword123!'
apt-get install -y mysql-server
systemctl enable mysql
systemctl start mysql

mysql -u root -pRootPassword123! << 'MYSQL_EOF'
CREATE DATABASE IF NOT EXISTS cs423_app;
CREATE USER IF NOT EXISTS 'appuser'@'%' IDENTIFIED BY 'AppPassword123!';
GRANT ALL PRIVILEGES ON cs423_app.* TO 'appuser'@'%';
FLUSH PRIVILEGES;
MYSQL_EOF

sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql

mkdir -p /opt/scripts
cat > /opt/scripts/pull-and-deploy.sh << 'SCRIPT_EOF'
#!/bin/bash
set -e
AWS_REGION="us-east-1"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
BACKEND_REPO="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/cs423-backend"

aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

docker pull ${BACKEND_REPO}:latest || true

docker stop backend || true
docker rm backend || true

docker run -d --name backend --restart unless-stopped -p 5000:5000 \
    -e DB_HOST=172.17.0.1 \
    -e DB_USER=appuser \
    -e DB_PASSWORD=AppPassword123! \
    -e DB_NAME=cs423_app \
    ${BACKEND_REPO}:latest || true
SCRIPT_EOF

chmod +x /opt/scripts/pull-and-deploy.sh
(crontab -l 2>/dev/null; echo "*/5 * * * * /opt/scripts/pull-and-deploy.sh >> /var/log/auto-deploy.log 2>&1") | crontab -
/opt/scripts/pull-and-deploy.sh || true

apt-get install -y nginx
systemctl enable nginx
systemctl start nginx

echo "Backend server setup complete"
