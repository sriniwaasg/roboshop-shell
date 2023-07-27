echo -e "\e[36m>>>>>>>>>>install repo<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
echo -e "\e[36m>>>>>>>>>>install nodejs<<<<<<<<<\e[0m"
yum install nodejs -y
echo -e "\e[36m>>>>>>>>>>add user<<<<<<<<<\e[0m"
useradd roboshop
echo -e "\e[36m>>>>>>>>>>add app<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app
echo -e "\e[36m>>>>>>>>>>download contat<<<<<<<<<\e[0m"
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
echo -e "\e[36m>>>>>>>>>>unzip contant<<<<<<<<<\e[0m"
cd /app
unzip /tmp/cart.zip
echo -e "\e[36m>>>>>>>>>>install dependency<<<<<<<<<\e[0m"
npm install
echo -e "\e[36m>>>>>>>>>>cart config<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/cart.ser  /etc/systemd/system/cart.service
echo -e "\e[36m>>>>>>>>>>start cart<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable cart
systemctl start cart

