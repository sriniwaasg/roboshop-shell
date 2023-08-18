
"install python"
yum install python36 gcc python3-devel -y

"add app user"
useradd roboshop

"add app directory"
mkdir /app
"download app contant"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip

script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh


func_print_head "extract app contant"
cd /app
unzip /tmp/payment.zip

func_print_head "download dependencies"
cd /app
pip3.6 install -r requirements.txt

func_print_head "copy services"
cp payment.sh /etc/systemd/system/payment.service

func_print_head "restart payment"
systemctl daemon-reload
systemctl enable payment
systemctl start payment







