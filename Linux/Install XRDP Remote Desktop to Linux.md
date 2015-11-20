###Install XRDP Remote Desktop to Linux

> `XRDP`是一个完美的远程桌面协议的应用程序，允许从任何Windows机器上`RDP`到Linux服务器或工作站

####1.下载配置`EPEL`源

>查看系统版本号
>- uname -r

>查看系统的版本号

>`RHEL/CentOS 6 32-Bit`

```
# wget http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

# rpm -ivh epel-release-6-8.noarch.rpm
```

>`RHEL/CentOS 6 64-Bit`

```
#wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

#rpm -ivh epel-release-6-8.noarch.rpm
```

>查看`yum`源列表

```
# yum repolist
```

####2.各版本`Linux`下载`xrdp`介绍

>- 如果是`Debian`系发行版，可以设置好源后直接apt-get install xrdp
>- 如果是`Red Hat`系发行版，可以到http://xrdp.sourceforge.net下载安装包
 >>xrdp依赖于pam和openssl-del，编译前需要先安装pam-devel和openssl-devel这两个包（不同发行版的包名称有一点不同）
   
>- 如果是`Red Hat`系，设置好源直接`yum install pam-devel openssl-devel`

>下载好`xrdp`的安装包后，用`tar -xvvzf` 解压，进入解压出来的目录用`root`帐号执行`make` ，而后执行`make install`

>安装`xrdp`需先下载配置`vncserver`


####3.下载配置`vncserver`

```
# yum groupinstall "GNOME Desktop Environment"（CentOS 5.x安装GNOME桌面环境）
# yum groupinstall "X Window System" "Desktop"（CentOS 6.x安装GNOME桌面环境）
# yum groupinstall Xfce（CentOS安装Xfce桌面环境，可选）

# yum install tigervnc-server
```

####4.用`mstsc`启动`vncserver`

```
# sed -i 's/twn/#twn/g' /root/.vnc/xstartup

# echo 'gnome-session &' >> /root/.vnc/xstartup

# service vncserver start
```

####5.`xrdp`安装配置
>用源码安装`xrdp`

```
# tar -xzvf xrdp-v0.6.1.tar.gz

# cd xrdp-v0.6.1

# yum install  autoconf automake libtool openssl openssl-devel pam-devel libX11-devel  libXfixes-devel  libx11-dev -y

# ./bootstrap

# ./configure

# make && make install

# chmod 755 /etc/xrdp/xrdp.sh

# /etc/xrdp/xrdp.sh start
```

>`xrdp`的配置文档在`/etc/xrdp`目录下的`xrdp.ini`和`sesman.ini`

```
`xrdp.ini` 关键部分在`globals`
[globals]
bitmap_cache=yes           位图缓存
bitmap_compression=yes     位图压缩
port=3389                  监听端口
crypt_level=low            加密程度（low为40位，high为128位，medium为双40位）
channel_code=1             
sesman.ini

[Globals]
ListenAddress=127.0.0.1       监听ip地址(默认即可)
ListenPort=3350               监听端口(默认即可)
EnableUserWindowManager=1     1为开启,可让用户自定义自己的启动脚本
UserWindowManager=startwm.sh
DefaultWindowManager=startwm.sh
[Security]
AllowRootLogin=1              允许root登陆
MaxLoginRetry=4               最大重试次数
TerminalServerUsers=tsusers   允许连接的用户组(如果不存在则默认全部用户允许连接)
TerminalServerAdmins=tsadmins 允许连接的超级用户(如果不存在则默认全部用户允许连接)
[Sessions]
MaxSessions=10                 最大会话数
KillDisconnected=0             是否立即关闭断开的连接(如果为1,则断开连接后会自动注销)
IdleTimeLimit=0                空闲会话时间限制(0为没有限制)
DisconnectedTimeLimit=0        断开连接的存活时间(0为没有限制)
[Logging]
LogFile=./sesman.log           登陆日志文件
LogLevel=DEBUG                 登陆日志记录等级(级别分别为,core,error,warn,info,debug)
EnableSyslog=0                 是否开启日志
SyslogLevel=DEBUG              系统日志记录等级

```

####6.设置`xrdp`开机自启动

```
# echo '/etc/xrdp/xrdp.sh start' >> /etc/rc.local

#或者执行如下也可

# echo '/etc/xrdp/xrdp.sh start' >> /etc/rc.d/init.d/
```

>启动好xrdp，就可以通过客户端的`rdp client` 连接到服务器上，win下可以用`mstsc`，linux下可以用`rdesktop`或者`krdp`
 >>module 选择为：`sesman-Xvnc`

####7.配置`iptables`

```
# iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport 3389 -j ACCEPT

#service iptables save

#service iptables restart

#iptables -L
```