# Docker, NGINX, Java, ...
apt-get update
apt-get install -y nginx net-tools docker docker-compose fontconfig openjdk-17-jre-headless

# Jenkins config
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# install Jenkins
apt-get update
apt-get install -y jenkins

###
systemctl restart docker.service

# Development enviroment config
cat <<EOL > /etc/nginx/sites-available/myapp-dev.conf
server {
    listen 3500;
    location / {
        proxy_pass http://127.0.0.1:3500;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
EOL
ln -s /etc/nginx/sites-available/myapp-dev.conf /etc/nginx/sites-enabled/

# Production enviroment config
cat <<EOL > /etc/nginx/sites-available/myapp-prod.conf
server {
    listen 4000;
    location / {
        proxy_pass http://127.0.0.1:4000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
EOL
ln -s /etc/nginx/sites-available/myapp-prod.conf /etc/nginx/sites-enabled/

###
systemctl restart nginx

# Docker config
usermod -aG docker $USER
usermod -aG docker jenkins
newgrp docker
systemctl restart containerd.service jenkins.service
docker stop frontend
docker rm frontend

# Development enviroment
docker pull trinhviethoang16/frontend:develop
docker run -d -p 3500:3000 trinhviethoang16/frontend:develop

# Production environment
docker pull trinhviethoang16/frontend:latest
docker run -d -p 4000:3000 trinhviethoang16/frontend:latest