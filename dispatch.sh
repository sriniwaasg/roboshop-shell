script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>>>install goglan<<<<<<<<\e[0m"
yum install golang -y
echo -e "\e[36m>>>>>>>>>>add user<<<<<<<<\e[0m"
useradd roboshop
echo -e "\e[36m>>>>>>>>>>add app user<<<<<<<<\e[0m"
mkdir /app
echo -e "\e[36m>>>>>>>>>>download config <<<<<<<<\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
echo -e "\e[36m>>>>>>>>>>unzip<<<<<<<<\e[0m"
cd /app
unzip /tmp/dispatch.zip
echo -e "\e[36m>>>>>>>>>> get buld dispatch<<<<<<<<\e[0m"
go mod init dispatch
go get
go build
echo -e "\e[36m>>>>>>>>>>copy config file <<<<<<<<\e[0m"
cp ${script_path}/dispatch.ser /etc/systemd/system/dispatch.service
echo -e "\e[36m>>>>>>>>>>reload dispatch<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable dispatch
systemctl start dispatch


