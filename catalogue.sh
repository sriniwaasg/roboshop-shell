echo -e "\e[36m>>>>>>>>>install repos<<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
echo -e "\e[36m>>>>>>>>>install nginx<<<<<<<<<<<<<\e[0m"
yum install nodejs -y
echo -e "\e[36m>>>>>>>>>add user<<<<<<<<<<<<<\e[0m"
useradd roboshop
echo -e "\e[36m>>>>>>>>>add directory<<<<<<<<<<<<<\e[0m"
mkdir /app
echo -e "\e[36m>>>>>>>>>download catalog <<<<<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
echo -e "\e[36m>>>>>>>>>unzip catalogue<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/catalogue.zip
echo -e "\e[36m>>>>>>>>>install dependency<<<<<<<<<<<<<\e[0m"
npm install
echo -e "\e[36m>>>>>>>>>copy catalogue config<<<<<<<<<<<<<\e[0m"
cp catalogue.ser /etc/systemd/system/catalogue.service
echo -e "\e[36m>>>>>>>>>start catalogue<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue
echo -e "\e[36m>>>>>>>>>mongo repos<<<<<<<<<<<<<\e[0m"
copy mongo.reops /etc/yum.repos.d/mongo.repo
echo -e "\e[36m>>>>>>>>>intall mongoclient<<<<<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y
echo -e "\e[36m>>>>>>>>>enable mongod<<<<<<<<<<<<<\e[0m"
mongo --host mongodb-dev.sriniwaasg23.online </app/schema/catalogue.js


