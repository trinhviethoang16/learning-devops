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
systemctl restart nginx.service docker.service

# NGINX config
cat <<EOL > /etc/nginx/sites-available/myapp.conf
server {
    listen 80;
    location / {
        proxy_pass http://127.0.0.1:3001;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
EOL
ln -s /etc/nginx/sites-available/myapp.conf /etc/nginx/sites-enabled/myapp

###
systemctl restart nginx

# Docker config
usermod -aG docker $USER
newgrp docker
systemctl restart containerd.service jenkins.service
docker pull trinhviethoang16/fe-nextjs
docker run -d -p 3001:3000 trinhviethoang16/fe-nextjs:latest