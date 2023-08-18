script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "copy mongo repo"
cp mongo.repos /etc/yum.repos.d/mongo.repo &>>$log_file
func_stat_check $?

func_print_head "install mongo"
yum install mongodb-org -y &>>$log_file
func_stat_check $?

func_print_head "replace ip"
sed -i -e 's|127.0.0.1|0.0.0.0|' &>>$log_file
func_stat_check $?

func_print_head "restart mongo"
systemctl enable mongod &>>$log_file
systemctl restart mongod &>>$log_file
func_stat_check $?






