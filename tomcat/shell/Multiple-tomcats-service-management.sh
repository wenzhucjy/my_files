#!/bin/sh
# ==================================================================
# Name: Multiple tomcats service management script.  
# 
#  ______                           __   
# /_  __/___  ____ ___  _________ _/ /_  
#  / / / __ \/ __ `__ \/ ___/ __ `/ __/  
# / / / /_/ / / / / / / /__/ /_/ / /_    
#/_/  \____/_/ /_/ /_/\___/\__,_/\__/    
# 
# Usage: $0 {start|stop|restart|status|log|kill}
#        service tomcat {0|1|..} {start|stop|restart|status|log|kill}
#
# see - github @ https://github.com/wenzhucjy
# ==================================================================
#
# Source function library.  
. /etc/rc.d/init.d/functions  
# 第几个tomcat
tcNo=$1
tcName=tomcat$1
basedir=/apps/tomcat/$tcName
tclog=${basedir}/logs/catalina.$(date +%Y-%m-%d).out
RETVAL=0  
  
start(){
        checkrun  
        if [ $RETVAL -eq 0 ]; then  
                echo "-- Starting tomcat..."  
                $basedir/bin/startup.sh  
                touch /var/lock/subsys/${tcNo}
                checklog 
                status
        else  
                echo "-- tomcat already running"  
        fi  
}  
# 停止某一台tomcat，如果是重启则带re参数，表示不查看日志，等待启动时再提示查看  
stop(){
        checkrun  
        if [ $RETVAL -eq 1 ]; then  
                echo "-- Shutting down tomcat..."  
                $basedir/bin/shutdown.sh  
                if [ "$1" != "re" ]; then
                  checklog
                else
                  sleep 5
                fi
                rm -f /var/lock/subsys/${tcNo} 
                status
        else  
                echo "-- tomcat not running"  
        fi  
}  
  
status(){
        checkrun
        if [ $RETVAL -eq 1 ]; then
                echo -n "-- Tomcat ( pid "  
                ps ax --width=1000 |grep ${tcName}|grep "org.apache.catalina.startup.Bootstrap start" | awk '{printf $1 " "}'
                echo -n ") is running..."  
                echo  
        else
                echo "-- Tomcat is stopped"  
        fi
        #echo "---------------------------------------------"  
}
# 查看tomcat日志，带vl参数
log(){
        status
        checklog yes
}
# 如果tomcat正在运行，强行杀死tomcat进程，关闭tomcat
kill(){
        checkrun
        if [ $RETVAL -eq 1 ]; then
            read -p "-- Do you really want to kill ${tcName} progress?[no])" answer
            case $answer in
                Y|y|YES|yes|Yes)
                    ps ax --width=1000 |grep ${tcName}|grep "org.apache.catalina.startup.Bootstrap start" | awk '{printf $1 " "}'|xargs kill -9  
                    status
                ;;
                *);;
            esac
        else
            echo "-- exit with $tcName still running..."
        fi
}
checkrun(){  
        ps ax --width=1000 |grep ${tcName}| grep "[o]rg.apache.catalina.startup.Bootstrap start" | awk '{printf $1 " "}' | wc | awk '{print $2}' >/tmp/tomcat_process_count.txt  
        read line < /tmp/tomcat_process_count.txt  
        if [ $line -gt 0 ]; then  
                RETVAL=1  
                return $RETVAL  
        else  
                RETVAL=0  
                return $RETVAL  
        fi  
}  
# 如果是直接查看日志viewlog，则不提示输入[yes]，否则就是被stop和start调用，需提示是否查看日志
checklog(){
        answer=$1
        if [ "$answer" != "yes" ]; then
            read -p "-- See Catalina.out log to check $2 status?[yes])" answer
        fi
        case $answer in
            Y|y|YES|yes|Yes|"")
                tail -f ${tclog}
            ;;
            *)
            #    status
            #    exit 0
            ;;
        esac
}
checkexist(){
        if [ ! -d $basedir ]; then
            echo "-- tomcat $basedir does not exist."
            exit 0
        fi
}
  
  
case "$2" in  
start)  
        checkexist
        start  
        exit 0
        ;;  
stop)  
        checkexist
        stop  
        exit 0
        ;;  
restart)  
        checkexist
        stop re 
        start 
        exit 0
        ;;  
status)  
        checkexist
        status  
        #$basedir/bin/catalina.sh version  
        exit 0
        ;;  
log)
        checkexist
        log
        exit 0
        ;;
kill)
        checkexist
        status
        kill
        exit 0
        ;;
*)  
        echo "Usage: $0 {start|stop|restart|status|log|kill}"  
        echo "       service tomcat {0|1|..} {start|stop|restart|status|log|kill}"  
        esac  
  
exit 0