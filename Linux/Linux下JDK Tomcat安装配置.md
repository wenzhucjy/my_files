### Linux下JDK Tomcat安装配置


```
# yum install -y \
vim \
wget \
unzip
```

#### 1. CentOS安装SecureCRT的sz/rz工具包

> sudo yum install lrzsz -y
>- sz：将选定的文件发送（send）到本地机器；
>- rz：运行该命令会弹出一个文件选择窗口，从本地选择文件上传到服务器(receive)；

#### 2. [安装 oh-my-zsh](https://github.com/wenzhucjy/my_files/tree/master/oh-my-zsh)

```
$ sudo yum install zsh -y
$ git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
$ cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
$ chsh -s /bin/zsh
```


#### 3. 安装 JDK

>- To download jdk from oracle website execute next command in the command line:

```
$ wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u77-b03/jdk-8u77-linux-x64.tar.gz"
$ tar -xvzpf jdk-8u77-linux-x64.tar.gz
$ sudo mkdir -p /opt/jdk/1.8.0_77
$ sudo mv jdk1.8.0_77/* /opt/jdk/1.8.0_77/
$ sudo ln -s /opt/jdk/1.8.0_77 /opt/jdk/current

```

>- Use update-alternatives config jdk:

```
$ sudo alternatives --install /usr/bin/java java /opt/jdk/current/bin/java  2
$ sudo update-alternatives --install /usr/bin/java java /opt/jdk/current/bin/java 1
$ sudo alternatives --config java
```

>- Set JAVA_HOME environment variable on Linux

vi ~/.bash_profile

```
#### JAVA 1.8.0 #######################

        export JAVA_HOME=/opt/jdk/current
        export PATH=$PATH:$JAVA_HOME/bin

#### JAVA 1.8.0 #######################
```

>- How to set JAVA_HOME environment variable automatically on Linux

```
 ######### Open JDK ###########

      export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))

 ######### Open JDK ###########
 ```

$ source ~/.bash_profile


#### 4. 安装 Tomcat

>- Step 1 : Create a Low Privilege User - that user will work with java

```
# groupadd tomcat
# useradd -g tomcat -s /sbin/nologin -d /opt/tomcat/temp tomcat
# su - <username>
```


>- Step 2 : Download the Latest Binary Release

```
# wget http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.33/bin/apache-tomcat-8.0.33.tar.gz

# wget http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.69/bin/apache-tomcat-7.0.69.tar.gz
```

>- Step 3 : Move Distribution Into Place and Uncompress

```
# mkdir -p /opt/tomcat-8.0
# tar -xvzpf apache-tomcat-8.0.33.tar.gz -C /opt/tomcat-8.0_33
# ln -s /opt/tomcat-8.0_33 /opt/tomcat
```

>- Step 4 : Change Permissions

```
# chown -Rf tomcat.tomcat /opt/tomcat-8.0_33
```

$ vi ~/.bash_profile

```
#### TOMCAT 8.0.33 #######################

        export CATALINA_HOME=/opt/tomcat

#### TOMCAT 8.0.33 #######################
```

$ source ~/.bash_profile


>- Step 5 : [Configure Tomcat to Run as a Service](https://github.com/wenzhucjy/my_files/blob/master/tomcat%2Fshell%2Ftomcat.sh)

```
$ sudo cp /tmp/tomcat.sh /etc/init.d/tomcat
$ sudo chmod +x /etc/init.d/tomcat
$ sudo chkconfig --add tomcat
$ sudo chkconfig --level  345 tomcat on
$ sudo chkconfig --list tomcat
$ service tomcat {start | stop | restart | status}
```

>- Step 6 :Configuring Tomcat Manager Access.

$CATALINA_HOME/conf/tomcat-users.xml.The following roles are now available:
manager-gui,manager-status,manager-jmx,manager-script,admin-gu,admin-script.


```
<tomcat-users>
  <role rolename="manager-gui"/>
  <user username="tomcat" password="secret" roles="manager-gui"/>
 </tomcat-users>

```


>- [Step 7: Configure Hot deployment tomcat project war](https://github.com/wenzhucjy/my_files/blob/master/tomcat%2Fshell%2Fhot-deploy-tomcat.sh)

  实现热部署启动，即在`$CATALINA_HOME/conf/Catalina/localhost/`目录下生成xml配置文件，文件内容如下：
`<Context displayName="file" docBase="/tmp/war/deployWar/file##20160503175307.war" reloadable="true" />`

>- Step 8 : How to Run Tomcat on Port 80 as Non-Root User

```
# iptables -t nat -A PREROUTING -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 8080
# iptables -t nat -A PREROUTING -p udp -m udp --dport 80 -j REDIRECT --to-ports 8080
```

If iptables service is not exist,then

```
# yum install iptables-services
# service iptables restart
```

iptables config file location /etc/sysconfig/iptables.

Another method that can be directly add the following content in /etc/sysconfig/iptables file.
`-A RH-Firewall-1-INPUT -m state –state NEW -m tcp -p tcp –dport 8080 -j ACCEPT`
BTW, the most recommended

```
# firewall-cmd --permanent --zone=public --add-port=8080/tcp
# firewall-cmd --reload
```

Be sure to save and restart your IP Tables.

>- Step 8 : Running Tomcat behind Apache

NOTE:As an alternative to running Tomcat on port 80, if you have Apache in front of Tomcat, you can use mod_proxy as well as ajp connector to map your domain to your Tomcat application(s) using an Apache vhost as shown below.

While Tomcat has improved it's 'standalone performance', I still prefer to have Apace in front of it for a number of reasons.

In your Apache config, be sure to set KeepAlive to 'on'. Apache tuning, of course, is a whole subject in itself...
Example 1:  VHOST with mod_proxy:

```
<VirtualHost *:80>  
    ServerAdmin admin@yourdomain.com  
    ServerName yourdomain.com  
    ServerAlias www.yourdomain.com  
    ProxyRequests Off  
    ProxyPreserveHost On  
    <Proxy *>  
        Order allow,deny  
        Allow from all  
     </Proxy>
     ProxyPass / http://localhost:8080/  
     ProxyPassReverse / http://localhost:8080/  
     ErrorLog logs/yourdomain.com-error_log  
     CustomLog logs/yourdomain.com-access_log common  
 </VirtualHost>
```

Example 2: VHOST with ajp connector and mod_proxy:
```
<VirtualHost *:80>  
    ServerAdmin admin@yourdomain.com  
    ServerName yourdomain.com  
    ServerAlias www.yourdomain.com  
    ProxyRequests Off  
    ProxyPreserveHost On  
    <Proxy *>  
     Order allow,deny  
     Allow from all  
     </Proxy>  
     ProxyPass / ajp://localhost:8009/  
     ProxyPassReverse / ajp://localhost:8009/
     ErrorLog logs/yourdomain.com-error_log  
     CustomLog logs/yourdomain.com-access_log common  
 </VirtualHost>
```

NOTE:In both vhost examples above, we are "mapping" the domain to Tomcat's ROOT directory.
If we wish to map to an application such as yourdomain.com/myapp, we can add some rewrite as shown below.
This will rewrite all requests for yourdomain.com to yourdomain.com/myapp.
Example 3: VHOST with rewrite:
```
<VirtualHost *:80>  
    ServerAdmin admin@yourdomain.com  
    ServerName yourdomain.com  
    ServerAlias www.yourdomain.com  
    RewriteEngine On  
    RewriteRule ^/$ myapp/ [R=301]
     ProxyRequests Off  
     ProxyPreserveHost On  
     <Proxy *>  
     Order allow,deny  
     Allow from all  
     </Proxy>
     ProxyPass / ajp://localhost:8009/  
     ProxyPassReverse / ajp://localhost:8009/
     ErrorLog logs/yourdomain.com-error_log  
     CustomLog logs/yourdomain.com-access_log common  
 </VirtualHost>
```

#### 6. 其他相关

>- 安装压力测试工具 ab

```
#ubuntu 安装
$ apt-get install apache2-utils

#centos安装
$ sudo yum install httpd-tools -y
```

>- 安装 htop

```
$ sudo yum install htop -y
```
>- 安装 tree

```
$ sudo yum install tree -y
```

>- [多路复用神奇 tmux](https://github.com/wenzhucjy/my_files/blob/master/Tmux%2FTmux%E5%A4%9A%E8%B7%AF%E5%A4%8D%E7%94%A8.md)

Tmux 是远程ssh session的管理工具.

>- vim-for-server

```
$ curl https://raw.githubusercontent.com/wklken/vim-for-server/master/vimrc > ~/.vimrc

$ git clone https://github.com/wklken/vim-for-server.git && ln -s vim-for-server/vimrc ~/.vimrc
```
