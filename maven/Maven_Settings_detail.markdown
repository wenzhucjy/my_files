    <!--Maven之settings私库配置-->
    <?xml version="1.0" encoding="UTF-8"?>
    
    <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" 
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
              xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
     <!-- 自定义本地仓库地址,其默认值为~/.m2/repository -->  
      <localRepository>D:/Java/maven/repository</localRepository>
      <pluginGroups>
        <!-- pluginGroup
         | Specifies a further group identifier to use for plugin lookup.
        <pluginGroup>com.your.plugins</pluginGroup>
        -->
      </pluginGroups>
    
      <!-- 代理服务器Proxy -->
      <proxies>
        <!-- proxy
         | Specification for one proxy, to be used in connecting to the network.
         |-->
    	<!--
        <proxy>
          <id>my-proxy</id>
          <active>true</active>
          <protocol>http</protocol>
          <username>proxyuser</username>
          <password>proxypass</password>
          <host>proxy.host.net</host>
          <port>80</port>
          <nonProxyHosts>local.net|some.host.com</nonProxyHosts>
        </proxy>
        -->
      </proxies>
    
      <!-- servers
       | This is a list of authentication profiles, keyed by the server-id used within the system.
       | Authentication profiles can be used whenever maven must make a connection to a remote server.
       |-->
     <!-- 仓库认证信息，发布的服务器和密码，可设定权限指定相应的仓库地址URL -->  
       <servers>  
        <server>  
        <!-- 发布的位置在POM中配置，以ID为关联，有很多公用的信息需要配置在POM文件里，
        最佳实践是定义一个公司级别的root pom -->  
          <id>anyfish.releases</id>  
          <username>web</username>  
          <password>1q2w3e4r</password>  
        </server>  
        <server>  
          <id>anyfish.snapshots</id>  
          <username>web</username>  
          <password>1q2w3e4r</password>  
        </server>  
      </servers>  
      <!-- 配置镜像 -->  
    	<mirrors>
    	   <!-- 此镜像一般用来作为公司内部开发的版本快照，作为public-snapshots仓库的镜像地址 -->  
          <!-- 镜像的id,id用来区分不同的mirror元素。 -->   
    	  <mirror>
    		<id>local_mirror</id>
    		<mirrorOf>*</mirrorOf>
    		<name>local_mirror</name>
    		<url>http://localhost:8081/nexus/content/groups/public/</url>
    	</mirror>
    	
    	 <!-- 
    	  <mirror>
    		  <id>nexus-osc</id>
    		  <mirrorOf>central</mirrorOf>
    		  <name>Nexus osc</name>
    		  <url>http://localhost:8081/nexus/content/groups/public</url>
    	  </mirror>
    	 <mirror>
    		  <id>nexus-osc-thirdparty</id>
    		  <mirrorOf>thirdparty</mirrorOf>
    		  <name>Nexus osc thirdparty</name>
    		  <url>http://maven.oschina.net/content/repositories/thirdparty/</url>
    	  </mirror>
    	  -->
    	</mirrors>
    	  <!-- settings.xml中的profile元素是pom.xml中profile元素的裁剪版本。它包含了activation, repositories, pluginRepositories 和 properties元素。  
        这里的profile元素只包含这四个子元素是因为这里只关心构建系统这个整体（这正是settings.xml文件的角色定位），而非单独的项目对象模型设置。    
        如果一个settings中的profile被激活，它的值会覆盖任何其它定义在POM中或者profile.xml中的带有相同id的profile。 -->  
      <profiles>
        <!-- 仓库。仓库是Maven用来填充构建系统本地仓库所使用的一组远程项目。而Maven是从本地仓库中使用其插件和依赖。  
    不同的远程仓库可能含有不同的项目，而在某个激活的profile下，可能定义了一些仓库来搜索需要的发布版或快照版构件。有了Nexus，这些应该交由Nexus完成 -->  
       <profile>
                <id>local_nexus</id>
                <repositories>
                    <repository>
                        <id>local_nexus</id>
                        <name>nexus Repo</name>
                        <url>http://localhost:8081/nexus/content/groups/public/</url>
                        <releases>
                            <enabled>true</enabled>
                        </releases>
                        <snapshots>
                            <enabled>true</enabled>
                        </snapshots>
                    </repository>
    				
                </repositories>
    			 <!-- 插件仓库。仓库是两种主要构件的家。第一种构件被用作其它构件的依赖。这是中央仓库中存储大部分构件类型。  
            另外一种构件类型是插件。Maven插件是一种特殊类型的构件。由于这个原因，插件仓库独立于其它仓库。  
            pluginRepositories元素的结构和repositories元素的结构类似。每个pluginRepository元素指定一个Maven可以用来寻找新插件的远程地址。 -->    
                <pluginRepositories>
                    <pluginRepository>
                        <id>local_nexus</id>
                        <name>local_nexus</name>
                        <url>http://localhost:8081/nexus/content/groups/public/</url>
                        <releases>
                            <enabled>true</enabled>
                        </releases>
                        <snapshots>
                            <enabled>true</enabled>
                        </snapshots>
                    </pluginRepository>
                    <pluginRepository>
                        <id>central</id>
    					 <!-- 虚拟的URL形式,指向镜像的URL,因为所有的镜像都是用的是nexus，这里的nexus实际上指向的是http://maven.oschina.net/content/groups/public/ -->  
                        <url>http://maven.oschina.net/content/groups/public/</url>
                        <releases>
                            <enabled>true</enabled>
                        </releases>
                        <snapshots>
    					  <!-- 表示可以从这个仓库下载snapshot版本的构件 -->
                            <enabled>true</enabled>
                        </snapshots>
                    </pluginRepository>
                </pluginRepositories>
            </profile>
    		<!-- 默认的中央工厂定义在 $M2_HOME/lib/maven-model-builder-x.x.x.jar的pom.xml文件中，若要修改默认的配置，需覆盖写以下配置-->
    		<profile>
                <id>central_nexus</id>
                <repositories>
                    <repository>
                        <id>central</id>
                        <name>nexus Repo</name>
    					  <!--由于配置过镜像，这个url不起作用-->
                        <url>http://maven.oschina.net/content/groups/public/</url>
                        <releases>
                            <enabled>true</enabled>
                        </releases>
                        <snapshots>
                            <enabled>true</enabled>
                        </snapshots>
                    </repository>
                </repositories>
            </profile>
      </profiles>
      
     <!-- 激活的Profile。activation元素并不是激活profile的唯一方式。settings.xml文件中的activeProfile元素可以包含profile的id，  
        任何在activeProfile中定义的profile id，不论环境设置如何，其对应的profile都会被激活。如果没有匹配的profile，则什么都不会发生。  
        profile也可以通过在命令行，使用-P标记和逗号分隔的列表来显式的激活（如，-P test）。  
        要了解在某个特定的构建中哪些profile会激活，可以使用maven-help-plugin（mvn help:active-profiles）。 -->    
      <activeProfiles>  
       <activeProfile>local_nexus</activeProfile>  
        <activeProfile>central_nexus</activeProfile>  
      </activeProfiles>
    </settings>





