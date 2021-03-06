<%-- 
    Document   : updateSuperAdminDetailsToDB
    Created on : 22 Jan, 2022, 10:44:06 AM
    Author     : SIVASANKAR
--%>

<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->

<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<html>
    <head>
        <title>Updating SuperAdmin Details</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="bootstrap.min.css">
        <link rel="icon" type="text/css" href="images/test.png">
    </head>
    <body>
        <% 
            if(session.getAttribute("sid")==null)
            {
                response.sendRedirect("superAdminLogin.jsp");
            }
        %>
        <jsp:include page="base.jsp"/>
        <sql:setDataSource var="db" driver="com.mysql.jdbc.Driver" url="jdbc:mysql://localhost:3306/demo2?useSSL=false&allowPublicKeyRetrieval=true" user="siva" password="0000"/>
        <sql:update dataSource="${db}" var="add">  
            update superAdmin set email=?,password=? where superAdminId=?
            <sql:param value="${param.formNewEmail}"/>
            <sql:param value="${param.formNewPsw}"/>
            <sql:param value="${sessionScope.sid}"/>
        </sql:update>  
        
        <c:choose>
            <c:when test="${add>=1}">
                <c:redirect url="superAdminHome.jsp"/>
            </c:when>
            <c:otherwise>
                <c:redirect url="superAdminProfileFailedtoUpdate.jsp"/>
            </c:otherwise>
        </c:choose>
           
    </body>
</html>
