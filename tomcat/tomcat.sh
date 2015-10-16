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
# Date: 2015/10/16
#####################################################

#if [ -z "$JAVA_HOME" ]; then
#   echo "error: JAVA_HOME is not set"
#   exit 1
#fi


TOMCAT_HOME=/home/vagrant/tools/apache-tomcat/apache-tomcat-8.0.27


if [ -z "$TOMCAT_HOME" ]; then
   echo "##### Error: TOMCAT_HOME is not set."
   exit 1
fi

# Friendly Logo
logo()
{
        echo ""
        echo "  ______                           __  "
        echo " /_  __/___  ____ ___  _________ _/ /_ "
        echo "  / / / __ \/ __  __ \/ ___/ __  / __/ "
        echo " / / / /_/ / / / / / / /__/ /_/ / /_   "
        echo "/_/  \____/_/ /_/ /_/\___/\__,_/\__/   "
        echo "                                       "
        echo "                                       "
}

# Help
usage()
{
        logo
        echo ""
        echo "usage:"
        echo "   $0 [start | stop | status | restart]"
        echo ""
        echo "examples:"
        echo "   $0 start 	  -> Start tomcat instances currently configured"
        echo "   $0 stop  	  -> Stop tomcat instances currently configured"
		echo "   $0 status    -> Show tomcat instances status currently configured"
		echo "   $0 restart   -> Restart tomcat instances currently configured"
        echo ""
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


#if [ $# -ne 1 ];then
#   echo 
#   echo "usage start | stop | status | restart "
#fi

# define 
ACTION="$1"

case $1 in

start)
    is_Running
	retval=$?
	
	if ( test "$retval" -eq 0 ) then
		echo "##### Tomcat is running,can not start again."
	else
	   echo "##### Tomcat is  starting ..."
	   bash $TOMCAT_HOME/bin/startup.sh 
	   sleep 3
	   echo
	   echo "##### Tomcat is already started."
	fi
   ;;

stop)
    is_Running
	retval=$?
	if ( test "$retval" -eq 0 ) then
	   echo "##### Tomcat is shutdowning ..."
	   bash $TOMCAT_HOME/bin/shutdown.sh 
	   sleep 1 
	   echo
	   echo "##### Tomcat is already stopped."
	else
	   echo "##### Tomcat is already stopped,can not shutdown again."
	fi
    ;;

status)

    is_Running
	retval=$?
	if ( test "$retval" -eq 0 ) then
		echo "##### Tomcat is running,PID is $PID"
	else
	   echo "##### Tomcat is stopped."
	fi
    ;;

restart)

	PID=$(ps -ef | grep java | grep -v grep | awk '{print $2}')

	if [ "${PID}" ]; then

		eval "kill -9  ${PID}"

		echo "##### Tomcat is running, begin shutdown tomcat ..."
		echo
		sleep 3
		echo "##### Restarting tomcat ..."
        bash $TOMCAT_HOME/bin/startup.sh
		sleep 3
		echo 
		echo "##### Tomcat is started."
	else
	  echo "##### Tomcat is stop , begin start tomcat ..."
	  $TOMCAT_HOME/bin/startup.sh 
	  sleep 3
	  echo
	  echo "##### Tomcat is started."

	fi
    ;;
*)
	usage
	;;
esac

