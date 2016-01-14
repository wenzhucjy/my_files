# conf
ctx=portal
warFolder=/anyfish_web/war/warHub
deployFolder=/anyfish_web/war
confFolder=/apache-tomcat-8.0.21/conf/Catalina/localhost

# ------ ------
latestWarFile=$(basename `ls -tr $warFolder/*.war | tail -n 1`)
echo --- latestWarFile: $latestWarFile
cp $warFolder/$latestWarFile $deployFolder/
confFile=$(echo $latestWarFile | sed 's/.*\#\#\(.*\)\.war/\1/')
ctxXml=$confFolder/$ctx##$confFile.xml


# generate context conf file for tomcat to deploy
echo --- ctxXml: $ctxXml
ctxCont='<Context displayName="'$ctx'" docBase="D:\anyfish_web\war\'$latestWarFile'" reloadable="true" />'
echo $ctxCont > $ctxXml

# echo $ctxCont > /Tomcat2/conf/Catalina/localhost/$ctx##$confFile.xml
