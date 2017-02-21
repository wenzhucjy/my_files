#!/bin/sh
# ==================================================================
# Name: Script for Hot Deployment Tomcat for UNIX Systems
# 
#  ______                           __   
# /_  __/___  ____ ___  _________ _/ /_  
#  / / / __ \/ __ `__ \/ ___/ __ `/ __/  
# / / / /_/ / / / / / / /__/ /_/ / /_    
#/_/  \____/_/ /_/ /_/\___/\__,_/\__/    
# 
#  Generating context conf file for tomcat deploy ,
#   $TOMCAT_HOME/conf/Catalina/localhost.
#
#  CtxCont XML EXAMPLE : 
#
#  <Context displayName="test" docBase="/home/web/tools/apache-tomcat/war/deployWar/test##20151019135522.war" reloadable="true" />
#
# Usage:
#
# see - github @ https://github.com/wenzhucjy
# ==================================================================

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


if [ ! -d "$DEPLOY_DIR" ]; then
	echo "##### $DEPLOY_DIR is not exist. mkdir it now."
	mkdir -p "$DEPLOY_DIR"
fi

echo "##### Copy $WAR_FILE to $DEPLOY_DIR "


cp $WAR_FILE $DEPLOY_DIR -Rp


# Format $WAR_NAME , test##20151019153000.war
#CONF_FILE=$(echo $WAR_NAME | sed 's/.*\#\#\(.*\)\.war/\1/' )

CONF_FILE=$(echo $WAR_NAME | awk -F '.' '{print $1}')
CTX=$(echo $WAR_NAME | awk -F '##' '{print $1}')

echo "##### The context conf file name : $CONF_FILE"

CTX_XML=$CONF_DIR/$CONF_FILE.xml

echo "##### Generating context conf file for tomcat deploy."

ctxCont='<Context displayName="'$CTX'" docBase="'$DEPLOY_DIR/$WAR_NAME'" reloadable="true" />'

echo $ctxCont > $CTX_XML

echo "##### ctxCont:  $ctxCont"
echo
echo "##### Shell finished ...Done!"
