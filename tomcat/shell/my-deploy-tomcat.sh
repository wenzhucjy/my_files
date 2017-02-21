#! /bin/sh
# ==================================================================
# Name: Script for checking tomcat for UNIX Systems
#       Check if tomcat is running via shell script
# 
#  ______                           __   
# /_  __/___  ____ ___  _________ _/ /_  
#  / / / __ \/ __ `__ \/ ___/ __ `/ __/  
# / / / /_/ / / / / / / /__/ /_/ / /_    
#/_/  \____/_/ /_/ /_/\___/\__,_/\__/    
# 
#
# see - github @ https://github.com/wenzhucjy
# ==================================================================
#
# =========================method 1=================================
#
# wget -O - http://localhost:8080/portal >& /dev/null
# RTN=$?
# if [ $RTN -eq 0 ];then
# #if( test $? -eq 0 ) then
#   echo "tomcat is running."
# elif
#	echo "tomcat is not run."
# fi
#
# =========================method 2=================================
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
# =========================method 3=================================
# lsof -i :8080
# RESULT=$(netstat -na | grep $LISTEN_PORT | awk '{print $6}' | wc -l)
#
#if [ "$RESULT" = 0 ];then
#	echo "##### Tomcat $LISTEN_PORT still not listening..."
#elif [ "$RESULT" != 0 ];then
#	echo "Tomcat $LISTEN_PORT is listening and tomcat running..."
#fi
#
#
# =========================method 4=================================
#
# PID=$(ps -ef | grep java | grep -v grep | awk '{print $2}')
# if [ "${PID}" ]; then
#
#	echo "##### Tomcat is running. PID is ${PID}."
#
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
	exit 1
fi

if [ ! -d "$TOMCAT_HOME" ]; then
	echo "##### $TOMCAT_HOME is not a valid directory"
	exit 1
fi

CONF_DIR="$TOMCAT_HOME/conf/Catalina/localhost"

if [ ! -d "$CONF_DIR" ];then
	echo "##### $CONF_DIR is not exist.  Nothing done."
	exit 1
fi

DEPLOY_DIR=/home/vagrant/tools/apache-tomcat/war/deployWar
WAR_FILE=$(ls -tr /comet/comet_portal/build/libs/*.war | tail -1)
WAR_NAME=$(basename $WAR_FILE)

if [ ! -f "$WAR_FILE" ];then
	echo "##### Deploy path $WAR_FILE is not exist.  Nothing done."
	exit 1
fi

# check deploy_dir , is not exist then mkdir -p $deploy_dir
if [ ! -d "$DEPLOY_DIR" ]; then
	echo "##### $DEPLOY_DIR is not exist. mkdir it now."
	mkdir -p "$DEPLOY_DIR"
fi

ORIGINAL_FILE=$(ls -tr $DEPLOY_DIR/*.war | tail -1)

if [ "$WAR_FILE" -ot "$ORIGINAL_FILE" ]; then
	echo "##### The file $WAR_FILE is older than the $ORIGINAL_FILE.  Nothing done." 
	exit 1
else

	echo "##### Copy $WAR_FILE to $DEPLOY_DIR "

	cp -p $WAR_FILE $DEPLOY_DIR
fi


# start the process

#STAT=$(netstat -na | grep $LISTEN_PORT | awk '{print $6}')　

PID=$(ps -ef | grep java | grep -v grep | awk '{print $2}')

if [ "${PID}" ]; then

	echo "##### Tomcat is running. PID is ${PID}."

	eval "kill -9  ${PID}"
	
    #$TOMCAT_HOME/bin/shutdown.sh  > /dev/null 2>&1

	echo "##### Tomcat is already stopped."
	echo
	
fi

sleep 2


#################### Generate context conf file , then restart tomcat ##################

# Format $WAR_NAME , portal##20151019153000.war
#CONF_FILE=$(echo $WAR_NAME | sed 's/.*\#\#\(.*\)\.war/\1/' )

CONF_FILE=$(echo $WAR_NAME | awk -F '.' '{print $1}')
CTX=$(echo $WAR_NAME | awk -F '##' '{print $1}')

WEBAPPS=$TOMCAT_HOME/webapps/$CTX*

if [ -f "$WEBAPPS" ]; then
	rm -fr "$WEBAPPS"
	echo "##### Remove $WEBAPPS ..."

fi

if [ ! -f "$CONF_DIR/$CTX*.xml" ];then
	echo "##### Remove $CONF_DIR/$CTX*.xml."
	rm -f "$CONF_DIR/$CTX*.xml"
fi

echo "##### The context conf file name : $CONF_FILE"

CTX_XML=$CONF_DIR/$CONF_FILE.xml

echo "##### ReGenerate context conf file for tomcat deploy."

ctxCont='<Context displayName="'$CTX'" docBase="'$DEPLOY_DIR/$WAR_NAME'" reloadable="true" />'

echo $ctxCont > $CTX_XML

echo "##### ctxCont:  $ctxCont"

	$TOMCAT_HOME/bin/startup.sh
	
	echo "##### Starting Tomcat ..."


sleep 4

echo
echo "##### Shell finished .......Done!"

