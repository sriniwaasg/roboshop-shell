script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh


func_print_head "install golang"
yum install golang -y

func_print_head "add app user"
useradd roboshop

func_print_head "add directory"
mkdir /app

func_print_head "download contant"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip

func_print_head "extract contant"
cd /app
unzip /tmp/dispatch.zip

func_print_head "download dependencies"
cd /app
go mod init dispatch
go get
go build

func_print_head "copy services"
cp dispatch.ser /etc/systemd/system/dispatch.service

func_print_head "start dispatch"
systemctl daemon-reload
systemctl enable dispatch
systemctl start dispatch


