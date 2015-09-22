#!/bin/sh
#Author : wenzhu
#Desc : restart tomcat
#Time : 2015-09-22
 
tomcatpath="/usr/local/tomcat-8/"
tomcatname="tomcat-8"
tomcatsh="tomcat8.sh"
 
 
if [ $# -ne 1 ]; then
        ps -ef | grep java | grep ${tomcatpath};
        pid=$(ps -ef | grep java | grep ${tomcatpath} | awk '{print $2}')
else
        pid=$1
fi
 
echo -e "Before start ${tomcatpath}, should kill the same run, kill pid ${pid} (yes/no)? \c"
read Confirm
 
case $Confirm in
y|Y|yes|Yes)
        rm -rf ${tomcatpath}work/Catalina/localhost/*
        kill -9 $pid
        rm -f ${tomcatpath}${tomcatname}.pid
        sleep 1
        /etc/init.d/${tomcatsh} start; tail -f ${tomcatpath}logs/catalina.out
        ;;
*)
        echo "Restart ${tomcatpath} is Canneled"
        ;;
esac