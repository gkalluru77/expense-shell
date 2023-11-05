source common.sh

dnf module disable mysql -y
status_check
cp mysql.repo /etc/yum.repos.d/mysql.repo

dnf install mysql-community-server -y
status_check
systemctl enable mysqld
systemctl start mysqld
status_check
mysql_secure_installation --set-root-pass ExpenseApp@1
status_check


