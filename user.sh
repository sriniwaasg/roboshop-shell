script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

"download rmp"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

"install nodejs"
yum install nodejs -y

"add application user"
useradd roboshop

"add application directory"
mkdir /app

"download app contant"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip

"extract app contant"
cd /app
unzip /tmp/user.zip

"install npm"
cd /app
npm install

"copy config file"
cp user.ser /etc/systemd/system/user.service

"restart component"
systemctl daemon-reload
systemctl enable user
systemctl start user

"copy mongo"
cp mongo.repos /etc/yum.repos.d/mongo.repo

"install mongo"
yum install mongodb-org-shell -y

"ip addres change"
mongo --host MONGODB-SERVER-IPADDRESS </app/schema/user.js






