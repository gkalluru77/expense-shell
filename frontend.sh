echo -e "\e[35m Installing Nginx \e[0m"
dnf install nginx -y

echo -e "\e[35m Copying Expence config file \e[0m"
cp expense.conf /etc/nginx/default.d/expense.conf

echo -e "\e[35m removing old content in Nginx \e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[35m Down loading the Frontend Application Code \e[0m"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[35m Extracting the Frontend application code \e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[35m starting Nginx \e[0m"
systemctl enable nginx
systemctl restart nginx









