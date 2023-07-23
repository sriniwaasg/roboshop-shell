cp momgo.repos /etc/yum.repos.d/mongo.repo
yum install mongodb-org -y
systemctl enable mongod
systemctl start mongod
## chage ip 127.0.0.0 to 0.0.0.0
systemctl restart mongod
