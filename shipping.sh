script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]; then
  echo  input mysql root password missing
  exit
  fi

component=shipping
schema_setup=mysql



func_print_head "install maven"
yum install maven -y

func_print_head "add application user"
useradd roboshop

func_print_head "add application directory"
mkdir /app

func_print_head "download app contant"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip

func_print_head "extract app contant"
cd /app
unzip /tmp/shipping.zip

func_print_head "clean packege"
cd /app
mvn clean package
mv target/shipping-1.0.jar shipping.jar

func_print_head "copy services"
cp shipping.ser /etc/systemd/system/shipping.service

func_print_head "start services"
systemctl daemon-reload
systemctl enable shipping
systemctl start shipping
systemctl restart shipping


