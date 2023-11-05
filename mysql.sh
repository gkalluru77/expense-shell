source common.sh

if [ -z "$1" ]; then
  echo Password input missing
  exit
fi
MYSQL_ROOT_PASSWORD=$1

dnf module disable mysql -y
status_check
cp mysql.repo /etc/yum.repos.d/mysql.repo

dnf install mysql-community-server -y
status_check
systemctl enable mysqld
systemctl start mysqld
status_check
mysql_secure_installation --set-root-pass ${MYSQL_ROOT_PASSWORD}
status_check


