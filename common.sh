app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

func_print_head() {
  echo -e "\e[35m>>>>>>>>>> $1 <<<<<<<<<\e[0m"
}

func_stat_check(){
  if [ $1 -eq 0]; then
    echo -e "\e[35msucces\e[0m"
    else
    echo -e "\e[35mfailure\e[0m"
    exit 1
    fi


}
 func_schema_setup() {
  if [ "${schema_setup}" == "mongo" ]; then

  func_print_head "installmongorepo"
  cp ${script_path}/mongo.repos /etc/yum.repos.d/mongo.repo
  func_stat_check $?

  func_print_head "install mongo"
  yum install mongodb-org-shell -y
  func_stat_check $?

  func_print_head "Load schema"
  mongo --host mongodb-dev.sriniwaasg23.online </app/schema/${component}.js
  func_stat_check $?
  fi
  if [ "${schema_setup}" == "mysql" ]; then

  func_print_head "install mysql"
  yum install mysql -y
  func_stat_check $?

  func_print_head "add username pass"
  mysql -h mysql-dev.sriniwaasg23.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql
  func_stat_check $?
 fi

}
func_app_prereq(){
  func_print_head "add application user"
  useradd roboshop
  func_stat_check $?

 func_print_head "create application directory"
 rm -rf /app
 mkdir /app
 func_stat_check $?

 func_print_head "download application contant"
 curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
 func_stat_check $?

 func_print_head "extract application contant"
 cd /app
 unzip /tmp/${component}.zip
 func_stat_check $?

}
func_systemd_setup(){
  func_print_head "copy configuration"
  cp ${script_path}/${component}.ser /etc/systemd/system/${component}.service
  func_stat_check $?

  func_print_head "start ${component}"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl start ${component}
  systemctl restart ${component}
  func_stat_check $?
}
func_nodejs() {
 func_print_head "install repo"
 curl -sL https://rpm.nodesource.com/setup_lts.x | bash
 func_stat_check $?

 func_print_head "install nodejs"
 yum install nodejs -y
 func_stat_check $?

 func_app_prereq

 func_print_head "install dependency"
 npm install
 func_stat_check $?

 func_schema_setup
 func_systemd_setup



}
func_java(){
 func_print_head "install"
 yum install maven -y
 func_stat_check $?

 func_app_prereq

 func_print_head "maven dependencies"
 mvn clean package
 mv target/${component}-1.0.jar ${component}.jar
 func_stat_check $?

 func_schema_setup
 func_systemd_setup




}

