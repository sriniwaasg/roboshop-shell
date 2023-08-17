script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

"install repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

"install nodejs"
yum install nodejs -y

"add application user"
useradd ${app_user}

"create application directory"
mkdir /app

"down load app contant"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

"extract app contant"
cd /app
unzip /tmp/catalogue.zip

"install npm"
cd /app
npm install

"copy config file"
 cp catalogue.ser  /etc/systemd/system/catalogue.service

 "start nginx"
 systemctl daemon-reload
 systemctl enable catalogue
 systemctl start catalogue

 "copy mogno repo"
 cp mongo.repos /etc/yum.repos.d/mongo.repo

 "install mogno"
 yum install mongodb-org-shell -y

 "mongo server ip"
 mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js













