### Tomcat SSL keystore File

1.keytool exec
Windows:
%JAVA_HOME%\bin\keytool -genkey -alias tomcat -keyalg RSA  -keystore \path\to\my\keystore

Unix:
$JAVA_HOME/bin/keytool -genkey -alias tomcat -keyalg RSA  -keystore /path/to/my/keystore


```
Enter keystore password:
Re-enter new password:
What is your first and last name?
[Unknown]:  myname
What is the name of your organizational unit?
[Unknown]:  myunit
What is the name of your organization?
[Unknown]:  myorg
What is the name of your City or Locality?
[Unknown]:  mycity
What is the name of your State or Province?
[Unknown]:  mystate
What is the two-letter country code for this unit?
[Unknown]:  myunit
Is CN=myname, OU=myunit, O=myorg, L=mycity, ST=mystate, C=myunit correct?
[no]:  yes

Enter key password for &lt;tomcat&gt;
(RETURN if same as keystore password):
Re-enter new password:

```

2. $CATALINA_HOME/conf/server.xml

```
&lt;!-- Define a SSL Coyote HTTP/1.1 Connector on port 8443 --&gt;
&lt;Connector
protocol="HTTP/1.1"
port="8443" maxThreads="200"
scheme="https" secure="true" SSLEnabled="true"
keystoreFile="${user.home}/.keystore" keystorePass="changeit"
clientAuth="false" sslProtocol="TLS"/&gt;

```
