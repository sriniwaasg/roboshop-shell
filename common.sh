app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
log_file=/tmp/roboshop.log

func_print_head(){
  echo -e "\e[35m>>>>>>>>>>$1<<<<<<<<<<<\e[0m"
  echo -e "\e[35m>>>>>>>>>>$1<<<<<<<<<<<\e[0m" &>>$log_file

}

func_stat_check(){
  if [ $1 -eq 0] ; then
    echo -e "\e[34msuccess\e[0m"
    else
    echo -e "\e[34mfailure\e[0m"
    echo "refer the log file  /tmp/roboshop.log for more information"
    exit 1
    fi

}