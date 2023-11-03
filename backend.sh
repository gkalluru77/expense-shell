log_file="/tmp/expense.log"
color="\e[31m"

echo -e "${color} Disable node js default version \e[0m"
dnf module disable nodejs &>>$log_file
 echo $?

echo -e "${color} Enable node js 18 version \e[0m"
dnf module enable nodejs:18 -y &>>$log_file
 echo $?

echo -e "${color} Install node js 18 version \e[0m"
dnf install nodejs -y &>>$log_file
 echo $?

echo -e "${color} copying backend service \e[0m"
cp backend.service /etc/systemd/system/backend.service &>>$log_file
 echo $?

echo -e "${color} adding application user \e[0m"
useradd expense &>>$log_file
 echo $?

echo -e "${color} creating application directory \e[0m"
mkdir /app &>>$log_file
 echo $?

echo -e "${color} Downloading application content \e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>>$log_file
 echo $?

echo -e "${color} extract application content \e[0m"
cd /app &>>$log_file
 echo $?
unzip /tmp/backend.zip  &>>$log_file
 echo $?

echo -e "${color} download nodejs dependencies \e[0m"
npm install &>>$log_file
 echo $?

echo -e "${color} install mysql client to load schema \e[0m"
dnf install mysql -y &>>$log_file
 echo $?

echo -e "${color} load schema  \e[0m"
mysql -h mysql-dev.gdevops.online -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$log_file
 echo $?

echo -e "${color} starting backend service \e[0m" &>>$log_file
 echo $?
systemctl daemon-reload
systemctl enable backend
systemctl restart backend &>>$log_file
echo $?

