<%-- 
    Document   : addQuestionForm
    Created on : 3 Dec, 2021, 12:05:23 PM
    Author     : SIVASANKAR
--%>

<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add Question</title>
        <link rel="stylesheet" type="text/css" href="bootstrap.min.css">
        <link rel="icon" type="text/css" href="images/test.png">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    </head>
    <body>
        <% 
            if(session.getAttribute("fid")==null)
            {
                response.sendRedirect("facultyLogin.jsp");
            }
        %>
        <jsp:include page="base.jsp"/>
        <nav class="navbar navbar-expand bg-dark navbar-dark" id="navbar">
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="collapsibleNavbar">
                <ul class="navbar-nav ml-auto">
                    <li class="nav-item">
                        <form method="post" action="sendMailToStudent">
                            <input type="submit" value="Send Emails to Students" class="btn btn-outline-primary">
                        </form>
                    </li>
                </ul>
            </div>
        </nav>
        
        
        <div class="container mt-5">
            <c:choose>
                <c:when test="${sessionScope.message==null}">
                    
                </c:when>
                
                <c:when test="${sessionScope.message=='success'}">
                    <div class="alert alert-dismissible bg-success fade show" id="dismiss">
                        <div><strong>Success! </strong>Question added Successfully</div>
                        <a href="#" class="close" data-dismiss="alert" id="x" aria-label="close">&times;</a>
                    </div>
                    <c:remove var="message" scope="session"/>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-dismissible bg-danger fade show" id="dismiss">
                        <div><strong>Failed! </strong>Question failed to add</div>
                        <a href="#" class="close" data-dismiss="alert" id="x" aria-label="close">&times;</a>
                    </div>
                    <c:remove var="message" scope="session"/>
                </c:otherwise>
                 
            </c:choose>
            
            
            <div class="jumbotron bg-info">
                <form method="post" action="questionAddedToExam.jsp">
                    <fieldset>
                        <legend class="bg-dark text-light"> <h2>Add a Question</h2></legend>
                        <input type="text" name="formQuestionName" placeholder="Enter Question" class="form-control my-2" required>
                        <input type="text" name="formOpt1" placeholder="Enter Option1" class="form-control my-2" required>
                        <input type="text" name="formOpt2" placeholder="Enter Option2" class="form-control my-2" required>
                        <input type="text" name="formOpt3" placeholder="Enter Option3" class="form-control my-2">
                        <input type="text" name="formOpt4" placeholder="Enter Option4" class="form-control my-2">
                        <input type="number" name="formAns" placeholder="Enter option number of answer" class="form-control my-2" required>
                        <input type="number" name="formQuestionMarks" placeholder="Enter marks" value="1" class="form-control my-2" required>
                        
                        <div class="row">
                            <div class="col">
                                <a href="facultyHome.jsp" class="btn btn-primary form-control my-2">Back</a>
                            </div>
                            <div class="col">
                                <input type="submit" value="ADD" class="form-control my-2 btn btn-success"/>
                            </div>
                        </div> 
                    </fieldset>
                </form>
            </div>
        </div>
        
        <jsp:include page="questions.jsp"/>
    </body>
</html>