
###
#  备份环境：基于LNMP一键包：https://www.vpsgo.com/linux-install-lnmp.html
#  Usage: ./auto_transfer.sh BLOG_NAME MYSQL_USER MYSQL_PASS
###

DATE=$(date +%Y%m%d)
BLOG_NAME=$1
BLOG_DIR="/home/wwwroot/${BLOG_NAME}"
BLOG_DEFAULT_VHOST_NAME=${BLOG_NAME}
MYSQL_USER=$2
MYSQL_PASS=$3
DB=${MYSQL_USER}
BACKUP_DIR='/root/vhosts'
if [ ! -d ${BACKUP_DIR} ]; then
  mkdir ${BACKUP_DIR}
fi
cd ${BACKUP_DIR}

mysqldump -u$MYSQL_USER -p$MYSQL_PASS ${DB} > ${DB}_${DATE}.sql

echo "SQL size: $(wc -c ${DB}_${DATE}.sql | awk '{print $1}')"

zip -r ${BLOG_NAME}_${DATE}.zip ${BLOG_DIR} > /dev/null

echo "WWW size: $(wc -c ${BLOG_NAME}_${DATE}.zip | awk '{print $1}')"

zip -r ssl_${BLOG_NAME}.zip /usr/local/nginx/conf/ssl/${BLOG_DEFAULT_VHOST_NAME} > /dev/null

cp /usr/local/nginx/conf/vhost/${BLOG_DEFAULT_VHOST_NAME}.conf ${BACKUP_DIR}

zip ${BLOG_NAME}_${DATE}_ALL.zip ${BLOG_NAME}_${DATE}.zip ${DB}_${DATE}.sql ${BLOG_DEFAULT_VHOST_NAME}.conf ssl_${BLOG_NAME}.zip> /dev/null

rm -rf ${DB}_${DATE}.sql ${BLOG_NAME}_${DATE}.zip ${BLOG_DEFAULT_VHOST_NAME}.conf ssl_${BLOG_NAME}.zip

echo ${BLOG_NAME}_${DATE}_DONE