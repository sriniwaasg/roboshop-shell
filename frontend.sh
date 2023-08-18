script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh



func_print_head "install nginx"
yum install nginx -y &>>$log_file
func_stat_check $?

func_print_head "clean nginx"
rm -rf /usr/share/nginx/html/* &>>$log_file
func_stat_check $?

func_print_head "copy config file"
cp frontend.conf /etc/nginx/default.d/roboshop.conf &>>$log_file
func_stat_check $?

func_print_head "download app contant"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
func_stat_check $?

func_print_head "extract app contant"
cd /usr/share/nginx/html &>>$log_file
unzip /tmp/frontend.zip &>>$log_file
func_stat_check $?

func_print_head "start nginx"
systemctl enable nginx &>>$log_file
systemctl restart nginx &>>$log_file
func_stat_check $?

