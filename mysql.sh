script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "mysql_root_password"]; then
  echo input mysql root password missing
  exit
  fi



func_print_head "disable mysql"
yum module disable mysql -y

func_print_head "copy mysql repos"
cp mysql.repo /etc/yum.repos.d/mysql.repo

func_print_head "install mysql"
yum install mysql-community-server -y

func_print_head "start mysql"
systemctl enable mysqld
systemctl start mysqld

func_print_head "add password"
mysql_secure_installation --set-root-pass RoboShop@1

mysql -uroot -pRoboShop@1
