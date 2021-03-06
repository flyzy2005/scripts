###
#  备份环境：基于LNMP一键包：https://www.vpsgo.com/linux-install-lnmp.html
#  准备工作：新建对应的 MySQL 用户
#  Usage: ./online.sh 可结合 crontab 实现自动上线：https://www.vpsgo.com/linux-crontab.html
###

DATE=$(date +%Y%m%d)
BACKUP_DIR='/root/real_time_back'
if [ ! -d ${BACKUP_DIR} ]; then
  mkdir ${BACKUP_DIR}
fi
cd ${BACKUP_DIR}

backup() {
	web_name=$1
	db_name=$2
	db_passwd=$3
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

  # mysql file
  mysql -u${db_name} -p${db_passwd} ${db_name} < ${db_name}_${date_tmp}.sql

  rm /root/real_time_back/* -rf
}

backup_SSL() {
	web_name=$1
	date_tmp=${DATE}
	while [ ! -f "/root/backup/${web_name}_${date_tmp}_ALL.zip" ]
  do
    date_tmp=$(date -d "${date_tmp} 1 days ago" "+%Y%m%d")
  done
	cp /root/backup/${web_name}_${date_tmp}_ALL.zip /root/real_time_back/
	unzip ${web_name}_${date_tmp}_ALL.zip > /dev/null
  unzip ssl_${web_name}.zip > /dev/null
  if [ ! -d "/usr/local/nginx/conf/ssl/${web_name}" ]; then
  	mkdir /usr/local/nginx/conf/ssl/${web_name}
  	echo /usr/local/nginx/conf/ssl/${web_name}
  fi
  cp -rf /root/real_time_back/usr/local/nginx/conf/ssl/${web_name}/* /usr/local/nginx/conf/ssl/${web_name}/

  rm /root/real_time_back/* -rf
}

# Sample:

# backup www.vpsgo.com test test
# backup_GGC_SSL www.vpsgo.com
# echo VPSGO_${DATE}_ONLINE


lnmp nginx restart

# clear
rm -rf /root/real_time_back/*