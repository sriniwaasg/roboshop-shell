app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

print_head() {
  echo -e "\e[35m>>>>>>>>>> $1 <<<<<<<<<\e[0m"
}

func_nodejs() {
print_head "install repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
print_head "install nodejs"
yum install nodejs -y
print_head "add user"
useradd roboshop
print_head "add app"
rm -rf /app
mkdir /app
print_head "download contat"
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
print_head "unzip contant"
cd /app
unzip /tmp/${component}.zip
print_head "install dependency"
npm install
print_head "cart config"
cp ${script_path}/${component}.ser  /etc/systemd/system/${component}.service
print_head "start cart"
systemctl daemon-reload
systemctl enable ${component}
systemctl start ${component}

}


