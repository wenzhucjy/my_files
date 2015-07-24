##每天备份MYSQL数据库同时删除7天前的备份
#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

clear;

username=username
passwd=passwd
backuppath=/path

#把生产线上的数据库赋值给数组变量
mysqldata=`mysql -u$username -p$passwd -e"show databases"|grep -vE "mysql|information_schema|performance_schema|Database"`

#备份数据库
function mysqlbackup()
{
for i in ${mysqldata[@]}
do
#先清理空间后在备份会比较稳当一点
    find $backuppath -name $i\\_*.zip -type f -mtime +7 -exec rm {} \\;
#备份后压缩保存
    mysqldump --opt -u$username -p$passwd $i |gzip > $backuppath/$i\\_$(date +%Y%m%d%H%M).zip
done
}

#调用mysqlbackup
mysqlbackup