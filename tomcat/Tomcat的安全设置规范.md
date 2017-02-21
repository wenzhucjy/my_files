### Tomcat的安全
生产环境tomcat规范
#### 1.更改服务监听端口

若 Tomcat 都是放在内网的，则针对 Tomcat 服务的监听地址都是内网地址

> 标准配置：` <Connector port="10000" server="webserver"/>`

#### 2.`telnet`管理端口保护（强制）

>修改默认的 8005 管理端口不易猜测（大于1024），但要求端口配置在`8000~8999`之间

>修改`SHUTDOWN`命令为其他字符串
	标准配置：`<Server port="8578" shutdown="dangerous">`，该端口用于监听关闭tomcat的`shutdown`命令，默认为`8005`

>执行`telnet 127.0.0.1 8005`，然后执行`SHUTDOWN`即可关闭`Tomcat`

#### 3.AJP连接端口的保护（强制）

>AJP Port 该端口用于监听AJP（ Apache JServ Protocol ）协议上的请求，通常用于整合Apache Server等其他HTTP服务器，默认为8009

>修改默认的ajp 8009端口为不易冲突（大于1024），但要求端口配置在`8000~8999`之间

>通过iptables规则限制ajp端口访问的权限仅为线上机器，目的在于防止线下测试流量被apache的mod_jk转发至线上tomcat服务器

>标准配置：`<Connector port="8349" protocol="AJP/1.3" />`

#### 4.禁用管理端（强制）

>删除默认`$CATALINA_HOME/conf/tomcat-users.xml`文件，重启tomcat将会自动生成新的文件

>删除$CATALINA_HOME/webapps下载默认的所有目录和文件

>将tomcat应用根目录配置为tomcat安装目录以外的目录，如`/usr/local/tomcat/webapps/jenkins`

>> 标准配置：

a.`server.xml`配置
一种直接修改`Host`节点信息，表示全局配置

```
<Host name="localhost"  appBase="/data/www/tomcat_webapps" unpackWARs="true" autoDeploy="false"></Host>
```
另一种直接在`Host`节点中新增`Context`节点，指定具体的项目

```
<Context path="" docBase="/usr/local/tomcat/webapps/jenkins" debug="0" reloadable="false" crossContext="true">
</Context>

```

b.在$CATALINA_HOME/conf/Catalina/locathost目录下新增文件 `test##20160506172651.xml`

```
<Context displayName="test" docBase="/data/www/tomcat_webapps/test##20160506172651.war" reloadable="false" />

```

#### 5.隐藏Tomcat的版本信息（强制）

> a. 针对该信息的显示是由一个jar包控制的，该jar包存放在$CATALINA_HOME/lib目录下，名称为 catalina.jar，通过 jar xf 命令解压这个 jar 包会得到两个目录 META-INF 和 org ,修改 org/apache/catalina/util/ServerInfo.properties 文件中的 serverinfo 字段来实现来更改我们tomcat的版本信息

```
$ cd $CATALINA_HOME/lib
$ jar xf catalina.jar
$ cat org/apache/catalina/util/ServerInfo.properties |grep -v '^$|#'
$ mkdir -p org/apache/catalina/util
$ vim ServerInfo.properties  # 修改以下参数的值即可
server.info=nolinux        
server.number=xxxx
server.built=xxxx
```

> b. 自定义错误页面：修改$CATALINA_HOME/conf/web.xml重定向 `403/404/500`等错误到指定的错误页面

#### 6.降权启动（强制）

>Tomcat启动用户权限必须非root权限，尽量降低tomcat启动用户的目录访问权限，如需直接对外使用80端口，可通过普通账号启动后，配置iptables规则进行转发，为了防止 Tomcat 被植入 web shell 程序后，可以修改项目文件。要将 Tomcat 和项目的属主做分离，即便被破坏也无法创建和编辑项目文件

#### 7.文件列表访问控制（强制）

>`$CATALINA_HOME/conf/web.xml`文件中的`default`部分的`listings`的配置必须为`false`(默认)，表示不列出文件列表

>> 标志配置：

```
<init-param>
  <param-name>listings</param-name>
  <param-value>false</param-value>
</init-param>
```

#### 8.访问限制（可选）

>通过配置，限定访问的IP来源

```
<Context path="" docBase="/usr/local/tomcat/webapps/jenkins" debug="0" reloadable="false" crossContext="true">
   <Valve className="org.apache.catalina.valves.RemoteHostValve"  allow="www.test.com,*.test.com" deny="*.*.*.*"/>
</Context>
```

>全局设置限定IP和域名访问：

```
<Host name="localhost"  appBase="/data/www/tomcat_webapps" 	 unpackWARs="false" autoDeploy="false">
   <Valve className="org.apache.catalina.valves.RemoteAddrValve"  allow="192.168.1.10,192.168.1.30,192.168.2.*" deny="*.*.*.*"/>  
   <Valve className="org.apache.catalina.valves.RemoteHostValve"  allow="www.test.com,*.test.com" deny=""/>
</Host>
```

#### 9.脚本权限回收（推荐）

>控制$CATALINA_HOME/bin目录下的 start.sh、catalina.sh、shutdown.sh的可执行权限，`chmod -R 744 $CATALINA_HOME/bin/*`，防止其他用户有执行启动和关闭Tomcat脚本的权限

#### 10.访问日志格式规范（推荐）

>开启tomcat默认访问日志中Referer和User-Agent记录

>> 标准配置：

```
<Valve className="org.apache.catalina.valves.AccessLogValve"
   directory="logs" prefix="localhost_access_log"
	 suffix=".txt" pattern="%h %l %u %t &quot;%r&quot; %s %b %{Referer}i %{User-Agent}i %D"
	 resolveHosts="false" />
```

#### 11.Server header重写（推荐）

>在 HTTP Connector 配置中加入 server 的配置，`server="chuck-server"`，备注：当tomcat HTTP端口直接提供web服务时此配置生效，加入此配置，将会替换 http 响应 Server header 部分的默认配置，默认是`Apache-Coyote/1.1`

>> 推荐配置：

```
<Connector port="10000" protocol="HTTP/1.1" connectionTimeout="20000" redirectPort="8443" server="chuck-server" />
```

#### 12.启用Cookie的HttpOnly属性及配置cookie的secure属性

> 1 secure属性(在`web.xml`中`sesion-config`节点配置`cookie-config`节点的`secure`为`true`)

>> 当设置为true时，表示创建的 Cookie 会被以安全的形式向服务器传输，也就是只能在 HTTPS 连接中被浏览器传递到服务器端进行会话验证，如果是 HTTP 连接则不会传递该信息，所以不会被窃取到Cookie 的具体内容。

> 2 HttpOnly属性(修改 `$CATALINA_HOME/conf/context.xml` ，添加 `<Context useHttpOnly="true">`)

>> 如果在Cookie中设置了"HttpOnly"属性，那么通过程序(JS脚本、Applet等)将无法读取到Cookie信息，这样能有效的防止XSS攻击
