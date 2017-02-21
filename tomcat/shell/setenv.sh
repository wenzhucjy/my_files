#! /bin/sh
# ==================================================================
# Name: Application specific parameters at tomcat startup
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

if [ -z "$TOMCAT_HOME" ]; then
	echo "##### TOMCAT_HOME must be defined"
	exit 1
fi

if [ ! -d "$TOMCAT_HOME" ]; then
	echo "##### $TOMCAT_HOME is not a valid directory"
	exit 1
fi

# 若使用了APR协议，需指定apr lib路径 
# LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/apr/lib 
# export LD_LIBRARY_PATH

# export CATALINA_PID=$CATALINA_HOME/catalina.pid


# export CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=12345 -Dcom.sun.manaagement.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=172.16.100.85"
export JAVA_OPTS="$JAVA_OPTS -Dfile.encoding=utf-8 -Dspring.profiles.active=development"

# Check for application specific parameters at startup
if [ -r "$CATALINA_HOME/bin/appenv.sh" ]; then
      . "$CATALINA_HOME/bin/appenv.sh"
      export CATALINA_OPTS="$CATALINA_OPTS $JVM_OPTS"
fi

echo "_______________________________________________"
echo ""
echo "Using CATALINA_OPTS:"
for arg in $CATALINA_OPTS
do
    echo ">> " $arg
done
echo ""

echo "Using JAVA_OPTS:"
for arg in $JAVA_OPTS
do
    echo ">> " $arg
done
echo "_______________________________________________"
echo ""
