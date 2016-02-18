配置 sonatype nexus 为系统服务

>1.创建 `<username>` 用户，赋予足够访问权限运行服务

```
# useradd <username> -d <username-home-path>
# echo '<username-password>' | passwd --stdin <username>
# su - <username>
```

>2.在`.zshrc`或`.bashrc`指定`NEXUS_HOME`

```
export NEXUS_HOME=/usr/local/nexus
```

>3.把`nexus`复制到/etc/init.d/nexus下或者创建软链接

```
$ sudo ln -s $NEXUS_HOME/bin/nexus /etc/init.d/nexus
```

>4.修改`nexus`的配置信息

```
NEXUS_HOME="/usr/local/nexus"  
RUN_AS_USER=web  
PLATFORM=linux-x86-64  
PLATFORM_DIR="${NEXUS_HOME}/bin/jsw/${PLATFORM}"  
WRAPPER_CMD="${PALTFORM_DIR}/wrapper"  
WRAPPER_CONF="${PLATFORM_DIR}/../conf/wrapper.conf"  
PIDDIR="${NEXUS_HOME}"  #pid会写在/usr/local/nexus2/nexus.pid文件里  
```

>5.修改`nexus.properties`的配置信息

```
# Jetty section
application-port=8091                             
application-host=0.0.0.0
nexus-webapp=${bundleBasedir}/nexus
nexus-webapp-context-path=/nexus
# Nexus section
nexus-work=${bundleBasedir}/../sonatype-work/nexus
runtime=${bundleBasedir}/nexus/WEB-INF
```

>6.配置`JAVA_HOME`，若无配置，需指定

```
export JAVA_HOME=/usr/local/java
export PATH=$PATH:$JAVA_HOME/bin
```


>7.修改`${NEXUS_HOME}/bin/jsw/wrapper.conf`的配置

```
#若出现 wrapper  | Unable to start JVM: No such file or directory ，则修改为`java`的绝对路径
wrapper.java.command=java 
```

>8.配置`nexus`为系统服务

#### Red Hat, Fedora, and CentOS

```
$ cd /etc/init.d
$ sudo chkconfig --add nexus
$ sudo chkconfig --levels 345 nexus on
$ service nexus start
Starting Nexus OSS...
Started Nexus OSS.
$ tail -f /usr/local/nexus/logs/wrapper.log
```

#### Ubuntu and Debian Linux

```
$ cd /etc/init.d
$ sudo update-rc.d nexus defaults
$ service nexus start
Starting Nexus OSS...
Started Nexus OSS.
$ tail -f /usr/local/nexus/logs/wrapper.log

```

参考文档:

>https://books.sonatype.com/nexus-book/2.9/reference/install-sect-service.html

>[Sonatype nexus - How can I reset a forgotten admin password?](https://support.sonatype.com/hc/en-us/articles/213465508-How-can-I-reset-a-forgotten-admin-password-#post_33718407)


