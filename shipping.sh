script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

"install maven"
yum install maven -y

"add application user"
useradd roboshop

"add application directory"
mkdir /app

"download app contant"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip

"extract app contant"
cd /app
unzip /tmp/shipping.zip

"clean packege"
cd /app
mvn clean package
mv target/shipping-1.0.jar shipping.jar

"copy services"
cp shipping.ser /etc/systemd/system/shipping.service

"start services"
systemctl daemon-reload
systemctl enable shipping
systemctl start shipping
systemctl restart shipping


"install mysql"
yum install mysql -y

"load schema"
mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/schema/shipping.sql
