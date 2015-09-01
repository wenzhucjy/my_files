#Maven ReadMe

------

## **SVN**

SVN是目前非常流行版本管理工具

### **1. 服务器的创建**
a、创建一个根目录，这个根目录用来存储所有的svn的工厂信息（每一个工厂等于一个项目）
b、启动svn-->svnserve -d -r d:/svn/root
c、对于Linux而言，直接后台启动即可
对于window而言，后台启动无用，所以需要将其添加到window的服务中

### **2. 开发流程**
a.创建工厂 svnadmin create d:/svn/root/student
b.配置权限
c.创建项目并提交 **Import** 到SVN工厂中
d.由开发人员进行 **Checkout** 完成开发
e.忽略文件使用TortoiseSVN选择 **Unversion and add to ignore list**

## **Maven**

### **1. Maven初步**
a.安装，这是M2_HOME环境变量为安装路径
b.本地仓库安装(%M2_HOME%/settings.xml)修改`<localRepository>`标签内容
c.创建简单的项目，其中groupId:定义当前maven项目隶属的实际项目，artifactId:定义实际项目中的一个Maven模块，packaging:定义maven项目的打包方式，若不定义packaging，默认为jar
d.运行mvn
```bash
mvn clean -->表示运行清理操作（会默认把target文件夹中的数据清理）
mvn clean compile-->表示先运行清理之后运行编译，会见代码编译到target文件夹中
mvn clean test-->运行清理和测试
mvn clean package-->运行清理和打包
mvn clean install-->运行清理和安装，会将打好的包安装到本地仓库中，以便其他的项目可以调用
mvn clean deploy-->运行清理和发布（发布到私服上面）
mvn dependency:tree --> 查看依赖情况
mvn dependency:list --> 查看当前项目已解析的依赖
```
e.中央工厂的地址
%M2_HOME%/lib/maven-model-builder-x.x.x.jar 的 pom.xml 配置的 url地址　

    <url>https://repo.maven.apache.org/maven2</url>
f.客户端创建maven骨架
```bash
mvn archetype:generate -DgroupId=com.wenzhu.maven -DartifactId=wenzhu.maven -Dversion=0.0.1-SNAPSHOT
```
g.安装jar到本地仓库中
```bash
mvn install:install-file -Dfile=D:\web\lib\xxx-V0.0.1.jar -DgroupId=com.mysite -DartifactId=xxx -Dversion=V0.0.1 -Dpackaging=jar
```
 也可用maven-install-plugin插件，具体的pom.xml配置如下
```bash
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
	<modelVersion>4.0.0</modelVersion>
	<groupId>com.github.maven</groupId>
	<artifactId>Install</artifactId>
	<version>0.0.1-SNAPSHOT</version>
	<packaging>pom</packaging>
	<build>
		<plugins>
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-install-plugin</artifactId>
				<version>2.5.2</version>
				<configuration>
					<!-- customer groupId,artifactId,version -->
					<groupId>org.somegroup</groupId>
					<artifactId>someartifact</artifactId>
					<version>1.0</version>
					<packaging>jar</packaging>
					<!-- basedir -->
					<file>${basedir}/test.jar</file>
					<!-- generate pom file -->
					<generatePom>true</generatePom>
					<!-- <generatePom>false</generatePom>
					<pomFile>${basedir}/dependencies/someartifact-1.0.pom</pomFile> -->
				</configuration>
				<executions>
					<execution>
						<id>install-jar-lib</id>
						<goals>
							<goal>install-file</goal>
						</goals>
				<!-- you will need to run the validation phase explicitly: 
				mvn validate.After this step, the standard compilation will work: mvn clean install-->
						<phase>validate</phase>
					</execution>
				</executions>
			</plugin>
		</plugins>
	</build>
</project>
```

### **2. 依赖**
a.依赖包的查询

[http://mvnrepository.com](http://mvnrepository.com)

[http://search.maven.org/](http://search.maven.org/)

[http://maven.oschina.net/home.html](http://maven.oschina.net/home.html)

b.依赖包的传递

 A-->C  B-->A ==> B-->C（这种依赖是基于compile这个范围进行传递）
 依赖包的传递是根据定义的先后顺序，路径的长短不一致就选择最小路径，若希望精确的控制依赖包，可以使用依赖的排除功能进行控制
```bash
 <exclusions>
    <exclusion>
        <groupId>xxx</groupId>
        <artifactId>xxx</artifactId>
  </exclusion>
 </exclusions>
```
c.依赖包的范围
```bash
test范围指的是测试范围有效，在编译和打包时都不会使用这个依赖
compile范围指的是编译范围有效，在编译和打包时都会将依赖存储进去，默认使用该范围
provided依赖：在编译和测试的过程有效，最后生成war包时不会加入，诸如：servlet-api，因为servlet-api，tomcat等web服务器已经存在了，如果再打包会冲突
runtime在运行的时候依赖，在编译的时候不依赖，典型如JDBC驱动实现
system系统依赖范围，此类依赖不是通过maven仓库解析，而是与本机系统绑定
```
d.聚合和继承

聚合的项目和其他项目在同一级模块中，使用.../xx文件名称来设置
如下
```bash
 <artifactId>mysite</artifactId>
    <packaging>pom</packaging>
    <version>1.0-SNAPSHOT</version>
    <modules>
        <module>parent</module>
        <module>common</module>
        <module>web</module>
        <module>orderMgr</module>
        <module>customerMgr</module>
    </modules>
```
对于依赖的继承而言，都需要通过`<dependencyManagement>`来完成，如果不管理子类会全部继承，这种可能会导致一些模块存在不需要的依赖，插件管理则用 `<pluginManagement>`来完成
e.版本的管理
```bash
总版本号.分支版本号.小版本号-里程碑版本
总版本号的变动一般表示框架的变动
分支版本号：一般表示增加了一些功能
小版本号：在分支版本上面进行bug的修复
```
里程碑：

    SNAPSHOT-->alpha-->beta-->release-->GA
    user0.0.1-SNAPSHOT-->user0.0.1-Release--->user1.0.0SHAPSHOT  -->user1.0.0-Rlease
                               -->user0.1.0-SNAPSHOT-->user0.1.0-Rlease
                           
### **3. 仓库**
a.本地仓库
b.中心仓库，优先使用oschina的仓库地址
[http://maven.oschina.net/content/groups/public/](http://maven.oschina.net/content/groups/public/)
c.私服Nexus

 - nexus的安装

```bash
1、下载并且解压缩
2、将bin添加到环境变量%NEXUS_HOME%
3、nexus install 将nexus安装到windows的服务中
4、修改%NEXUS_HOME%/jsw/conf/wrapper.conf 找到 wrapper.java.command=java
修改java命令所在目录
5、nexus start|stop|restart 启动|停止|重启服务
```
 - 仓库讲解
######1.host的仓库，内部项目的发布仓库
```bash
3rd party : 第三方依赖的仓库，这个数据通常是内部内容自行下载只收发布
Releases  : 内部的模块中release模块的发布仓库
Snapshots ：发布内部的SNAPSHOT模块的仓库
```

######2.proxy的仓库，从远程中央仓库中寻找数据的仓库
######3.group仓库。组仓库用来方便开发人员进行设置的仓库

 - 仓库设置

 - 项目的发布
 1.设置release和snapshot工厂
```bash
  <!--  部署构件至nexus中 mvn : deploy 其中id 与settings.xml文件中的servers标签中的server底下的id一致-->
    <distributionManagement>
        <repository>
            <id>nexus.release</id>
            <name>nexus.release</name>
            <url>http://localhost:8081/nexus/content/repositories/nexus.release/</url>
        </repository>
        <snapshotRepository>
            <id>nexus.snapshots</id>
            <name>nexus.snapshots</name>
            <url>http://localhost:8081/nexus/content/repositories/nexus.snapshots/</url>
        </snapshotRepository>
    </distributionManagement>
```
2.设置访问的权限

  - 创建项目工厂和设置权限
  

### **4. 生命周期和插件**
a.生命周期
```bash
1、clean
 pre-clean 执行一些需要在clean之前完成的工作
 clean 移除所有上一次构建生成的文件
 post-clean 执行一些需要在clean之后立刻完成的工作
2、default
 valdeidate
 initialize
 generate-sources
 process-sources
 generate-resources
 process-resources 复制并处理资源文件，至目标目录，准备打包。
 compile 编译项目的主源代码。
 process-classes
 generate-test-sources 
 process-test-sources 
 generate-test-resources
 process-test-resources 复制并处理资源文件，至目标测试目录。
 test-compile 编译测试源代码。
 process-test-classes
 test 使用合适的单元测试框架运行测试。这些测试代码不会被打包或部署。
 prepare-package
 package 接受编译好的代码，打包成可发布的格式，如 JAR 。
 pre-integration-test
 integration-test
 post-integration-test
 verify
 install 将包安装至本地仓库，以让其它项目依赖。
 deploy 将最终的包复制到远程的仓库，以让其它开发人员与项目共享。 
3、site
 pre-site 执行一些需要在生成站点文档之前完成的工作
 site 生成项目的站点文档
 post-site 执行一些需要在生成站点文档之后完成的工作，并且为部署做准备
 site-deploy 将生成的站点文档部署到特定的服务器上
```
b.插件
插件是maven的核心，所有执行的操作都是基于插件来完成的
为了让一个插件中可以实现众多的类似功能，maven为插件设定了目标，一个插件中有可能有多个目标
其实生命周期中的重要的每个阶段都是由插件的一个具体目标来执行的
```bash
mvn help:describe -Dplugin=org.apache.maven.plugins:maven-source-plugin:2.4 -Ddetail
或简化
mvn help:describe -Dplugin=source(source为Goal Prefix) -Dgoal=jar-no-fork -Ddetail
```





