script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh


"install redis rpm"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

"install packege"
yum module enable redis:remi-6.2 -y

"install redis"
yum install redis -y

"repalce ip"
 sed -i -e 's|127.0.0.1|0.0.0.0|'

 "restart redis"
 systemctl enable redis
 systemctl start redis

