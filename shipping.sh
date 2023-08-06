script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1
if [ -z "$mysql_root_password" ]; then
  echo input mysql root passwor missing
  exit
  fi

echo -e "\e[36m>>>>>>>>>install maven<<<<<<<<<<<<\e[0m"
yum install maven -y
echo -e "\e[36m>>>>>>>>>add application user<<<<<<<<<<<<\e[0m"
useradd roboshop
echo -e "\e[36m>>>>>>>>>add application app<<<<<<<<<<<<\e[0m"
mkdir /app
echo -e "\e[36m>>>>>>>>>install application<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
echo -e "\e[36m>>>>>>>>>unzip application<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/shipping.zip
echo -e "\e[36m>>>>>>>>>clan maven<<<<<<<<<<<<\e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar
echo -e "\e[36m>>>>>>>>>copy configuration<<<<<<<<<<<<\e[0m"
cp ${script_path}/shipping.ser /etc/systemd/system/shipping.service
echo -e "\e[36m>>>>>>>>>start shipping<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl start shipping
echo -e "\e[36m>>>>>>>>>install mysql<<<<<<<<<<<<\e[0m"
yum install mysql -y
echo -e "\e[36m>>>>>>>>>add username pass<<<<<<<<<<<<\e[0m"
mysql -h mysql-dev.sriniwaasg23.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql
echo -e "\e[36m>>>>>>>>>restart<<<<<<<<<<<<\e[0m"
systemctl restart shipping



