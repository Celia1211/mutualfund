<%@ include file="template-header.jsp" %>
<style type="text/css">
.hei {
    height:42px;
    width:400px;
}
 
</style>
	          <aside class="right-side">
          <section class="content-header">
                    <h1>
                        <font color=#0489B1>Change Password</font>
                    </h1>
                </section>
                <section class="content">
          

	<form method="post" action="changepassword" class="hei" id="form">
		
		<label for="oldpassword"><font size="4">Old Password:</font></label>
			<input type="password" class="hei"  placeholder="Please input your old password"
				name="oldPassword" /><br> <br>
		<label for="newpassword"><font size="4">New Password:</font></label>
		
					<input type="password" class="hei"   placeholder="At least 6 digit length"
				name="newPassword" /><br> <br>
		<label for="confirmpassword"><font size="4">Confirm New Password:</font></label>
					<input type="password" class="hei"  placeholder="Please confirm your new password"
				name="confirmPassword" /><br> <br>
		
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
		<c:if test="${empty errorMsgs and !(empty message)}">
			<div class="alert alert-success alert-dismissable">
            <i class="fa fa-check"></i>
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <b>${message}</b>
        	</div>
		</c:if>
		</div>
		<br>
		<br>
		<div class="form-group"> 
	 		<div class="col-sm-offset-3 col-sm-3"> 
				<button type="submit" class="btn btn-primary">Submit</button>
			</div> 
			<div class="col-sm-offset-1 col-sm-5"> 
				<button type="button" class="btn btn-primary" id="myreset">Reset</button>
			</div> 
		</div>
	</form>
</font>
</div>
<%@ include file="template-footer.jsp" %>