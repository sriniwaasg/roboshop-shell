script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh


"disable mysql"
yum module disable mysql -y

"copy mysql repos"
cp mysql.repo /etc/yum.repos.d/mysql.repo

"install mysql"
yum install mysql-community-server -y

"start mysql"
systemctl enable mysqld
systemctl start mysqld

"add password"
mysql_secure_installation --set-root-pass RoboShop@1

mysql -uroot -pRoboShop@1
