script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

"copy mongo repo"
cp mongo.repos /etc/yum.repos.d/mongo.repo

"install mongo"
yum install mongodb-org -y

"start mongo"
systemctl enable mongod
systemctl start mongod

"replace ip"
sed -i -e's|127.0.0.1|0.0.0.0|'

"restart mongo"
systemctl restart mongod






