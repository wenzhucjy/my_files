#!/bin/bash
#
#####################################################
# Name: Script for Tomcat Start Stop Restart for UNIX Systems
# 
# Configure Tomcat to Run as a Service
#  ______                           __    
# /_  __/___  ____ ___  _________ _/ /_   
#  / / / __ \/ __ `__ \/ ___/ __ `/ __/   
# / / / /_/ / / / / / / /__/ /_/ / /_     
#/_/  \____/_/ /_/ /_/\___/\__,_/\__/     
#
# Usage:
#      $0 [start | stop | status | restart]"
#
#     "examples:"
#          $0 start     -> Start tomcat instances currently configured"
#	       $0 stop      -> Stop tomcat instances currently configured"
#	       $0 status    -> Show tomcat instances status currently configured"
#	       $0 restart   -> Restart tomcat instances currently configured"
#
# chkconfig: 2345 10 90
# description: Tomcat Start Stop Restart Status
# processname: tomcat
# chmod 755 tomcat
# chkconfig --add tomcat
# chkconfig --level 2345 tomcat on
# service tomcat {start | stop | restart | status}
#
# Author: jy.chen
# Date: 2015/10/17
#####################################################

ECHO=/bin/echo
TEST=/usr/bin/test
TOMCAT_USER=vagrant
TOMCAT_HOME=/home/vagrant/tools/apache-tomcat/apache-tomcat-8.0.27
TOMCAT_START_SCRIPT=$TOMCAT_HOME/bin/startup.sh
TOMCAT_STOP_SCRIPT=$TOMCAT_HOME/bin/shutdown.sh
CATALINA_PID=$TOMCAT_HOME/bin/catalina.pid
 
$TEST -x $TOMCAT_START_SCRIPT || exit 0
$TEST -x $TOMCAT_STOP_SCRIPT || exit 0

#if [ -z "$JAVA_HOME" ]; then
#   $ECHO "error: JAVA_HOME is not set"
#   exit 1
#fi

if [ -z "$TOMCAT_HOME" ]; then
   $ECHO "##### Error: TOMCAT_HOME is not set."
   exit 1
fi

# Friendly Logo
logo()
{
        $ECHO ""
        $ECHO "  ______                           __  "
        $ECHO " /_  __/___  ____ ___  _________ _/ /_ "
        $ECHO "  / / / __ \/ __  __ \/ ___/ __  / __/ "
        $ECHO " / / / /_/ / / / / / / /__/ /_/ / /_   "
        $ECHO "/_/  \____/_/ /_/ /_/\___/\__,_/\__/   "
        $ECHO "                                       "
        $ECHO "                                       "
}

# Help
usage()
{
        logo
        $ECHO ""
        $ECHO "usage:"
        $ECHO "   $0 [start | stop | status | restart]"
        $ECHO ""
        $ECHO "examples:"
        $ECHO "   $0 start 	  -> Start tomcat instances currently configured"
        $ECHO "   $0 stop  	  -> Stop tomcat instances currently configured"
		$ECHO "   $0 status    -> Show tomcat instances status currently configured"
		$ECHO "   $0 restart   -> Restart tomcat instances currently configured"
        $ECHO ""
}


# Running status
is_Running ()
{
   #wget -O - http://localhost:8080/portal >& /dev/null
	PID=$(ps -ef | grep java | grep -v grep | awk '{print $2}')
 if [ "$PID" ]; then
  return 0
 else
  return 1
 fi
}

# Start 
start() {
    $ECHO "##### Tomcat is  starting ..."
	su - $TOMCAT_USER -c "$TOMCAT_START_SCRIPT &"
	sleep 3
	$ECHO
	$ECHO "##### Tomcat is already started."
}
# Stop
stop() {
	 $ECHO "##### Tomcat is shutdowning ..."
	 su - $TOMCAT_USER -c "$TOMCAT_STOP_SCRIPT 60 -force &"
	 while [ "$(ps -fu $TOMCAT_USER | grep java | grep tomcat | wc -l)" -gt "0" ]; do
        sleep 5; $ECHO -n "."
     done
	 $ECHO "##### Tomcat is already stopped."
}

# define 
ACTION="$1"

case $ACTION in

start)
    is_Running
	retval=$?
	
	if ( test "$retval" -eq 0 ) then
		$ECHO "##### Tomcat is running,can not start again."
	else
	  start
	fi
   ;;

stop)
    is_Running
	retval=$?
	if ( test "$retval" -eq 0 ) then
	  stop
	else
	   $ECHO "##### Tomcat is already stopped,can not shutdown again."
	fi
    ;;

status)
    is_Running
	retval=$?
	if ( test "$retval" -eq 0 ) then
		$ECHO "##### Tomcat is running,PID is $PID"
	else
	   $ECHO "##### Tomcat is stopped."
	fi
    ;;

restart)
	
	PID=$(ps -ef | grep java | grep -v grep | awk '{print $2}')

	if [ "${PID}" ]; then

		eval "kill -9  ${PID}"

		$ECHO "##### Tomcat is running, begin shutdown tomcat ..."
		$ECHO
		$ECHO "##### Restarting tomcat ..."
        su - $TOMCAT_USER -c "$TOMCAT_START_SCRIPT &"
		sleep 3
		$ECHO 
		$ECHO "##### Tomcat is started."
	else
	  $ECHO "##### Tomcat is stop , begin start tomcat ..."
	  su - $TOMCAT_USER -c "$TOMCAT_START_SCRIPT &"
	  sleep 3
	  $ECHO
	  $ECHO "##### Tomcat is started."

	fi
    ;;
*)
	usage
	exit 1
	;;
esac
exit 0
