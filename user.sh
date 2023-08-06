script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=user

func_nodjs



echo -e "\e[36m>>>>>>>>>>>install mongorepo<<<<<<\e[0m"
cp ${script_path}/mongo.repos /etc/yum.repos.d/mongo.repo
echo -e "\e[36m>>>>>>>>>>>install mongo<<<<<<\e[0m"
yum install mongodb-org-shell -y
echo -e "\e[36m>>>>>>>>>>>Load schema<<<<<<\e[0m"
mongo --host mongodb-dev.sriniwaasg23.online </app/schema/user.js
