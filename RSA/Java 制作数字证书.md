### Java 制作数字证书

>Java自带的 `keytool` 工具是个密钥和证书管理工具。它使用户能够管理自己的公钥/私钥对及相关证书，用于（通过数字签名）自我认证（用户向别的用户/服务认证自己）或数据完整性以及认证服务。它还允许用户储存他们的通信对等者的公钥（以证书形式）。

>`keytool` 将密钥和证书储存在一个所谓的密钥仓库（keystore）中。缺省的密钥仓库实现将密钥仓库实现为一个文件，它用口令来保护私钥。

#### 1. Java 制作数字证书

> Java 是利用`$JAVA_HOME/bin/keytool`来创建制作数字证书，Keytool是一个Java数据证书的管理工具 ,Keytool将密钥（key）和证书（certificates）存在一个称为keystore的文件中在keystore里，包含两种数据：

```
密钥实体（Key entity）：密钥（secret key）又或者是私钥
配对公钥（采用非对称加密） ：可信任的证书实体（trusted certificate entries），只包含公钥

```


##### 1.1 keystore(JKS)制作

```
$JAVA_HOME/bin> keytool -genkey -alias test[别名] -keypass 123456[别名密码] -keyalg RSA[算法] -keysize 1024[密钥长度] -validity 365[有效期以天为单位] -keystore /path/to/test.keystore[证书存放路径] -storepass 123456[获取keystore信息密码]

```
##### 1.2 导出 `CRT` 格式公钥

```
$JAVA_HOME/bin> keytool -export -alias test[别名] -keystore /path/to/test.keystore[证书存放路径] -file /path/to/test.crt[公钥.crt文件存放路径] -storepass 123456[获取keystore信息密码]

```

##### 1.3 转换为 `PFX` 格式私钥

> `PFX`是指以`pkcs#12`格式存储的证书和相应私钥,需用到转换工具`kestore-export`，把`Java KeyStore`文件转换为微软的`.pfx`文件和OpenSSL的PEM格式文件(`.key` + `.crt`)

> 进入`/path/to/kestore-export`，执行

```
JKS2PFX path/to/test.keystore[证书存放路径，如e:\test.keystore] 123456[Keystore密码] test[Alias别名]  e:\test[导出的路径及文件名] d:\jdk1.8.0_51\jre\bin\[$JAVA_HOME/bin，即Java Runtime的目录需包含java与keytool工具]

```
