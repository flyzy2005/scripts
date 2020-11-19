###
#  备份环境：基于LNMP一键包：https://www.vpsgo.com/linux-install-lnmp.html
#  准备工作：新建对应的 MySQL 用户
#  文件目录：利用 auto_transfer.sh 将文件备份在 /root/backup
#  Usage: ./auto_depoly_no_db.sh
###


DATE=$(date +%Y%m%d)
BACKUP_DIR='/root/real_time_back'
if [ ! -d ${BACKUP_DIR} ]; then
  mkdir ${BACKUP_DIR}
fi
cd ${BACKUP_DIR}

backup() {
  web_name=$1
  date_tmp=${DATE}
  while [ ! -f "/root/backup/${web_name}_${date_tmp}_ALL.zip" ]
  do
    date_tmp=$(date -d "${date_tmp} 1 days ago" "+%Y%m%d")
  done
  cp /root/backup/${web_name}_${date_tmp}_ALL.zip /root/real_time_back/
  # zip & sql
  unzip ${web_name}_${date_tmp}_ALL.zip > /dev/null
  unzip ${web_name}_${date_tmp}.zip > /dev/null

  if [ ! -d "/home/wwwroot/${web_name}" ]; then
    mkdir "/home/wwwroot/${web_name}"
  fi

  # www file
  rm /home/wwwroot/${web_name}/* -rf
  cp -rf /root/real_time_back/home/wwwroot/${web_name}/* /home/wwwroot/${web_name}/
  chown -R www:www /home/wwwroot/${web_name}/
  
  # conf
  cp -rf /root/real_time_back/${web_name}.conf /usr/local/nginx/conf/vhost/

  rm /root/real_time_back/* -rf
}

backup_SSL() {
  web_name=$1
  cp /root/backup/${web_name}_${date_tmp}_ALL.zip /root/real_time_back/
  unzip ${web_name}_${date_tmp}_ALL.zip > /dev/null
  unzip ssl_${web_name}.zip > /dev/null
  if [ ! -d "/usr/local/nginx/conf/ssl/${web_name}" ]; then
    mkdir /usr/local/nginx/conf/ssl/${web_name}
    # echo /usr/local/nginx/conf/ssl/${web_name}
  fi
  
  rm /usr/local/nginx/conf/ssl/${web_name}/* -rf
  cp -rf /root/real_time_back/usr/local/nginx/conf/ssl/${web_name}/* /usr/local/nginx/conf/ssl/${web_name}/
  
  rm /root/real_time_back/* -rf
}

backup_In_All() {
        echo '-------------------------------------------'
        echo $1_START
        backup $1 $2 $3
        backup_SSL $1
        echo $1_DONE
        echo '-------------------------------------------'
}

# Sample:

# backup_In_All BLOG_NAME MYSQL_USER MYSQL_PASS

lnmp nginx restart