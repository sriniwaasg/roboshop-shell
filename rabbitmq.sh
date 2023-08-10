script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_user_password=$1

if [ -z "$rabbitmq_user_password" ]; then
  echo input roboshop appuser password missing
  exit
  fi

func_print_head "install rabbitmq package"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$log_file
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$log_file
func_stat_check $?

func_print_head "install rabbitmq"
yum install rabbitmq-server -y &>>$log_file
func_stat_check $?

func_print_head "enable rabbitmq"
systemctl enable rabbitmq-server &>>$log_file
systemctl start rabbitmq-server &>>$log_file
func_stat_check $?

func_print_head "add user"
rabbitmqctl add_user roboshop ${rabbitmq_user_password}  &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
func_stat_check $?


