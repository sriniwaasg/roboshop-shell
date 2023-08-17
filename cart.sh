script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

"downloadrpm"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

"install nodejs"
yum install nodejs -y

"add app user"
useradd ${app_user}

"create app directory"
mkdir /app

"down app contant"
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip

"extract app contant"
cd /app
unzip /tmp/cart.zip

"copy config file"
cp cart.ser /etc/systemd/system/cart.service

"start usr"
systemctl daemon-reload
systemctl enable cart
systemctl start cart





