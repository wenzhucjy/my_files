#!/bin/bash
CODE=`ps -ef | grep goagent/local/proxy.py | grep -v grep | awk '{print $2}'`
if [ -z $CODE ]
then
    /usr/bin/python ~/wenzhu/software/goagent/local/proxy.py >/dev/null 2>&1  &
fi