#!/bin/sh
#
#####################################################
# Name: Script for checking tomcat for UNIX Systems
# 
# Check if tomcat is running via shell script
#
# Usage:
#
# Author: jy.chen
# Date: 2015/10/15
#####################################################
#
# ############  method 1 ##############
#
# wget -O - http://localhost:8080/portal >& /dev/null
# RTN=$?
# if [ $RTN -eq 0 ];then
# ############ another way ###########
# #if( test $? -eq 0 ) then
#   echo "tomcat is running."
# elif
#	echo "tomcat is not run."
# fi
#
# ############  method 2 ##############
#
# rm dest_file.html
#  wget http://more/cowbell.txt --output-document=dest_file.html
#  COWBELL=`diff dest_file.html goldenfile.html | wc -l`
# if [ $COWBELL == 0 ]; then
#	echo "Woohoo - the site is up (and not hacked)";
# else
#	echo "The downloaded page is diff from the golden file"
# fi
#
# ############  method 3 ##############
#
# RESULT=$(netstat -na | grep $LISTEN_PORT | awk '{print $6}' | wc -l)
#
#if [ "$RESULT" = 0 ];then
#	echo "##### Tomcat $LISTEN_PORT still not listening..."
#elif [ "$RESULT" != 0 ];then
#	echo "Tomcat $LISTEN_PORT is listening and tomcat running..."
#fi
#
#
# ############  method 4 ##############
#
# PID=$(ps -ef | grep java | grep -v grep | awk '{print $2}')
# if [ "${PID}" ]; then
#
#	echo "##### Tomcat is running. PID is ${PID}."
#	#ps -ef | grep java | grep -v grep | awk '{print $2}' | xargs kill -9
#	eval "kill -9  ${PID}"
#	
#   #$TOMCAT_HOME/bin/shutdown.sh
#
#	echo "##### Shutdown tomcat ..."
#	echo
#fi
#

echo
echo "##### Shell begining ...Waiting!"
echo

if [ -z "$TOMCAT_HOME" ]; then
	echo "##### TOMCAT_HOME must be defined"
	exit 20
fi

if [ ! -d "$TOMCAT_HOME" ]; then
	echo "##### $TOMCAT_HOME is not a valid directory"
	exit 21
fi

LISTEN_PORT=8080
TEMP_WARDIR=/home/vagrant/tools/temp_war
APPNAME=portal.war
APP=`basename $APPNAME .war` 
APPDIR="$TOMCAT_HOME/webapps/$APP"
NEWWARDIR=/comet/comet_portal/build/libs/comet-portal-1.0-SNAPSHOT.war

if [ ! -f "$NEWWARDIR" ];then
	echo "##### Deploy path $NEWWARDIR is not exist.  Nothing done."
	exit 30
fi


if [ ! -d "$TEMP_WARDIR" ]; then
	echo "##### The $TEMP_WARDIR is not exist. mkdir it now."
	mkdir -p "$TEMP_WARDIR"
fi


cp -p "$NEWWARDIR" "$TEMP_WARDIR/$APPNAME"

if [ "$TEMP_WARDIR/$APPNAME" -ot "$APPDIR.war" ]; then
	echo "##### The file $TEMP_WARDIR/$APPNAME is older than the $APPDIR.war.  Nothing done." 
	exit 40
fi
# start the process

#STAT=$(netstat -na | grep $LISTEN_PORT | awk '{print $6}')　

PID=$(ps -ef | grep java | grep -v grep | awk '{print $2}')

if [ "${PID}" ]; then

	echo "##### Tomcat is running. PID is ${PID}."

	eval "kill -9  ${PID}"
	
    #$TOMCAT_HOME/bin/shutdown.sh

	echo "##### Shutdown tomcat ..."
	echo
fi

sleep 3

if [ -d "$APPDIR" ]; then
	rm -fr "$APPDIR"
	rm -fr "$APPDIR.war"
	echo "##### Remove $APPDIR and $APPNAME ..."

fi

if [ "$TEMP_WARDIR/$APPNAME" != "$APPDIR.war" ]; then
	echo "##### Copy $TEMP_WARDIR/$APPNAME to $TOMCAT_HOME/webapps"
	cp -p "$TEMP_WARDIR/$APPNAME" "$TOMCAT_HOME/webapps"
fi

	$TOMCAT_HOME/bin/startup.sh
	
	echo "##### Starting Tomcat ..."


sleep 5

echo
echo "##### Shell finished .......Done!"

