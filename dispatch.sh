script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

"install golang"
yum install golang -y

"add app user"
useradd roboshop

"add directory"
mkdir /app

"download contant"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip

"extract contant"
cd /app
unzip /tmp/dispatch.zip

"download dependencies"
cd /app
go mod init dispatch
go get
go build

"copy services"
cp dispatch.ser /etc/systemd/system/dispatch.service

"start dispatch"
systemctl daemon-reload
systemctl enable dispatch
systemctl start dispatch


