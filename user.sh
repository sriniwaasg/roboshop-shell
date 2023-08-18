script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=user
schema_setup=mongo

func_print_head "download rmp"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

func_print_head "install nodejs"
yum install nodejs -y

func_print_head "add application user"
useradd roboshop

func_print_head "add application directory"
mkdir /app

func_print_head "download app contant"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip

func_print_head "extract app contant"
cd /app
unzip /tmp/user.zip

func_print_head "install npm"
cd /app
npm install

func_print_head "copy config file"
cp user.ser /etc/systemd/system/user.service

func_print_head "restart component"
systemctl daemon-reload
systemctl enable user
systemctl start user

"copy mongo"
cp mongo.repos /etc/yum.repos.d/mongo.repo

"install mongo"
yum install mongodb-org-shell -y

"ip addres change"
mongo --host MONGODB-SERVER-IPADDRESS </app/schema/user.js






