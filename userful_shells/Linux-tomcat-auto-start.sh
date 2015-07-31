#!/bin/bash
### BEGIN INIT INFO
# Provides:          tomcat8
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start Tomcat.
# Description:       Start the Tomcat servlet engine,init script for Tomcat precesses.
### END INIT INFO

TOMCAT_USER=web
TOMCAT_GROUP=web
TOMCAT_HOME=/data/apache
TOMCAT_BIN=$TOMCAT_HOME/bin
TOMCAT_TEMP=$TOMCAT_HOME/temp
TOMCAT_LOCK=/var/run/tomcat.lock
TOMCAT_UMASK=002

if [ `id -u` -ne 0 ]; then
        echo "You need root or sudo privileges to run this script"
        exit 1
fi

start_sams() {
        if [ -f $TOMCAT_LOCK ];then
                echo ' * tomcat has already been started or has problems'
                exit 1
        fi
        /usr/local/bin/start-stop-daemon --start -u "$TOMCAT_USER" -g "$TOMCAT_GROUP" \
                -c "$TOMCAT_USER" -d "$TOMCAT_TEMP" \
                -k "$TOMCAT_UMASK" -x "$TOMCAT_BIN/startup.sh" > /dev/null && \
                echo " * tomcat starts successfully" &&  touch $TOMCAT_LOCK
}

stop_sams() {
        if [ ! -f $TOMCAT_LOCK ];then
                echo ' * tomcat has already been stopped or has problems'
                exit 1
        fi
        /usr/local/bin/start-stop-daemon --stop -u "$TOMCAT_USER" -g "$TOMCAT_GROUP" \
                -c "$TOMCAT_USER" -d "$TOMCAT_TEMP" \
                -k "$TOMCAT_UMASK" "$TOMCAT_BIN/shutdown.sh" && \
                echo " * tomcat stops successfully" && rm -f $TOMCAT_LOCK
}

case "$1" in
        start)
                start_sams
        ;;
        stop)
                stop_sams
        ;;
        restart)
                stop_sams
                sleep 10
                start_sams
        ;;
        *)
                echo ' * Usage: Service tomcat {start|stop|restart}'
                exit 1
        ;;
esac