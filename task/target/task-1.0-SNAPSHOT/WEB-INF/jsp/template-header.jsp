<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Mutual Fund System - Prime 13</title>
<meta
	content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no'
	name='viewport'>
<link href="<c:url value="/resources/css/bootstrap.min.css"/>" rel="stylesheet" type="text/css">
<link href="<c:url value="/resources/css/font-awesome.min.css"/>" rel="stylesheet" type="text/css">
<link href="<c:url value="/resources/css/ionicons.min.css"/>" rel="stylesheet" type="text/css">
<link href="<c:url value="/resources/css/datatables/dataTables.bootstrap.css"/>" rel="stylesheet" type="text/css">
<link href="<c:url value="/resources/css/morris/morris.css"/>" rel="stylesheet" type="text/css">
<link href="<c:url value="/resources/js/plugins/datatables/jquery.dataTables.js"/>" rel="stylesheet" type="text/css">
<link href="<c:url value="/resources/js/plugins/datatables/dataTables.bootstrap.js"/>" rel="stylesheet" type="text/css">
<!-- jvectormap -->
<link href="<c:url value="/resources/css/jvectormap/jquery-jvectormap-1.2.2.css"/>" rel="stylesheet" type="text/css">
<!-- bootstrap wysihtml5 - text editor -->
<link href="<c:url value="/resources/css/bootstrap-wysihtml5/bootstrap3-wysihtml5.min.css"/>" rel="stylesheet" type="text/css">
<!-- Theme style -->
<link href="<c:url value="/resources/css/AdminLTE.css"/>" rel="stylesheet" type="text/css">
<link rel="stylesheet" type="text/css" href="//code.jquery.com/ui/1.9.2/themes/base/jquery-ui.css">
<!-- jQuery 2.0.2 -->
<script src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
<script type="text/javascript" src="//code.jquery.com/ui/1.9.2/jquery-ui.js"></script>
<!-- jQuery UI 1.10.3 -->
<script src="<c:url value="/resources/js/jquery-ui-1.10.3.min.js"/>" type="text/javascript"></script>
<!-- Bootstrap -->
<script src="<c:url value="/resources/js/bootstrap.min.js"/>" type="text/javascript"></script>
<!-- Morris.js charts -->
<script src="http://cdnjs.cloudflare.com/ajax/libs/raphael/2.1.0/raphael-min.js"></script>
<script src="<c:url value="/resources/js/plugins/morris/morris.min.js"/>" type="text/javascript"></script>

<!-- jvectormap -->
<script src="<c:url value="/resources/js/plugins/jvectormap/jquery-jvectormap-1.2.2.min.js"/>" 
	type="text/javascript"></script>
<script src="<c:url value="/resources/js/plugins/jvectormap/jquery-jvectormap-world-mill-en.js"/>" 
	type="text/javascript"></script>

<!-- Bootstrap WYSIHTML5 -->
<script src="<c:url value="/resources/js/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js"/>" 
	type="text/javascript"></script>

<!-- Side bar -->
<script src="<c:url value="/resources/js/AdminLTE/app.js"/>" type="text/javascript"></script>

<script type='text/javascript'>
$(window).load(function(){
$(function() {
	$('#myreset').click(
			function() {
				$(':input', '#form').not(
						':button, :submit, :reset, :hidden, #mydate')
						.val('').removeAttr('checked')
						.removeAttr('selected');
				});
	});
});
</script>
</head>

<body class="skin-blue">
    
        <header class="header">
        	<c:if test="${role == 'Employee'}">
            	<a href="totransiday" class="logo">Mutual Fund</a>
            </c:if>
            <c:if test="${role == 'Customer'}">
            	<a href="toviewacct?tabName=custinfo" class="logo">Welcome!</a>
            </c:if>
            <nav class="navbar navbar-static-top" role="navigation">
                <!-- Sidebar toggle button-->
                <a href="#" class="navbar-btn sidebar-toggle" data-toggle="offcanvas" role="button">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </a>
                <div class="navbar-right">
                    <ul class="nav navbar-nav">
                       <a href="logout" class="btn">Sign out</a>
                    </ul>
                </div>
            </nav>
        </header>
        <div class="wrapper row-offcanvas row-offcanvas-left">
            <!-- Left side column. contains the logo and sidebar -->
            <aside class="left-side sidebar-offcanvas">
                <section class="sidebar">
                    <div class="user-panel">
                        <div class="pull-left info">
                            <p>Hello, ${fn:escapeXml(user.firstname)}</p>
                        </div>
                    </div>

                 <!-- if visitor, nothing --> 
                 
                 <!-- if customer -->   
				 <c:if test="${role == 'Customer'}">
                    <ul class="sidebar-menu">
					<li><a href="toresearchfund"> <i class="fa fa-dashboard"></i> 
						<span>Research Fund</span>
					</a></li>
					<li><a href="toviewacct?tabName=custinfo"> <i class="fa fa-list-alt"></i> 
						<span>Account Information</span>
					</a></li>
					<li><a href="toviewacct?tabName=changepassword"> <i class="fa fa-briefcase"></i> 
						<span>Change Password</span>
					</a></li>
					<li><a href="toviewacct?tabName=transition"> <i class="fa fa-calendar"></i> 
						<span>Transaction History</span>
					</a></li>
					<li><a href="toviewacct?tabName=requestCheck"> <i class="fa fa-edit"></i> 
						<span> Request Check</span>
					</a></li>
					</ul>
				</c:if>

				<!-- if employee -->
				<c:if test="${role == 'Employee'}">
					<ul class="sidebar-menu">

						<li><a href="totransiday"> <i class="fa fa-table"></i> 
							<span>Transition Day</span>
						</a></li>
						<li><a href="tochgpwd"> <i class="fa fa-briefcase"></i>
							<span>Change Password</span>
						</a></li>
						<li><a href="toviewcustlist"> <i class="fa fa-laptop"></i>
								<span>View Customer</span>
						</a></li>
						<li><a href="tocreatefund"> <i class="fa fa-edit"></i> 
							<span>Create Fund </span>
						</a></li>
						<li><a href="tocreatecust"> <i class="fa fa-edit"></i> 
							<span>Create Customer </span>
						</a></li>
						<li><a href="tocreateemp"> <i class="fa fa-edit"></i> 
							<span>Create Employee </span>
						</a></li>
							</ul>
						</li>
					</ul>
				</c:if>
			</section>
                <!-- /.sidebar -->
          </aside>

          <!-- Right side column. Contains the content of the page -->

                    