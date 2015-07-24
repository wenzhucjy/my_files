#!/bin/bash
#
# chkconfig: 2345 20 80
# description: Auto-starts tomcat
# /etc/init.d/tomcat
# chmod 755 tomcat
# cp tomcat /etc/init.d/
# ln -s /etc/init.d/tomcat /etc/rc.d/init.d/tomcat
# chkconfig --add tomcat
# chkconfig --level 2345 tomcat on 
# init script for tomcat precesses 

source /etc/profile

CATALINA_HOME="/usr/local/tomcat-7.0.47"
case $1 in
start)
        echo -n $"Starting Tomcat"
        $CATALINA_HOME/bin/startup.sh
        echo " done"
        ;;
stop)
        echo -n $"Stopping Tomcat"
        $CATALINA_HOME/bin/shutdown.sh
        echo " done"
        ;;
restart)
        echo $"Restarting Tomcat"
        $0 stop
        sleep 1
        $0 start
        echo " done"
        ;;
*)
        echo $"Usage: $0 {start|stop|restart}"
        ;;
esac