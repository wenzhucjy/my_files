### Linux: Installing Apache Portable Runtime (APR) for Tomcat

#### 优化输出`catalina.out`

>默认的tomcat输出log路径为`$CATALINA_HOME/log/catalina.out`，修改`$CATALINA_HOME/bin/catalina.sh`涉及的内容如下：

```
CATALINA_OUT="$CATALINA_BASE"/logs/catalina.$(date +%Y-%m-%d).out

```

#### `BIO`，`NIO`，`APR`区别

>在Tomcat中，缺省HTTP连接器BIO(Blocking I/O)低并发特性，为了提高Tomcat性能，可采用NIO(非阻塞 I/O)或APR(Apache Portable Runtime)连接器来提供更强性能，提升Web静态页面的处理能力，`apr` 与`tomcat-native`提供更好的伸缩性、性能和集成到本地服务器技术。

>>（1）BIO是最稳定最老的一个连接器，是采用阻塞的方式，意味着每个连接线程绑定到每个Http请求，直到获得Http响应返回，如果Http客户端请求的是keep-Alive连接，那么这些连接也许一直保持着直至达到timeout时间，这期间不能用于其它请求。

>>（2）NIO是利用java的异步io护理技术,noblocking IO技术想运行在该模式下，直接修改server.xml里的Connector节点,修改protocol为
`<Connector port="80″
protocol="org.apache.coyote.http11.Http11NioProtocol"
connectionTimeout="20000"
URIEncoding=”UTF-8″
useBodyEncodingForURI="true"
enableLookups="false"
redirectPort="8443">` 启动后,即可生效。

>>（3）APR是使用原生C语言编写的非堵塞I/O，需要安装`apr`和`native`，直接启动就支持 `apr`，从操作系统级别来解决异步的IO问题,大幅度的提高性能。 使用时指定protocol为 `protocol=“org.apache.coyote.http11.Http11AprProtocol”` 可以到http://apr.apache.org/download.cgi 去下载，大致的安装步骤如下：

#### 安装`apr`及配置

>APR需要的工作环境：

>>`APR library`

>>`JNI wrappers for APR used by Tomcat (libtcnative)`

>>`OpenSSL libraries`

##### A.安装OpenSSL

>`# yum install openssl-devel`

##### B.`apr`安装

>yum源安装`apr`

>>`# yum -y install apr apr-devel`

>源码安装`apr`

>>`# ./configure --prefix=/usr/local/apr`

>若安装apr的时候出现`rm: cannot remove `libtoolT': No such file or directory`解决办法：

```
# vi configure
找到 $RM "$cfgfile" 前面加#注释掉：
#    $RM "$cfgfile"

```

> 然后重新`./configure` 并且 `make && sudo make install`

##### C. 安装`apr-iconv`

>`# ./configure --prefix=/usr/local/apr-iconv --with-apr=/usr/local/apr`

>`# make && make install`

##### D. 安装`apr-util`

>`# ./configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr --with-apr-iconv=/usr/local/apr-iconv/bin/apriconv`
>`# make && sudo make install`

##### E. 安装 JNI wrapper库 (libtcnative)

`tomcat-native`就在`Tomcat`的`bin`目录下有/tomcat-native.tar.gz，解压并安装步骤如下：
>`# tar zxvf tomcat-native.tar.gz`

>`# cd tomcat-native-1.1.33-src/jni/native`

>`# ./configure --with-apr=/usr/local/apr`

>`# make && make install`

若出现`error: can't locate a valid JDK location`，需指定具体的`JAVA_HOME`，重新执行

>`./configure --with-apr=/usr/local/apr --with-java-home=/home/web/tools/jdk1.8.0_65 \
  --with-ssl=/usr/lib64/openssl`
>`# make && make install`

安装完成之后 会出现如下提示信息

```
Libraries have been installed in:
   /usr/local/apr/lib
```
表示在`/usr/local/apr/lib`下创建各种`tcnative`函数库

##### F. 设置 `apr` 的环境变量

方法是在`catalina.sh`文件的`#!/bin/sh`下添加如下内容：

> `LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/apr/lib export LD_LIBRARY_PATH`

或在`/etc/profile`，添加

```
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/apr/lib
source /etc/profile
```
这样就只是给这个`Tomcat`添加了`APR`，不破坏其它`Tomcat`的配置。

##### G. 重新启动`Tomcat`

启动`Tomcat`查看日志信息，应该有类似如下的信息：

```
Loaded APR based Apache Tomcat Native library 1.1.33 using APR versi
APR capabilities: IPv6 [true], sendfile [true], accept filters [fals
OpenSSL successfully initialized (OpenSSL 1.0.1e 11 Feb 2013)
```

若出现如下错误信息：

```
Tomcat SSLEngine Error
	SEVERE: Failed to initialize the SSLEngine.
	org.apache.tomcat.jni.Error: 70023: This function has not been implemented on this platform
    at org.apache.tomcat.jni.SSL.initialize(Native Method)
    at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
    at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:57)
    at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
    at java.lang.reflect.Method.invoke(Method.java:606)
    at org.apache.catalina.core.AprLifecycleListener.initializeSSL(AprLifecycleListener.java:259)
    at org.apache.catalina.core.AprLifecycleListener.lifecycleEvent(AprLifecycleListener.java:110)
    at org.apache.catalina.util.LifecycleSupport.fireLifecycleEvent(LifecycleSupport.java:119)
    at org.apache.catalina.util.LifecycleBase.fireLifecycleEvent(LifecycleBase.java:90)
    at org.apache.catalina.util.LifecycleBase.setStateInternal(LifecycleBase.java:402)
    at org.apache.catalina.util.LifecycleBase.init(LifecycleBase.java:99)
    at org.apache.catalina.startup.Catalina.load(Catalina.java:640)
    at org.apache.catalina.startup.Catalina.load(Catalina.java:665)
    at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
    at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:57)
    at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
    at java.lang.reflect.Method.invoke(Method.java:606)
    at org.apache.catalina.startup.Bootstrap.load(Bootstrap.java:281)
    at org.apache.catalina.startup.Bootstrap.main(Bootstrap.java:455)
```
需修改`Tomcat`主目录下的`/conf/server.xml`的配置如下:
`<Listener className="org.apache.catalina.core.AprLifecycleListener" SSLEngine="off" />`

关闭`Tomcat`查看日志信息，有类似如下信息：

```
Stopping ProtocolHandler ["http-apr-8080"]
Destroying ProtocolHandler ["http-apr-8080"]
```

##### H. `Tomcat`参考配置
```
 <Connector port="8080" protocol=" org.apache.coyote.http11.Http11AprProtocol "
	URIEncoding="UTF-8"
	maxConnections="10000"
	maxThreads="2000"
	acceptCount="2000"
	minSpareThreads="100"
	compression="on"
	compressionMinSize="2048"
	compressableMimeType="text/html,text/xml,text/javascript,text/css,text/plain"
	enableLookups="false"
	disableUploadTimeout="true"
	connectionTimeout="20000"
	redirectPort="8443" />
```
