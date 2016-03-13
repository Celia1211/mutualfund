<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html class="bg-black">
    <head>
        <meta charset="UTF-8">
        <title>Mutual Fund System | Log in</title>
        <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
        <link href="<c:url value="/resources/css/bootstrap.min.css" /> "rel="stylesheet" type="text/css">
        <link href="<c:url value="/resources/css/font-awesome.min.css" /> "rel="stylesheet" type="text/css">
        <link href="<c:url value="/resources/css/AdminLTE.css" /> "rel="stylesheet" type="text/css" >
        <link href="<c:url value="/resources/css/morris/morris.css"/>" rel="stylesheet" type="text/css" >
        <link href="<c:url value="/resources/css/ionicons.min.css"/>" rel="stylesheet" type="text/css" >
        <link href="<c:url value="/resources/css/bootstrap-wysihtml5/bootstrap3-wysihtml5.min.css"/>" rel="stylesheet" type="text/css">
        <script src="<c:url value="/resources/js/jquery-ui-1.10.3.min.js"/>" type="text/javascript"></script>
        <script src="<c:url value="/resources/js/bootstrap.min.js"/>" type="text/javascript"></script>
        <script src="http://cdnjs.cloudflare.com/ajax/libs/raphael/2.1.0/raphael-min.js"></script>
        <script src="<c:url value="/resources/js/plugins/morris/morris.min.js"/>" type="text/javascript"></script>
        <script src="<c:url value="/resources/js/plugins/sparkline/jquery.sparkline.min.js"/>" type="text/javascript"></script>
        <script src="<c:url value="/resources/js/plugins/jvectormap/jquery-jvectormap-1.2.2.min.js"/>" type="text/javascript"></script>
        <script src="<c:url value="/resources/js/plugins/jvectormap/jquery-jvectormap-world-mill-en.js"/>" type="text/javascript"></script>
        <script src="<c:url value="/resources/js/plugins/jqueryKnob/jquery.knob.js"/>" type="text/javascript"></script>
        <script src="<c:url value="/resources/js/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js"/>" type="text/javascript"></script>
        <script src="<c:url value="/resources/js/plugins/iCheck/icheck.min.js"/>" type="text/javascript"></script>
    </head>
    <body class="bg-black">
        <div class="form-box" id="login-box">
            <div class="header bg-blue" >Log In</div>
            <form action="login" method="post">
                <div class="body bg-gray">
                    <div class="form-group">
                        <input type="text" maxlength="100" name="username" class="form-control" placeholder="Email Address"/>
                    </div>
                    <div class="form-group">
                        <input type="password" maxlength="100"  name="password" class="form-control" placeholder="Password"/>
                    </div>          
                </div>
                <div class="footer">                                                               
                    <button type="submit" class="btn bg-blue btn-block">Log in</button>  
                </div>
                <div>
                <c:if test="${!(empty errorMsgs)}">
					<div class="alert alert-danger alert-dismissable">
			    	<i class="fa fa-warning"></i>
			    	<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
			    	<c:forEach var="errorMsg" items="${errorMsgs}">
					<b>${errorMsg}</b><br>
					</c:forEach>
		  	   		</div>
				</c:if>
				</div>
            </form>
        </div>
	<br>
	<br>
  </body>
</html>