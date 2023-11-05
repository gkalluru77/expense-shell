log_file="/tmp/expense.log"
color="\e[32m"

if [ -z "$1" ]; then
  echo Password input missing
  exit
fi
MYSQL_ROOT_PASSWORD=$1

status_check() {
  if [ $? -eq 0 ]; then
    echo -e "${color} SUCCESS \e[0m"
    else
      echo -e "\e[31m FAILURE \e[0m"
  fi
}

echo -e "${color} Disable node js default version \e[0m"

dnf module disable nodejs &>>$log_file
status_check

echo -e "${color} Enable node js 18 version \e[0m"
dnf module enable nodejs:18 -y &>>$log_file
status_check

echo -e "${color} Install node js 18 version \e[0m"
dnf install nodejs -y &>>$log_file
status_check

echo -e "${color} copying backend service \e[0m"
cp backend.service /etc/systemd/system/backend.service &>>$log_file
status_check

id expense &>>$log_file
if [ $? -ne 0 ]; then
  echo -e "${color} adding application user \e[0m"
  useradd expense &>>$log_file
    status_check
  fi

if [ ! -d /app ];then
  echo -e "${color} creating application directory \e[0m"
  mkdir /app &>>$log_file
 status_check
fi

echo -e "${color} Downloading application content \e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>>$log_file
status_check

echo -e "${color} extract application content \e[0m"
cd /app &>>$log_file
status_check
unzip /tmp/backend.zip  &>>$log_file
status_check

echo -e "${color} download nodejs dependencies \e[0m"
npm install &>>$log_file
status_check
echo -e "${color} install mysql client to load schema \e[0m"
dnf install mysql -y &>>$log_file
status_check

echo -e "${color} load schema  \e[0m"
mysql -h mysql-dev.gdevops.online -uroot -p${MYSQL_ROOT_PASSWORD} < /app/schema/backend.sql &>>$log_file
status_check

echo -e "${color} starting backend service \e[0m" &>>$log_file
status_check
systemctl daemon-reload
systemctl enable backend
systemctl restart backend &>>$log_file
status_check


