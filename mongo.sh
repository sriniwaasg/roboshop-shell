script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh


cp mongo.repos /etc/yum.repos.d/mongo.repo
yum install mongodb-org -y
systemctl enable mongod
systemctl start mongod
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf
systemctl restart mongod





