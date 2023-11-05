log_file="/tmp/expense.log"
color="\e[32m"

status_check() {
  if [ $? -eq 0 ]; then
    echo -e "${color} SUCCESS \e[0m"
    else
      echo -e "\e[31m FAILURE \e[0m"
      exit 0
  fi
}