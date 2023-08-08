app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
log_file=/tmp/roboshop.log

func_print_head() {
  echo -e "\e[35m>>>>>>>>>> $1 <<<<<<<<<\e[0m"
  echo -e "\e[35m>>>>>>>>>> $1 <<<<<<<<<\e[0m" &>>$log_file
}

func_stat_check(){
  if [ $1 -eq 0 ]; then
    echo -e "\e[35msucces\e[0m"
    else
    echo -e "\e[35mfailure\e[0m"
    echo "refer the log file /tmp/roboshop.log for more information"
    exit 1
    fi

}
 func_schema_setup() {
  if [ "${schema_setup}" == "mongo" ]; then

  func_print_head "installmongorepo"
  cp ${script_path}/mongo.repos /etc/yum.repos.d/mongo.repo &>>$log_file
  func_stat_check $?

  func_print_head "install mongo"
  yum install mongodb-org-shell -y &>>$log_file
  func_stat_check $?

  func_print_head "Load schema"
  mongo --host mongodb-dev.sriniwaasg23.online </app/schema/${component}.js &>>$log_file
  func_stat_check $?
  fi
  if [ "${schema_setup}" == "mysql" ]; then

  func_print_head "install mysql"
  yum install mysql -y &>>$log_file
  func_stat_check $?

  func_print_head "add username pass"
  mysql -h mysql-dev.sriniwaasg23.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql &>>$log_file
  func_stat_check $?
 fi

}
func_app_prereq(){
  func_print_head "add application user"
  id ${app_user} &>>$log_file
  if [ $? -ne 0 ]; then
  useradd ${app_user} &>>$log_file
  fi
  func_stat_check $?

 func_print_head "create application directory"
 rm -rf /app
 mkdir /app &>>$log_file
 func_stat_check $?

 func_print_head "download application contant"
 curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
 func_stat_check $?

 func_print_head "extract application contant"
 cd /app
 unzip /tmp/${component}.zip &>>$log_file
 func_stat_check $?

}
func_systemd_setup(){
  func_print_head "copy configuration"
  cp ${script_path}/${component}.ser /etc/systemd/system/${component}.service &>>$log_file
  func_stat_check $?

  func_print_head "start ${component}"
  systemctl daemon-reload &>>$log_file
  systemctl enable ${component} &>>$log_file
  systemctl start ${component} &>>$log_file
  systemctl restart ${component} &>>$log_file
  func_stat_check $?
}
func_nodejs() {
 func_print_head "install repo"
 curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
 func_stat_check $?

 func_print_head "install nodejs"
 yum install nodejs -y &>>$log_file
 func_stat_check $?

 func_app_prereq

 func_print_head "install dependency"
 npm install &>>$log_file
 func_stat_check $?

 func_schema_setup
 func_systemd_setup



}
func_java(){
 func_print_head "install"
 yum install maven -y &>>$log_file
 func_stat_check $?

 func_app_prereq

 func_print_head "maven dependencies"
 mvn clean package &>>$log_file
 mv target/${component}-1.0.jar ${component}.jar &>>$log_file
 func_stat_check $?

 func_schema_setup
 func_systemd_setup




}

func_python(){
  func_print_head "install python"
  yum install python36 gcc python3-devel -y &>>$log_file
  func_stat_check $?

  func_app_prereq

  func_print_head "install dependecies"
  pip3.6 install -r requirements.txt &>>$log_file
  func_stat_check $?

  func_print_head "replace password"
  sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|" ${script_path}/payment.ser &>>$log_file
  func_stat_check $?

 func_systemd_setup

}
func_dispatch(){
   func_print_head "install goglan"
  yum install golang -y &>>$log_file
  func_stat_check $?

  func_app_prereq

 func_print_head "get buld dispatch"
  go mod init dispatch &>>$log_file
  go get &>>$log_file
  go build &>>$log_file
  func_stat_check $?


 func_systemd_setup
}