#!/bin/bash
# Name: Script for Upgrade subversion to version 1.7 on CentOS Systems
# 
# description: Upgrade subversion to version 1.7 on CentOS
# processname: UpgradeSvn
#
# Author: wenzhucjy@gmail.com
# Date: 2015/10/17
svn --version #Lets check which version we have now

yum remove subversion

cd /usr/local/src/

wget wget http://archive.apache.org/dist/subversion/subversion-1.7.14.tar.gz #got this from http://subversion.apache.org/download/ on the recomended download section

tar zxf subversion-1.7.14.tar.gz # Make sure you use the same filename from the previous step

cd subversion-1.7.14

wget http://rahulsoni.me/files/apr-util-1.3.12.tar.gz

wget http://rahulsoni.me/files/apr-1.4.5.tar.gz

tar zxf apr-util-1.3.12.tar.gz

mv apr-util-1.3.12 apr-util # When using ./configure it will look for these files by default on a folder without version number

tar zxf apr-1.4.5.tar.gz

mv apr-1.4.5 apr # When using ./configure it will look for these files by default on a folder without version number

./configure
#Now after my first try to get this working, it failed because of the sqlite version, so if you get this message after trying ./configure :
#checking sqlite library version (via header)... unsupported SQLite version
#checking sqlite library version (via pkg-config)... none or unsupported 3.3
#no
#An appropriate version of sqlite could not be found. We recommmend3.7.6.3, but require at least 3.6.18.
#Then you would need to install sqlite 3.7.X you can do it by installing atomic repository and updating using yum:

sqlite3 -version #check current version

wget -q -O - http://www.atomicorp.com/installers/atomic | sh # To install Atomic repository

yum --enablerepo=atomic upgrade sqlite

sqlite3 -version #you should get the 3.7 version listed now
#Now that we have the updated sqlite, lets continue with the subversion install:

./configure

make

make install

wget http://www.webdav.org/neon/neon-0.29.6.tar.gz

tar -zxf neon-0.29.6.tar.gz

mv neon-0.29.6 neon

cd neon 
./configure --with-ssl=openssl
make 
make install

svn --version # Now you should see the latest version
#Now, go to all of your local working directories and do a svn upgrade:

cd /home/web/application/web

svn upgrade # svn update

# svn export
svn export https://xxxx/svn/svn_path svn_temp --user name xxx --password xxx --force


