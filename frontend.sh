script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh



"install nginx"
yum install nginx -y

"start nginx"
systemctl enable nginx
systemctl start nginx

"clean nginx"
rm -rf /usr/share/nginx/html/*

"download app contant"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

"extract app contant"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

"conpy config file"
/etc/nginx/default.d/roboshop.conf

"start nginx"
start nginx
systemctl restart nginx

