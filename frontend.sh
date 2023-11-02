echo -e "\e[35m Installing Nginx \e[0m"
dnf install nginx -y &>>/temp/expense.log

echo -e "\e[32m Copying Expence config file \e[0m"
cp expense.conf /etc/nginx/default.d/expense.conf &>>/temp/expense.log

echo -e "\e[33m removing old content in Nginx \e[0m"
rm -rf /usr/share/nginx/html/* &>>/temp/expense.log

echo -e "\e[34m Down loading the Frontend Application Code \e[0m"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip &>>/temp/expense.log

echo -e "\e[35m Extracting the Frontend application code \e[0m"
cd /usr/share/nginx/html &>>/temp/expense.log
unzip /tmp/frontend.zip &>>/temp/expense.log

echo -e "\e[36m starting Nginx \e[0m"
systemctl enable nginx &>>/temp/expense.log
systemctl restart nginx &>>/temp/expense.log









