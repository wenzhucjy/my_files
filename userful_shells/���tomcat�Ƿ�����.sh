#!/bin/sh  
TomcatID=$(ps -ef |grep hudson-3.01 |grep java | awk ' { print $2 } ')  
echo "tomcat的pid为$TomcatID"  
Monitor(){  
        echo "[info]开始监控tomcat...[$(date +'%F %H:%M:%S')]"  
        if [[ $TomcatID ]]  
# 这里判断TOMCAT进程是否存在  
           then  
                echo "tomca启动正常"  
                kill -9 $TomcatID  
                tempTomcatID=$(ps -ef |grep hudson-3.01 |grep java | awk ' { print $2 } ')  
                if [[ $tempTomcatID ]]  
                        then  
                        echo "停止失败"  
                else   
                        echo "成功停止"  
                fi  
        else  
            echo "tomcat没有启动"  
        fi  
}  
  
  
Monitor  