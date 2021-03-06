<%-- 
    Document   : studentAnswers
    Created on : 28 Jan, 2022, 8:05:06 PM
    Author     : SIVASANKAR
--%>

<!DOCTYPE html>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Student Answers</title>
        <link rel="stylesheet" type="text/css" href="bootstrap.min.css">
        <link rel="icon" type="text/css" href="images/test.png">
    </head>
    <body style="overflow-x:hidden">
        <% 
            if(session.getAttribute("fid")==null)
            {
                response.sendRedirect("facultyLogin.jsp");
            }
        %>
        <%
            HttpSession ses1=request.getSession();
            ses1.setAttribute("examSpecialTableName", "examSpecialTable"+session.getAttribute("eid").toString());
            ses1.setAttribute("questionsTableName", "questions"+session.getAttribute("fid").toString());
        %>
        <jsp:include page="base.jsp"/>
        <nav class="navbar navbar-expand bg-dark navbar-dark" id="navbar">
            <% 
                HttpSession ses3=request.getSession();
                String questionsTableName = "questions"+ses3.getAttribute("fid").toString(); 
                ses3.setAttribute("questionsTableName", questionsTableName);
            %>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="collapsibleNavbar">
                <ul class="navbar-nav ml-auto">
                    <li class="nav-item text-light">
                        <c:out value="Correctly Answered"/>
                        <sql:setDataSource var="db" driver="com.mysql.jdbc.Driver" url="jdbc:mysql://localhost:3306/demo2?useSSL=false&allowPublicKeyRetrieval=true" user="siva" password="0000"/>
                        <sql:query dataSource="${db}" var="corrects">
                            select count(*) correct from ${sessionScope.examSpecialTableName} where marksObtained>0 and regdNo=?;
                            <sql:param value="${param.formRegdNo}"/>
                        </sql:query>
                        <c:forEach var="row" items="${corrects.rows}">
                            <span style="font-size: 25px;color: orchid"><c:out value="${row.correct}"/></span>
                        </c:forEach>
                    </li> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    
                    <li class="nav-item text-light">
                        <c:out value="Wrongly Answered"/>
                        <sql:query dataSource="${db}" var="wrongs">
                            select count(*) wrong from ${sessionScope.examSpecialTableName} where marksObtained<=0 and regdNo=?;
                            <sql:param value="${param.formRegdNo}"/>
                        </sql:query>
                        <c:forEach var="row" items="${wrongs.rows}">
                            <span style="font-size: 25px;color: orchid"><c:out value="${row.wrong}"/></span>
                        </c:forEach>
                    </li> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    
                    <li class="nav-item text-light">
                        <c:out value="Skipped/Unanswered"/>
                        <sql:query dataSource="${db}" var="skips">
                            select count(*) skip from ${sessionScope.examSpecialTableName} where marksObtained is null and regdNo=?;
                            <sql:param value="${param.formRegdNo}"/>
                        </sql:query>
                        <c:forEach var="row" items="${skips.rows}">
                            <span style="font-size: 25px;color: orchid"><c:out value="${row.skip}"/></span>
                        </c:forEach>
                    </li> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    
                    <li class="nav-item text-light">
                        <c:out value="Doesn't seen"/>
                        <sql:query dataSource="${db}" var="qc">
                            select count(*) qcount from ${sessionScope.questionsTableName} where examId=?;
                            <sql:param value="${sessionScope.eid}"/>
                        </sql:query>
                        <sql:query dataSource="${db}" var="seen">
                            select count(*) see from ${sessionScope.examSpecialTableName} where regdNo=?;
                            <sql:param value="${param.formRegdNo}"/>
                        </sql:query>
                        <c:forEach var="row1" items="${qc.rows}">
                            <c:forEach var="row2" items="${seen.rows}">
                                <span style="font-size: 25px;color: orchid"><c:out value="${row1.qcount-row2.see}"/></span>
                            </c:forEach>
                        </c:forEach>
                    </li> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    
                    <li class="nav-item">
                        <form method="post" action="examResults.jsp">
                            <input type="submit" value="Back" class="btn btn-outline-info">
                        </form>
                    </li> &nbsp;&nbsp;&nbsp;
                </ul>
            </div>
        </nav>
        <sql:setDataSource var="db" driver="com.mysql.jdbc.Driver" url="jdbc:mysql://localhost:3306/demo2?useSSL=false&allowPublicKeyRetrieval=true" user="siva" password="0000"/>
        <sql:query dataSource="${db}" var="result">
            select * from ${sessionScope.questionsTableName} where examId=?;
            <sql:param value="${sessionScope.eid}"/>
            
        </sql:query>
        <div class="container mt-5">
            <div class="jumbotron bg-info">
                <c:forEach items="${result.rows}" var="q">
                    <sql:query dataSource="${db}" var="result2">
                        select * from ${sessionScope.examSpecialTableName} where qid=? and regdNo=?;
                        <sql:param value="${q.questionId}"/>
                        <sql:param value="${param.formRegdNo}"/>
                    </sql:query>
                        <c:forEach items="${result2.rows}" var="e">
                            <c:choose>
                                <c:when test='${e.selectedOptions=="" || e.selectedOptions==null}'>
                                    <div class="jumbotron bg-warning">
                                        <h4>${q.questionName}</h4>
                                        Option1 :  ${q.opt1} <br>
                                        Option2 :  ${q.opt2} <br/>
                                        <c:if test='${q.opt3!="" || q.opt3!=null}'>
                                            Option3 :  ${q.opt3} <br/>
                                        </c:if>
                                        <c:if test='${q.opt4!="" || q.opt4!=null}'>
                                            Option4 :  ${q.opt4} <br/>
                                        </c:if>
                                        Correct Answer : ${q.ans} <br/>
                                        Student Answer : 
                                    </div>
                                </c:when>
                                <c:when test="${q.ans==e.selectedOptions}">
                                    <div class="jumbotron bg-success">
                                        <h4>${q.questionName}</h4>
                                        Option1 :  ${q.opt1} <br>
                                        Option2 :  ${q.opt2} <br/>
                                        <c:if test='${q.opt3!="" || q.opt3!=null}'>
                                            Option3 :  ${q.opt3} <br/>
                                        </c:if>
                                        <c:if test='${q.opt4!="" || q.opt4!=null}'>
                                            Option4 :  ${q.opt4} <br/>
                                        </c:if>
                                        Correct Answer : ${q.ans} <br/>
                                        Student Answer : ${e.selectedOptions}
                                    </div>
                                            
                                </c:when>
                                <c:when test="${q.ans!=e.selectedOptions}">
                                    <div class="jumbotron bg-danger">
                                        <h4>${q.questionName}</h4>
                                        Option1 :  ${q.opt1} <br>
                                        Option2 :  ${q.opt2} <br/>
                                        <c:if test='${q.opt3!="" || q.opt3!=null}'>
                                            Option3 :  ${q.opt3} <br/>
                                        </c:if>
                                        <c:if test='${q.opt4!="" || q.opt4!=null}'>
                                            Option4 :  ${q.opt4} <br/>
                                        </c:if>
                                        Correct Answer : ${q.ans} <br/>
                                        Student Answer : ${e.selectedOptions}
                                    </div>
                                            
                                </c:when>
                            </c:choose>
                        </c:forEach>
                </c:forEach>
            </div>
        </div>
    </body>
</html>
            