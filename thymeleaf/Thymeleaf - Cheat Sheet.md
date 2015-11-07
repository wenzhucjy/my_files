### Thymeleaf -  XML/XHTML/HTML5 模板引擎 

![Alt text](./image/thymeleaf_01.png)

####1. Thymeleaf 介绍
- Thymeleaf 是一个XML/XHTML/HTML5模板引擎，可用于Web与非Web环境中的应用开发。它是一个开源的Java库，基于Apache License 2.0许可，由Daniel Fernández创建，该作者还是Java加密库[Jasypt][1]的作者。

- Thymeleaf是一个支持html原型的自然引擎，它在html标签增加额外的属性来达到模板+数据的展示方式，由于浏览器解释html时，忽略未定义的标签属性，因此thymeleaf的模板可以静态运行。由于thymeleaf在内存缓存解析后的模板，解析后的模板是基于tree的dom节点树，因此thymeleaf适用于一般的web页面，不适合基于数据的xml。

- Thymeleaf的context，即提供数据的地方，基于web的context，即WebContext相对context增加 param,session,application变量，并且自动将request atttributes添加到context variable map，可以在模板直接访问。在模板处理前，thymeleaf还会增加一个变量execInfo，比如`${execInfo.templateName},${execInfo.now}`等。

> 官网地址：[http://www.thymeleaf.org][2]

> Tutorials：[Using-Thymeleaf.html][3]

> Github地址：[https://github.com/thymeleaf][4]


####2. Thymeleaf 构建

#####2.1 利用`maven`构建

```xml
<properties>
       <spring.version>4.2.1.RELEASE</spring.version>
<thymeleaf.version>2.1.4.RELEASE</thymeleaf.version>
  </properties>
 <!-- spring dependencies -->
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-core</artifactId>
      <version>${spring.version}</version>
    </dependency>
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-web</artifactId>
      <version>${spring.version}</version>
    </dependency>
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-webmvc</artifactId>
      <version>${spring.version}</version>
    </dependency>
    <dependency>
<groupId>org.springframework</groupId>
<artifactId>spring-context</artifactId>
<version>${spring.version}</version>
</dependency>
      <!-- spring transaction -->
    <dependency>
       <groupId>org.springframework</groupId>
        <artifactId>spring-tx</artifactId>
        <version>${spring.version}</version>
    </dependency>
<!-- thymeleaf begin -->
<dependency>
<groupId>org.thymeleaf</groupId>
<artifactId>thymeleaf</artifactId>
<version>${thymeleaf.version}</version>
</dependency>
<dependency>
<groupId>org.thymeleaf</groupId>
<artifactId>thymeleaf-spring4</artifactId>
<version>${thymeleaf.version}</version>
</dependency>
<!-- thymeleaf end -->
```
#####2.2 利用`Gradle`构建
>用`Gradle`构建`spring-boot`项目，`Thymeleaf`模板，其中`build.gradle`如下：

```
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

buildscript {
    ext {
        springBootVersion = '1.2.7.RELEASE'
    }
    repositories {
        maven { url 'http://maven.oschina.net/content/groups/public/' }
    }
    dependencies {
	  classpath("org.springframework.boot:spring-boot-gradle-plugin:${springBootVersion}")
    }
}
apply plugin: 'java'
apply plugin: 'idea'
apply plugin: 'spring-boot'
apply plugin: 'application'
apply plugin: 'war'

mainClassName = 'com.github.test.WebInitializer'

war {
    //Change name of generated war file and duplicate war file - jdk8 api
    archiveName "demo##" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"))+".war"
}
dependencies {
    compile("org.springframework.boot:spring-boot-starter-web") {
        exclude module: "spring-boot-starter-tomcat"
    }
    compile("org.springframework.boot:spring-boot-starter-actuator")
    compile("org.springframework.boot:spring-boot-starter-thymeleaf")
    testCompile("org.springframework.boot:spring-boot-starter-test")
}
```

####3. 标准表达式语法

####3.1 基本使用

>- `#` 代表 获取对象 从 messages bundle 也就是消息的资源本地化文件

>- `$` 表示从model里面获取

>- `# $`这2个可以一起用 比如#{'system.'+${model.id}}  -----这相当于 #{system.01}的资源本地化文件中的system.01内容


#####3.2 变量
>`#ctx`：上下文context对象
>`#vars`：上下文变量vars
>`#locale`：the context locale
>`#httpServletRequest`：HttpServletRequest对象
>`#httpSession`：HttpSession对象

#####3.3 表达式对象

- `#dates`:  java.util.Date 对象: formatting, component extraction, etc.
- `#calendars`: 与 `#dates`类似, java.util.Calendar 对象.
- `#numbers`: 数字对象.
- `#strings`: 字符串对象的功能类:contains,startWiths,prepending/appending等等
- `#objects`: objects通用对象，用th:object指定command object，两点限制： 一是必须是变量表达式`(${...})`，代表模型的名字，且不能向模型的属性导航，就是`${a}`合法，但`${a.b}`不合法；二是form内不能有其他th:object，也就是HTML的表单不能嵌套第一object只能是model 的直接attribute，不能使${person.baseInfo},第二，th:object的子级标签内不能再使用th:object。inputField使用：`<input type="text" th:field="*{datePlanted}" />`
- `#bools`: boolean 表达式对象.
- `#arrays`:  arrays数组对象.
- `#lists`:lists对象.
- `#sets`: sets对象.
- `#maps`: maps对象.
- `#aggregates`: utility methods for creating aggregates on arrays or collections.
- `#messages`: utility methods for obtaining externalized messages inside variables expressions, in the same way as they would be obtained using #{…} syntax.（在变量表达式中获取外部信息的功能类方法）
- `#ids`: utility methods for dealing with id attributes that might be repeated (for example, as a result of an iteration).

>***范例***

```
//===============#lists================
 1. th:unless="${#lists.isEmpty(demoList)}"
 2. th:unless="${#lists.isEmpty(demoList)}"
 3. th:each="${#list.sort(demoList)}"
 4. th:text="${#lists.contains(product.selectedTemplates, 4)}" 
 5. th:text="${#lists.contains(testList, &quot;P&quot;)}"

//===============#calendars===========
1. th:text="${#calendars.format(today,'yyyy-MM-dd HH:mm:ss')}"
//===============#aggregates===========
1. th:text="${#aggregates.sum(o.orderLines.{purchasePrice * amount})}"

//===============#numbers=============
1. th:text="${'￥' + #numbers.formatDecimal(price,1,2)}"
2. <option th:each="i : ${#numbers.sequence( 1, 100)}" th:value="${ (new org.joda.time.DateTime()).getYear() - i }" th:text="${ (new org.joda.time.DateTime()).getYear() - i }">1</option>//下拉年份选择
3.th:text="${#numbers.formatDecimal(info.deposit,0, 'COMMA', 0, 'POINT')}" //格式化数字123,456

//===============#strings=============
1. <td th:text="${#strings.arrayJoin(#messages.arrayMsg(#strings.arrayPrepend(sb.features,'seedstarter.feature.')),', ')}">Electric Heating, Turf</td> //首先将数组feathers都加上前缀，然后利用messages翻译国际化，最终组合成一个字符串
2. th:text="${#strings.isEmpty(msg) ? '链接不存在，请联系管理员！' : msg }" 
3. th:unless="${#lists.isEmpty(lists) OR #strings.isEmpty(param.t)}" //lists 非空并且 param.t 非空
4.  /*[[${#strings.toLowerCase(msg.type)}]]*/ 'info' //js获取request域中msg对象的type属性值并且转换为小写
5. <th:if="${#strings.toString(someObject.constantEnumString) == 'ONE'}"> //Comparing the enum constants in thymeleaf

//===============#objects=============
<form action="#" th:action="@{/processForm}" th:object="${foo}" method="post">  
  <input type="text" th:field="*{bar}" />  
 <input th:text="*{name}?: '(no name specified)'">Tom</input >
  <input type="submit" />  
</form>  
public class Foo {  
  private String bar; 
  private String name; 
  //setter/getter method
}
```

#####3.4 ***a*** 标签的使用

```
1. <a th:href="@{~/other-app/hello.html}" />  //相对路径
2. <a href="http://www.xxx.cn" th:href="@{'http://www.xxx.cn'}" />  //绝对路径
3. <a href="http://www.xxx.cn" th:href="@{/login(radom=${radom})}"  th:data="@{'/url?page=' + ${page+1} + '&amp;a=' + ${a}}" />
4. <a th:href="@{'javascript:open(\''+ ${code} + '\');'}" />
5. <a th:href="@{/order/{id}/details(id=3,action='show_all')}"> //输出结果是<a href="/order/3/details?action=show_all">
6. <a th:href=”@{'/details/'+${user.login}(orderId=${o.id},action=(${user.admin} ? 'show_all' : 'show_public'))}"> //带orderId与action两个参数
7. <a th:with="baseUrl=(${user.admin}? '/admin/home' : ${user.homeUrl})"
  th:href="@{${baseUrl}(id=${order.id})}">
```

#####3.5 文字替换
>th:text="${data}",将data的值替换该属性所在标签的body，字符常量要用引号

```
1. <span th:text="'Welcome to our application, ' + ${user.name} + '!'">
2.  th:text="|${entity.nationName ?: ''} ${entity.provinceName ?: ''} ${entity.cityName ?: ''} ${entity.entityAddress ?: ''}|">中国 福建 厦门 思明区</p> 
3. th:if="${prodStat.count} &gt; 1"
   th:text="'Execution mode is ' + ( (${execMode} == 'dev')? 'Development' : 'Production')" //比较器
4. <span th:utext="${unescaped_text}"> //保留原有的text格式，不转义
```

#####3.6 设置属性值
######3.6.1 **th:attr** 与  **th:[tagAttr]**
>- th:attr，设置标签属性，多个属性可以用逗号分隔，比如th:attr="src=@{/image/aa.jpg},title=#{logo}"，此标签不太优雅，一般用的比较少
>- th:[tagAttr],设置标签的各个属性，比如th:value,th:action等。
>>可以一次设置两个属性，比如：th:alt-title="#{logo}"
>>对属性增加前缀和后缀，用th:attrappend，th:attrprepend,比如：`th:attrappend="class=${' '+cssStyle}"`
>>对于属性是有些特定值的，比如checked属性，thymeleaf都采用bool值，比如th:checked=${user.isActive}，这里，user.isActive=false时应该checked是不会出现这个attr的
>>固定值的布尔属性：
>>![Alt text](./image/thymeleaf_01.png)

```
1. <img src="../../images/gtvglogo.png" 
     th:attr="src=@{/images/gtvglogo.png},title=#{logo},alt=#{logo}" /> 等价于
   <img src="../../images/gtvglogo.png" 
     th:src="@{/images/gtvglogo.png}" th:alt-title="#{logo}" />
2. <tr th:each="prod : ${prods}" class="row" th:classappend="${prodStat.odd}? 'odd'"> //新增属性
```

######3.6.2 **th:with**
>`th:with`,定义变量，`th:with="isEven=${prodStat.count}%2==0"`，定义多个变量可以用逗号分隔，以下Demo实现倒计时：

```xml
<div  th:with="status=${#httpServletRequest.getParameter('status') ?: '1'}">
             <a th:classappend="${status == '1' ? 'on' : ''}" href="?status=1">未审核</a>
             <a th:classappend="${status == '4' ? 'on' : ''}" href="?status=4">审核通过</a>
        </div>
         <p th:case="'未使用'" th:with="period=${T(com.github.wenzhu.DateUtils).periodBetween(time)}">剩
                 <strong th:text="${period.getDays()}">75</strong> 天 
                 <strong  th:text="${period.getHours()}">2</strong> 时 
       <strong th:text="${period.getMinutes()}">20</strong> 分
</p>
 <p class="timec" th:id="${'adds' + rowStat.index}" th:case="'未使用'" th:with="period=${T(com.github.wenzhu.DateUtils).periodBetween(#dates.createNow(), f.expiration)}" th:attr="data=${period.toStandardSeconds().getSeconds()}">
      剩 <strong th:text="${period.getDays()}">75</strong> 天 <strong th:text="${period.getHours()}">2</strong> 时 <strong th:text="${period.getMinutes()}">20</strong> 分
  </p>

```

>其中`DateUtils.java`如下：

```java
	public static Period periodBetween(Date startDate) {
		return periodBetween(startDate, new Date());
	}

	public static Period periodBetween(Date startDate, Date endDate) {
		DateTime start = new DateTime(startDate.getTime());
		DateTime end = new DateTime(endDate.getTime());
		return new Period(start, end, PeriodType.dayTime());
	}
```

#####3.7 迭代
>Thymeleaf 的迭代使用`th:each` 循环，`<tr th:each="user,userStat:${users}" th:class="${userStat.count} % 2 == 0 ? 'green':'gold'">`,userStat是状态变量，有 ***`index,count,size,current,even,odd,first,last`***等属性，如果没有显示设置状态变量，Thymeleaf会默认给个“变量名+Stat"的状态变量，也可直接修改

#####3.8 判断表达式
>`th:if`  与  `th:unless`

```
<tr th:each="prod : ${prods}" th:class="${prodStat.odd}? 'odd'">
    <td th:text="${prod.name}">Onions</td>
    <td th:text="${prod.inStock}? #{true} : #{false}">yes</td>
    <td><!-- display yes or no-->
      <span th:text="${#lists.size(prod.comments)}">2</span> comment/s
      <a href="comments.html" th:href="@{/product/comments(prodId=${prod.id})}" 
         th:if="${not #lists.isEmpty(prod.comments)}">view</a>
    </td>
</tr>    
```

>`th:switch th:case`

```
<div th:switch="${user.role}">
  <p th:case="'admin'">User is an administrator</p>
  <p th:case="#{roles.manager}">User is a manager</p>
  <p th:case="*">User is some other thing</p>
</div>
```

#####3.9 模板布局
###### 3.9.1 **th:fragment**
>- `th:fragment`，为片段标记，指定一个模板内一部分代码为一个片段。如`/WEB-INF/templates/fragments/header.html`页面内容如下：

```
<head th:fragment="header">
  <meta charset="UTF-8" />
  <title th:text="#{head.title}"></title>
  <link rel="shortcut icon" th:href="@{/static/img/favicon.gif}" type="image/gif" />
  <link rel="stylesheet" th:href="@{/resources/css/bootstrap.min.css}" />
  <script th:src="@{/resources/js/jquery-1.9.1.min.js}"></script>
  <script th:src="@{/resource/js/bootstrap.min.js}"></script>
</head>
```

###### 3.9.2 **th:include**与**th:replace**
>- `th:include`和`th:replace`的区别在于前者包含片段的内容到当前标签内，后者是用整个片段（内容和上一层）替换当前标签（不仅仅是标签内容）。若页面上需要包含上述`header.html`内容，可使用` <div th:include="fragments/header :: header "></div> ` ，相当于JSP中常用的  `<%@ include file="/WEB-INF/templates/fragments/header.jsp"%>`
>- 假如`/WEB-INF/templates/footer.html`内容为：

```
<div id="copy-section">
  &copy; 2011 The Good Thymes Virtual Grocery
</div>
```

>要包含此页面`th:include`可写成

```
<div th:include="footer :: #copy-section"></div>
```
>另一个典型的范例

```
  <div th:include="fragments/msgbox :: msgbox2(${message})"></div> 
<div class="msgbox" th:fragment="msgbox2(msg)">
<span  th:if="${msg != null}">
<script type="text/javascript" th:inline="javascript">
/*<![CDATA[*/
$.msgBox({
title: "信息"
, type: /*[[${#strings.toLowerCase(msg.type)}]]*/ 'info'
, content: /*[[${msg.message}]]*/ 'content'
});
/*]]>*/
</script>
</span>
</div>
```

###### 3.9.3 **th:remove**
>`th:remove` 为了静态显示时提供充分的数据，但是在模板被解析后，又不需要这些模拟的数据，需要将其删除
>>可选属性： `th:remove="all|body|tag|all-but-first"`，一般用于将mock数据在真实环境中移除，all表示移除标签以及标签内容，body只移除内容，tag只移除所属标签，不移除内容，all-but-first，除第一条外其它不移除。

>另外一种快捷的移除或附加代码方案：

```
================js附加代码：================
/*[+
var msg = 'This is a working application';
+]*/
================js移除代码：================
/*[- */
var msg = 'This is a non-working template';
/* -]*/
================html移除代码：================
<!--/*-->
...
<!--*/-->
```

#####3.10 属性优先级

>由于一个标签内可以包含多个th:x属性，其先后顺序为：**`include,replace,each,if/unless/switch/case,object,with,attr /attrprepend/attrappend,value/href,src ,etc,text/utext,fragment,remove`**

#####3.11 内联
######3.11.1 内联文本
>  内联文本：`[[...]]`内联文本的表示方式

```
<p th:inline="text">Hello, [[${session.user.name}]]!</p>
```
>可以替代为：

```
<p>Hello, <span th:text="${session.user.name}">Sebastian</span>!</p>
```

>使用时，必须先用`th:inline="text/javascript/none"`激活，th:inline可以在父级标签内使用，甚至作为body的标签。内联文本尽管比th:text的代码少，但是不利于原型显示

######3.11.2 内联JavaScript

```
<script type="text/javascript" th:inline="javascript">
    /*<![CDATA[*/
    var ctx = /*[[${#httpServletRequest.contextPath }]]*/''; //获取上下文路径
    var username = [[${session.user.name}]];//获取session域的user对象name属性值
    var code= /*[[${code}]]*/'';//js获取request域code的值 
    /*]]>*/
</script>
```

#####3.12 配合Enum使用

>Thymeleaf配置Enum使用Demo如下

```
 <select name="color-selector">
               <option th:each="color : ${T(com.florentlim.blog.ColorEnum).values()}" th:value="${color}" 
                     th:text="#{__${color.value}__}"      th:selected="${color == T(com.florentlim.blog.ColorEnum).NOCOLOR}">
                </option>
 </select>
```

#####3.13 调用Java静态类方法

>Thymeleaf直接调用Java静态类的Demo如下：

```
<div th:unless="${T(com.github.wenzhu.DateUtils).judgeTimeInterval()}">
```
>其中`DateUtils.java`的代码如下

```java
/**
	 * 判断当前时间是否在指定的时间范围内
	 * 
	 * @return true 是 , false 否
	 */
	public static boolean judgeTimeInterval() {
		Date nowDate = new Date();
		DateTime nDateTime = new DateTime(nowDate);
		DateTime startDateTime = new DateTime(2015, 11, 6,18, 20, 00, 0);
		DateTime endDateTime = new DateTime(2015, 11, 6, 18, 30, 00, 000);

		return nDateTime.isAfter(startDateTime) && nDateTime.isBefore(endDateTime);
	}
```

####4. Thymeleaf 更多配置

#####4.1 模板解析器
>Thymeleaf 使用继承`ITemplateResolver`的`ServletContextTemplateResolver`从Servlet上下文获取模板作为资源，另三个解析器分别为：`ClassLoaderTemplateResolver`，`FileTemplateResolver`，`UrlTemplateResolver`。Thymeleaf的模板模式有`XML  ， VALIDXML ，  XHTML ，  VALIDXHTML ，  HTML5 ， LEGACYHTML5`，默认使用`HTML5`，详见`StandardTemplateModeHandlers`类。Thymeleaf 严格验证html页面的标签关闭行为[^JIAOHUAN]，若要配置Thymeleaf对标签的关闭行为不敏感，需在`applicationContext.xml`配置如下信息：

```xml
<!-- View TemplateResolver -->
<bean id="templateResolver" class="org.thymeleaf.templateresolver.ServletContextTemplateResolver">
    <property name="templateMode" value="LEGACYHTML5"/>
    <property name="cacheable" value="false"/>
</bean>
```


#####4.2 与`shiro`框架整合
 >使用Thymeleaf作为前端模板引擎，使用HTML文件，没法引入shiro的tag lib，此时如果要使用shiro的话，可以引入 thymeleaf-extras-shiro.jar这个拓展包来曲线实现shiro的前端验证，在pom.xml中加入如下依赖：

```xml
  <dependency>
      <groupId>com.github.theborakompanioni</groupId>
      <artifactId>thymeleaf-extras-shiro</artifactId>
      <version>1.1.0</version>
   </dependency>
```

>引入jar包后，我们要简单设置一下thymeleaf的引擎：

```xml
<bean id="templateEngine" class="org.thymeleaf.spring4.SpringTemplateEngine">
  <property name="templateResolver" ref="templateResolver" />
  <property name="additionalDialects">
    <set>
      <bean class="at.pollux.thymeleaf.shiro.dialect.ShiroDialect"/>
    </set>
  </property>
   </bean>
```

>或者如果使用的是Java代码配置的话：

```java
public SpringTemplateEngine templateEngine() {
    SpringTemplateEngine templateEngine = new SpringTemplateEngine();
    templateEngine.setTemplateResolver(templateResolver());
     
    Set<IDialect> additionalDialects = new HashSet<IDialect>();
        additionalDialects.add(new ShiroDialect());
        templateEngine.setAdditionalDialects(additionalDialects);
        return templateEngine;
  }
```

#####4.3 相关配置

>普通的Spring项目，需在`spring-mvc.xml`配置：

```xml
	<!-- Thymeleaf -->
	<bean id="webTemplateResolver" class="org.thymeleaf.templateresolver.ServletContextTemplateResolver">
		<property name="order" value="2"/>
		<property name="prefix" value="/WEB-INF/views/" />
		<property name="suffix" value=".html" />
		<property name="templateMode" value="HTML5" />
		<property name="cacheable" value="false"/>
	</bean>
	 <!-- THYMELEAF: Template Engine (Spring4-specific version) -->
	<bean id="thymeleafTemplateEngine" class="org.thymeleaf.spring4.SpringTemplateEngine">
		<property name="templateResolver" ref="webTemplateResolver" />
		<!--
		<property name="additionalDialects">
			<set>
				<bean class="at.pollux.thymeleaf.shiro.dialect.ShiroDialect"/>
				<bean class="com.github.dandelion.thymeleaf.dialect.DandelionDialect" />
                <bean class="com.github.dandelion.datatables.thymeleaf.dialect.DataTablesDialect" />
			</set>
		</property>
		-->
	</bean>
	<!-- Thymeleaf解析器配置-->
<bean class="org.thymeleaf.spring4.view.ThymeleafViewResolver">
		<property name="templateEngine" ref="thymeleafTemplateEngine" />
		<property name="characterEncoding" value="UTF-8"/>
	</bean>
	<!-- Thymeleaf end -->
```

>`Spring boot`项目`application.properties`关于`Thymeleaf`的配置如下：

```
# THYMELEAF (ThymeleafAutoConfiguration)
spring.thymeleaf.check-template-location=true
spring.thymeleaf.prefix=classpath:/templates/
spring.thymeleaf.excluded-view-names= # comma-separated list of view names that should be excluded from resolution
spring.thymeleaf.view-names= # comma-separated list of view names that can be resolved
spring.thymeleaf.suffix=.html
spring.thymeleaf.mode=HTML5
spring.thymeleaf.encoding=UTF-8
spring.thymeleaf.content-type=text/html # ;charset=<encoding> is added
spring.thymeleaf.cache=true # set to false for hot refresh
```

####5. Thymeleaf 缓存

>- a、指定特定的缓存：
>>templateResolver.setCacheable(false);//默认是true，若需要实时查看页面变动信息，需设置为false
>>templateResolver.getCacheablePatternSpec().addPattern("/users/*");

>- b、清除缓存：
>>templateEngine.clearTemplateCache();
>>templateEngine.clearTemplateCacheFor("/users/userList");


[^JIAOHUAN]: **`area, base, br, col, embed, hr, img, input, keygen, link, meta, param, source, track, wbr`**

  [1]: http://www.jasypt.org/
  [2]: http://www.thymeleaf.org/
  [3]: http://www.thymeleaf.org/doc/tutorials/2.1/usingthymeleaf.html
  [4]: https://github.com/thymeleaf
