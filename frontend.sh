script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

yum install nginx -y
systemctl enable nginx
systemctl start nginx
cp frontend.conf /etc/nginx/default.d/roboshop.conf
rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
systemctl restart nginx

