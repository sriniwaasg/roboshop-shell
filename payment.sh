script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

rabbitmq_appuser_password=$1
echo -e "\e[36m>>>>>>>>install python<<<<<<<<<<\e[0m"
yum install python36 gcc python3-devel -y
echo -e "\e[36m>>>>>>>>add user<<<<<<<<<<\e[0m"
useradd roboshop
echo -e "\e[36m>>>>>>>>creat directory<<<<<<<<<<\e[0m"
rm -f app
mkdir /app
echo -e "\e[36m>>>>>>>>install applicaton <<<<<<<<<<\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
echo -e "\e[36m>>>>>>>>unzip application<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/payment.zip
pip3.6 install -r requirements.txt
echo -e "\e[36m>>>>>>>>copy config file<<<<<<<<<<\e[0m"
sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|" ${script_path}/payment.ser
cp ${script_path}/payment.ser /etc/systemd/system/payment.service
echo -e "\e[36m>>>>>>>>start payment<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable payment
systemctl start payment




