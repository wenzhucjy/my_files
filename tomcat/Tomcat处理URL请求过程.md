### Tomcat处理URL请求过程

> 请求地址`url`为`http://hostname:port/contextPath/servletPath`的处理过程(如`http://localhost:8080/example/index.jsp`)：

```
1. TCP三次握手，其中url中的hostname与port用于建立TCP连接，contextPath与servletPath则是与服务器进行请求的信息，contextPath指明了与服务器中哪个Context容器进行交互，服务器会根据这个URL与对应的Context容器建立连接

2. 在端口8080启动Server，并通知Service完成启动，Service通知Connector完成初始化和启动过程

3. Connector首先收到这个请求，会调用ProtocolHandler完成http协议的解析，然后交给SocketProcessor处理，解析请求头，再交给CoyoteAdapter解析请求行和请求体，并把解析信息封装到Request和Response对象中

4. 把请求(此时应该是Request对象，这里的Request对象已经封装了http请求的信息)交给Container容器

5. Container容器交给Engine子容器，并等待Engine容器的处理结果

6. Engine容器匹配所有的虚拟主机，这里匹配到Host

7. 请求被移交给hostname为localhost的Host容器，如果匹配不到就把该请求交给路径名为""的Context去处理

8. 请求再次被移交给Context容器，Context容器继续匹配其子容器Wrapper，由子容器Wrapper加载index.jsp对应的Servlet，编译的Servlet为*_jsp。class文件

9. Context容器根据后缀匹配原则*.jsp找到index.jsp编译的java类的class文件

10. Connector构建一个 org.apache.catalina.connector.Request 以及 org.apache.catalina.connector.Response 对象，使用反射调用Servlet的service方法

11. Context容器把封装了响应消息的Response对象返回给Host容器

12. Host容器把Response返回给Engine容器

13. Engine容器返回给Connector

14. Connector 容器把 Response返回给浏览器

15. 浏览器解析Response报文并显示资源内容
```
