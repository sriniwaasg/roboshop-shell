script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh



func_print_head "install nginx"
yum install nginx -y

func_print_head "start nginx"
systemctl enable nginx
systemctl start nginx

func_print_head "clean nginx"
rm -rf /usr/share/nginx/html/*

func_print_head "download app contant"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

func_print_head "extract app contant"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

func_print_head "conpy config file"
/etc/nginx/default.d/roboshop.conf

func_print_head "start nginx"
start nginx
systemctl restart nginx

