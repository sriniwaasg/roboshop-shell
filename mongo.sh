script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "copy mongo repos"
cp mongo.repos /etc/yum.repos.d/mongo.repo &>>log_file
func_stat_check $?

func_print_head "install mongo"
yum install mongodb-org -y &>>log_file
func_stat_check $?

func_print_head "start mongo"
systemctl enable mongod &>>log_file
systemctl start mongod &>>log_file
func_stat_check $?

func_print_head "replace config"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>log_file
func_stat_check $?

func_print_head "restart mongo"
systemctl restart mongod &>>log_file
func_stat_check $?






