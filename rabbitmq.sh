script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "$rabbitmq_appuser_password" ];then
  echo input rabbitmq appuser password missing
  exit
  fi


func_print_head "Rabbitmq repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

func_print_head "configure rabbitmq"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

func_print_head "install rabbitmq"
yum install rabbitmq-server -y

func_print_head "restart rabbitmq"
systemctl enable rabbitmq-server
systemctl start rabbitmq-server

func_print_head "add username and pass"
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"


