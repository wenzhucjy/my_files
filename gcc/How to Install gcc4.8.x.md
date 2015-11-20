###C++11问题gcc4.8.x 安装

> 通常`sudo yum install gcc-c++`，安装后的gcc的版本号小于4.7，而当编译源代码会出现：

```
error: unrecognized command line option "-std=c++11"
```

>需安装`c++11 gcc4.8.x`以上的版本，方法如下：

>配置`yum`源：

```
# vim /etc/yum.repos.d/devtools-2.repo
[testing-devtools-2-centos-$releasever]
name=testing 2 devtools for CentOS $releasever 
# baseurl=http://puias.princeton.edu/data/puias/DevToolset/$releasever/$basearch/
baseurl=http://people.centos.org/tru/devtools-2/$releasever/$basearch/RPMS
gpgcheck=0
```

>安装：

```
# yum install devtoolset-2-gcc-4.8.2 devtoolset-2-gcc-c++-4.8.2
```

>测试`gcc`版本：

```
# /opt/rh/devtoolset-2/root/usr/bin/gcc --version
gcc (GCC) 4.8.1 20130715 (Red Hat 4.8.1-4)
Copyright (C) 2013 Free Software Foundation, Inc.
```

>修改环境变量：

```
# ln -s /opt/rh/devtoolset-2/root/usr/bin/* /usr/local/bin/
# gcc --version
gcc (GCC) 4.8.2 20140120 (Red Hat 4.8.2-15)
Copyright (C) 2013 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

>设定配置环境中多个`gcc`版本

```
# update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.6 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.6 

# update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 40 --slave /usr/bin/g++ g++ /usr/bin/g++-4.8 

# update-alternatives --display gcc

# update-alternatives --config gcc
```