log_file="/tmp/expense.log"
color="\e[32m"

echo -e "${color} Disable node js default version \e[0m"

dnf module disable nodejs &>>$log_file
if [ $? -eq 0 ]; then
  echo -e "${color} SUCCESS \e[0m"
  else
    echo -e "\e[31m FAILURE \e[0m"
fi

echo -e "${color} Enable node js 18 version \e[0m"
dnf module enable nodejs:18 -y &>>$log_file
if [ $? -eq 0 ]; then
  echo -e "${color} SUCCESS \e[0m"
  else
    echo -e "\e[31m FAILURE \e[0m"
fi

echo -e "${color} Install node js 18 version \e[0m"
dnf install nodejs -y &>>$log_file
if [ $? -eq 0 ]; then
  echo -e "${color} SUCCESS \e[0m"
  else
    echo -e "\e[31m FAILURE \e[0m"
fi

echo -e "${color} copying backend service \e[0m"
cp backend.service /etc/systemd/system/backend.service &>>$log_file
if [ $? -eq 0 ]; then
  echo -e "${color} SUCCESS \e[0m"
  else
    echo -e "\e[31m FAILURE \e[0m"
fi

id expense &>>$log_file
if [ $? -ne 0 ]; then
  echo -e "${color} adding application user \e[0m"
  useradd expense &>>$log_file
    if [ $? -eq 0 ]; then
      echo -e "${color} SUCCESS \e[0m"
      else
        echo -e "\e[31m FAILURE \e[0m"
    fi
  fi

if [ ! -d /app ];then
  echo -e "${color} creating application directory \e[0m"
  mkdir /app &>>$log_file
  if [ $? -eq 0 ]; then
    echo -e "${color} SUCCESS \e[0m"
    else
      echo -e "\e[31m FAILURE \e[0m"
  fi
fi

echo -e "${color} Downloading application content \e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>>$log_file
if [ $? -eq 0 ]; then
  echo -e "${color} SUCCESS \e[0m"
  else
    echo -e "\e[31m FAILURE \e[0m"
fi

echo -e "${color} extract application content \e[0m"
cd /app &>>$log_file
if [ $? -eq 0 ]; then
  echo -e "${color} SUCCESS \e[0m"
  else
    echo -e "\e[31m FAILURE \e[0m"
fi
unzip /tmp/backend.zip  &>>$log_file
if [ $? -eq 0 ]; then
  echo -e "${color} SUCCESS \e[0m"
  else
    echo -e "\e[31m FAILURE \e[0m"
fi

echo -e "${color} download nodejs dependencies \e[0m"
npm install &>>$log_file
if [ $? -eq 0 ]; then
  echo -e "${color} SUCCESS \e[0m"
  else
    echo -e "\e[31m FAILURE \e[0m"
fi

echo -e "${color} install mysql client to load schema \e[0m"
dnf install mysql -y &>>$log_file
 if [ $? -eq 0 ]; then
   echo -e "${color} SUCCESS \e[0m"
   else
     echo -e "\e[31m FAILURE \e[0m"
 fi

echo -e "${color} load schema  \e[0m"
mysql -h mysql-dev.gdevops.online -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$log_file
if [ $? -eq 0 ]; then
  echo -e "${color} SUCCESS \e[0m"
  else
    echo -e "\e[31m FAILURE \e[0m"
fi

echo -e "${color} starting backend service \e[0m" &>>$log_file
if [ $? -eq 0 ]; then
  echo -e "${color} SUCCESS \e[0m"
  else
    echo -e "\e[31m FAILURE \e[0m"
fi
systemctl daemon-reload
systemctl enable backend
systemctl restart backend &>>$log_file
if [ $? -eq 0 ]; then
  echo -e "${color} SUCCESS \e[0m"
  else
    echo -e "\e[31m FAILURE \e[0m"
fi


