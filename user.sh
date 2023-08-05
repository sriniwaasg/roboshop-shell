script=$(realpath "$0")

realpath $0
exit


script_path=$(dirname "$realpath")

exit

source ${script_path}/common.sh


echo -e "\e[36m>>>>>>>>>install repos<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
echo -e "\e[36m>>>>>>>>>>>install nodejs<<<<<<<\e[0m"
yum install nodejs -y
echo -e "\e[36m>>>>>>>>>>add user<<<<<<<<\e[0m"
useradd ${app_user}
echo -e "\e[36m>>>>>>>>>>add app<<<<<<<<\e[0m"
mkdir /app
echo -e "\e[36m>>>>>>>>>>down load app<<<<<<<<\e[0m"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
echo -e "\e[36m>>>>>>>>>>>unzip nodejs<<<<<<\e[0m"
cd /app
unzip /tmp/user.zip
echo -e "\e[36m>>>>>>>>>>>install repo<<<<<<\e[0m"
npm install
echo -e "\e[36m>>>>>>>>>>>config setup<<<<<<\e[0m"
cp  $script_path/user.ser /etc/systemd/system/user.service
echo -e "\e[36m>>>>>>>>>>>start user<<<<<<\e[0m"
systemctl enable user
systemctl start user
echo -e "\e[36m>>>>>>>>>>>install mongorepo<<<<<<\e[0m"
cp /home/centos/roboshop-shell/mongo.repos /etc/yum.repos.d/mongo.repo
echo -e "\e[36m>>>>>>>>>>>install mongo<<<<<<\e[0m"
yum install mongodb-org-shell -y
echo -e "\e[36m>>>>>>>>>>>Load schema<<<<<<\e[0m"
mongo --host mongodb-dev.sriniwaasg23.online </app/schema/user.js
