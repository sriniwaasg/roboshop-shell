app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
log_file=/tmp/roboshop.log

func_print_head(){
  echo -e "\e[35m>>>>>>>>>>$1<<<<<<<<<<<\e[0m"
  echo -e "\e[35m>>>>>>>>>>$1<<<<<<<<<<<\e[0m" &>>$log_file

}

func_stat_check(){
  if [ $1 -eq 0]; then
    echo -e "\e[32msuccess\e[0m"
    else
    echo -e "\e[31mfailure\e[0m"
    echo "refer the log file  /tmp/roboshop.log for more information"
    exit 1
    fi

}
func_schema_setup(){
  if [ "${schema_setup}" == "mongo" ]; then

  func_print_head  "install mogno repo"
   cp ${script_path}/mongo.repos /etc/yum.repos.d/mongo.repo  &>>$log_file
   func_stat_check $?

  func_print_head "install mogno"
   yum install mongodb-org-shell -y &>>$log_file
   func_stat_check $?

  func_print_head "Load schema"
   mongo --host mongodb-dev.sriniwaasg23.online </app/schema/catalogue.js &>>$log_file
   func_stat_check $?
   fi
   if [ "${schema_setup}" == "mysql" ]; then

   func_print_head "install mysql"
    yum install mysql -y &>>$log_file
    func_stat_check $?

   func_print_head "load schema"
    mysql -h mysql-dev.sriniwaasg23.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql &>>$log_file
    func_stat_check $?
    fi

}
func_app_prereq(){
  func_print_head "add application user"
  id ${app_user} &>>$log_file
  if [ $? -ne 0 ]; then
  useradd ${app_user}  &>>$log_file
  fi
  func_stat_check $?


  func_print_head "create application directory"
  rm -rf /app
  mkdir /app &>>$log_file
  func_stat_check $?

  func_print_head "down load app contant"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
  func_stat_check $?

  func_print_head "extract app contant"
  cd /app
  unzip /tmp/${component}.zip &>>$log_file
  func_stat_check $?
}

func_systemd_setup(){
  func_print_head "copy config file"
   cp  ${script_path}/${component}.ser  /etc/systemd/system/${component}.service &>>$log_file
   func_stat_check $?

   func_print_head "start ${component}"
   systemctl daemon-reload  &>>$log_file
   systemctl enable ${component} &>>$log_file
   systemctl start ${component} &>>$log_file
   func_stat_check $?

}

func_nodejs(){
func_print_head "install Nodejs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
func_stat_check $?

func_print_head "install nodejs"
yum install nodejs -y &>>$log_file
func_stat_check $?

func_app_prereq

func_print_head "install npm"
cd /app
npm install &>>$log_file
func_stat_check $?

func_schema_setup
func_systemd_setup



}