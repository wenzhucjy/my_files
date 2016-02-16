**CATALINA_OPTS vs JAVA_OPTS区别**

  > 1. Tomcat 社区从 tomcat5.5.21 开始发布一个 CATALINA_OPTS 变量用来解决 JAVA_OPTS设定的属性值只允许"shutdown"使用，任何指定的 JAVA_OPTS 或 CATALINA_OPTS 值都会传递给 Tomcat 的 "start" 和 "run" 命令，而只有 JAVA_OPTS 设定的值传递给 "shutdown" 命令
  > 2. 并不单单只有 Tomcat 可以使用 JAVA_OPTS，但只有 Tomcat 能使用 CATALINA_OPTS，如果只需要设定 Tomcat 的环境变量，建议使用 CATALINA_OPTS，若还需指定其他 java 应用程序的环境变量，如 JBoss，建议使用 JAVA_OPTS

  >> export CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.port=7004" - See more at: [http://www.tikalk.com/java/when-use-tomcat-catalinaopts-instead-javaopts/#sthash.7MN6NIFY.dpuf](http://www.tikalk.com/java/when-use-tomcat-catalinaopts-instead-javaopts/#sthash.7MN6NIFY.dpuf)
