script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

"Rabbitmq repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

"configure rabbitmq"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

"install rabbitmq"
yum install rabbitmq-server -y

"restart rabbitmq"
systemctl enable rabbitmq-server
systemctl start rabbitmq-server

"add username and pass"
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"


