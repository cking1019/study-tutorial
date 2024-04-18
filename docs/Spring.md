# 一、Spring & SpringMVC

## 1、控制反转(IoC)

Spring框架通过控制反转机制实现对对象的解耦，由容器负责创建和管理对象的生命周期，将对象之间的依赖关系交由框架来管理，减少代码之间的耦合性，提高代码的可维护性与可测试性。

## 2、面向切面编程(AOP)

Spring框架支持面向切面编程，通过AOP可以将与业务逻辑无关的横切关注点(如日志记录、事务管理等)从业务中剥离出来，以模块化的方式进行管理，提高代码的可重用性和可维护性

## 3、包介绍

- spring-aop：提供面向切面编程，允许将横切关注点从业务逻辑中解耦出来
- spring-beans：提供bean的定义、创建和管理相关的功能，包括依赖注入和控制反转等
- spring-context：提供了应用程序上下文的支持，包括bean的生命周期管理等
- spring-core：提供了spring框架的核心功能，包括依赖注入、类型转换、资源管理等
- spring-expression：提供了强大的表达式语言，可以在运行时动态求值，用于配置和处理bean
- spring-jdbc：提供了与数据库交互的支持，包括数据源配置、JDBC操作、事务管理等
- spring-orm：提供了与对象关系映射框架的集成支持，比如Hibernate、Mybatis等
- spring-web：提供了与web开发相关的功能，包括web请求处理、web安全、web服务等
- spring-webmvc：提供了基于MVC(模型-视图-控制器)的web应用程序开发支持，包括处理器映射、视图解析、数据绑定等。

## 4、spring-mvc配置文件

~~~xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/mvc
						http://www.springframework.org/schema/mvc/spring-mvc-4.0.xsd
						http://www.springframework.org/schema/beans
						http://www.springframework.org/schema/beans/spring-beans-4.0.xsd
						http://www.springframework.org/schema/context
          				http://www.springframework.org/schema/context/spring-context-4.0.xsd">
    <!--加载数据源-->
    <context:property-placeholder location="classpath:jdbc-config.properties"/>
    <!--自动注册Bean，例如标记了@Component、@Service、@Controller注解等-->
    <context:component-scan base-package="com.ck" />
	<!--自动注册请求映射等，例如@RequestMapping、@RequestParm等注解-->
    <mvc:annotation-driven/>
	<!--<mvc:resources mapping="/page/**" location="/static/"/>-->
    <!--确保静态资源无需经过SpringMVC处理的请求能够被正确地处理-->
    <mvc:default-servlet-handler />
    
    <!--拦截器-->
    <!--
    ‘/’：  web项目的根目录；
    ‘/*’： 所有文件夹且不含子文件夹；
    ‘/**’：所有文件夹且包括子文件夹。
    -->
    <mvc:interceptors>
        <mvc:interceptor>
            <!--拦截器的路径选择。-->
            <mvc:mapping path="/**"/>
            <!--拦截器的限定类-->
            <bean class="com.ck.config.LoginInterceptor"/>
        </mvc:interceptor>
    </mvc:interceptors>
	
    <!--注册数据源-->
    <bean id="dataSource" class="org.springframework.jdbc.datasource.DriverManagerDataSource">
        <property name="driverClassName" value="${jdbc.driver}"/>
        <property name="url" value="${jdbc.url}"/>
        <property name="username" value="${jdbc.username}"/>
        <property name="password" value="${jdbc.password}"/>
    </bean>
	
    <!--注册sql对话工厂-->
    <bean id="sessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
        <property name="dataSource" ref="dataSource"/>
        <property name="mapperLocations" value="classpath:com.ck.mapper/UserMapper.xml"/>
    </bean>

    <bean id="sqlSession" class="org.mybatis.spring.SqlSessionTemplate">
        <constructor-arg index="0" ref="sessionFactory"/>
    </bean>
    
	<!--视图解析器-->
    <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
        <property name="prefix" value="/jsp/" />
        <property name="suffix" value=".jsp" />
    </bean>
	
    <!--文件解析器-->
    <bean id="multipartResolver" class="org.springframework.web.multipart.commons.CommonsMultipartResolver">
        <property name="defaultEncoding" value="utf-8"/>
        <property name="maxUploadSize" value="10485760"/>
    </bean>
</beans>
~~~

## 5、web.xml配置文件 

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xmlns="http://java.sun.com/xml/ns/javaee" xmlns:web="http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd"
         xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd"
         id="WebApp_ID" version="3.0">
    
<!--目录下的所有文件映射到当前的servlet-->
<servlet>
    <servlet-name>springmvc</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <init-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>classpath:springmvc-config.xml</param-value>
    </init-param>
</servlet>
<servlet-mapping>
    <servlet-name>springmvc</servlet-name>
    <url-pattern>/</url-pattern>
</servlet-mapping>

<!--过滤数据-->
<filter>
    <filter-name>characterEncodingFilter</filter-name>
    <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
    <init-param>
        <param-name>encoding</param-name>
        <param-value>utf-8</param-value>
    </init-param>
</filter>
<filter-mapping>
    <filter-name>characterEncodingFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

## 6、访问静态资源

~~~xml
<!--当DispatcherServlet收到/page/开头的请求时，会自动在类路径/static中查找资源文件，然后再进行响应-->
<bean id="/page/*" class="org.springframework.web.servlet.resource.ResourceHttpRequestHandler">
    <property name="locationValues" value="classpath:/static/"/>
</bean>
<!--上面表达式等价于下面这种，并更推荐写第二种方式-->
<mvc:resources mapping="/static/**" location="/page/" />
~~~



