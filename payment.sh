script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

if [ -z "$rabbitmq_appuser_password" ];then
  echo input rabbitmq appuser password missing
  exit
  fi

component=payment
func_python









