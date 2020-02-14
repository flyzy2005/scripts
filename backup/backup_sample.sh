###
#  备份环境：基于LNMP一键包：https://www.vpsgo.com/linux-install-lnmp.html
#  准备工作：在备份服务器添加 SSH Key
#  Usage: 修改对应的变量后，直接运行
#  详细介绍：https://www.vpsgo.com/rsync-tutorials.html
###

DATE=$(date +%Y%m%d)
BLOG_NAME='www.vpsgo.com'
BLOG_DIR="/home/wwwroot/${BLOG_NAME}"
BLOG_DEFAULT_VHOST_NAME=${BLOG_NAME}
MYSQL_USER='youruser'
MYSQL_PASS='yourpassword'
DB=${MYSQL_USER}
BACKUP_DIR='/root/backup'
BACKUP_IP_DEST='1.1.1.1'
BACKUP_DIR_DEST='/root/backup'
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

zip ${BLOG_NAME}_${DATE}_ALL.zip ${BLOG_NAME}_${DATE}.zip ${DB}_${DATE}.sql ${BLOG_DEFAULT_VHOST_NAME}.conf ssl_${BLOG_NAME}.zip > /dev/null

rsync -avP ${BLOG_NAME}_${DATE}_ALL.zip root@${BACKUP_IP_DEST}:${BACKUP_DIR_DEST}

rm -rf ssl_${BLOG_NAME}.zip ${DB}_${DATE}.sql ${BLOG_NAME}_${DATE}.zip ${BLOG_NAME}_${DATE}_ALL.zip ${BLOG_DEFAULT_VHOST_NAME}.conf

echo ${BLOG_NAME}_${DATE}_DONE