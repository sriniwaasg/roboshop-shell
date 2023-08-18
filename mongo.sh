script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "copy mongo repo"
cp mongo.repos /etc/yum.repos.d/mongo.repo

func_print_head "install mongo"
yum install mongodb-org -y

func_print_head "start mongo"
systemctl enable mongod
systemctl start mongod

func_print_head "replace ip"
sed -i -e's|127.0.0.1|0.0.0.0|'

func_print_head "restart mongo"
systemctl restart mongod






