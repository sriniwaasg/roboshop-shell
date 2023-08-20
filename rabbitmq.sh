script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "$rabbitmq_appuser_password" ]; then
  echo input rabbitmq appuser password missing
  exit
  fi


func_print_head "Rabbitmq repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$log_file
func_stat_check $?

func_print_head "configure rabbitmq"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$log_file
func_stat_check $?

func_print_head "install erlang & rabbitmq"
yum install erlang rabbitmq-server -y &>>$log_file
func_stat_check $?

func_print_head "restart rabbitmq"
systemctl enable rabbitmq-server &>>$log_file
systemctl start rabbitmq-server &>>$log_file
func_stat_check $?

func_print_head "add username and pass"
rabbitmqctl add_user roboshop ${rabbitmq_appuser_password}  &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>$log_file
func_stat_check $?


