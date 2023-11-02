echo -e "\e[35m Installing Nginx \e[0m"
dnf install nginx -y &>>/tmp/expense.log

echo -e "\e[32m Copying Expence config file \e[0m"
cp expense.conf /etc/nginx/default.d/expense.conf &>>/tmp/expense.log

echo -e "\e[33m removing old content in Nginx \e[0m"
rm -rf /usr/share/nginx/html/* &>>/tmp/expense.log

echo -e "\e[34m Down loading the Frontend Application Code \e[0m"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip &>>/tmp/expense.log

echo -e "\e[35m Extracting the Frontend application code \e[0m"
cd /usr/share/nginx/html &>>/tmp/expense.log
unzip /tmp/frontend.zip &>>/tmp/expense.log

echo -e "\e[36m starting Nginx \e[0m"
systemctl enable nginx &>>/tmp/expense.log
systemctl restart nginx &>>/tmp/expense.log









