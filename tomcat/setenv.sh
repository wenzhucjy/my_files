#! /bin/sh
# ==================================================================
#  ______                           __  
# /_  __/___  ____ ___  _________ _/ /_   
#  / / / __ \/ __ `__ \/ ___/ __ `/ __/ 
# / / / /_/ / / / / / / /__/ /_/ / /_   
#/_/  \____/_/ /_/ /_/\___/\__,_/\__/   

# Multi-instance Apache Tomcat installation with a focus
# on best-practices as defined by Apache, SpringSource, and MuleSoft
# and enterprise use with large-scale deployments.

# Looking for the latest version?
# github @ https://github.com/wenzhucjy

# ==================================================================

# discourage address map swapping by setting Xms and Xmx to the same value
# http://confluence.atlassian.com/display/DOC/Garbage+Collector+Performance+Issues
export CATALINA_OPTS="$CATALINA_OPTS -Xms64m"
export CATALINA_OPTS="$CATALINA_OPTS -Xmx800m"

# Increase maximum perm size for web base applications to 4x the default amount
# http://wiki.apache.org/tomcat/FAQ/Memoryhttp://wiki.apache.org/tomcat/FAQ/Memory
# Java HotSpot(TM) 64-Bit Server VM warning: ignoring option MaxPermSize, support was removed in 8.0
# export CATALINA_OPTS="$CATALINA_OPTS -XX:MaxPermSize=1024m"

# Reset the default stack size for threads to a lower value (by 1/10th original)
# By default this can be anywhere between 512k -> 1024k depending on x32 or x64
# bit Java version.
# http://www.springsource.com/files/uploads/tomcat/tomcatx-large-scale-deployments.pdf
# http://www.oracle.com/technetwork/java/hotspotfaq-138619.html
export CATALINA_OPTS="$CATALINA_OPTS -Xss512k"

# Oracle Java as default, uses the serial garbage collector on the
# Full Tenured heap. The Young space is collected in parallel, but the
# Tenured is not. This means that at a time of load if a full collection
# event occurs, since the event is a 'stop-the-world' serial event then
# all application threads other than the garbage collector thread are
# taken off the CPU. This can have severe consequences if requests continue
# to accrue during these 'outage' periods. (specifically webservices, webapps)
# [Also enables adaptive sizing automatically]
export CATALINA_OPTS="$CATALINA_OPTS -XX:+UseParallelGC"

# This is interpreted as a hint to the garbage collector that pause times
# of <nnn> milliseconds or less are desired. The garbage collector will
# adjust the  Java heap size and other garbage collection related parameters
# in an attempt to keep garbage collection pauses shorter than <nnn> milliseconds.
# http://java.sun.com/docs/hotspot/gc5.0/ergo5.html
export CATALINA_OPTS="$CATALINA_OPTS -XX:MaxGCPauseMillis=1500"

# A hint to the virtual machine that it.s desirable that not more than:
# 1 / (1 + GCTimeRation) of the application execution time be spent in
# the garbage collector.
# http://themindstorms.wordpress.com/2009/01/21/advanced-jvm-tuning-for-low-pause/
export CATALINA_OPTS="$CATALINA_OPTS -XX:GCTimeRatio=9"

# The hotspot server JVM has specific code-path optimizations
# which yield an approximate 10% gain over the client version.
export CATALINA_OPTS="$CATALINA_OPTS -server"

# Disable remote (distributed) garbage collection by Java clients
# and remove ability for applications to call explicit GC collection
export CATALINA_OPTS="$CATALINA_OPTS -XX:+DisableExplicitGC"
# how-to-remotely-debug-application-running-on-tomcat-from-within-intellij-idea
# http://blog.trifork.com/2014/07/14/how-to-remotely-debug-application-running-on-tomcat-from-within-intellij-idea/
export CATALINA_OPTS="$CATALINA_OPTS -agentlib:jdwp=transport=dt_socket,address=8000,server=y,suspend=n"

export JAVA_OPTS="$JAVA_OPTS -Dfile.encoding=UTF-8"

#It's also a good idea to configure Tomcat memory utilization,http://wiki.openkm.com/index.php/Configure_Tomcat_service_linux

#JAVA_OPTS="-Xms256m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=256m -Djava.awt.headless=true -Dfile.encoding=utf-8"
#JAVA_OPTS="$JAVA_OPTS -XX:+UseConcMarkSweepGC -Dlog4j.configuration=file://$CATALINA_HOME/conf/log4j.properties"
#CATALINA_PID=$CATALINA_HOME/catalina.pid
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CATALINA_HOME/lib/sigar

# Remote reloading java classes jrebel plugin.
export CATALINA_OPTS="$CATALINA_OPTS -javaagent:/home/vagrant/tools/jrebel/jrebel.jar -agentpath:/home/vagrant/tools/jrebel/libjrebel64.so -Drebel.disable_update=true -Drebel.remoting_plugin=true"
# Check for application specific parameters at startup
if [ -r "$CATALINA_BASE/bin/appenv.sh" ]; then
  . "$CATALINA_BASE/bin/appenv.sh"
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
