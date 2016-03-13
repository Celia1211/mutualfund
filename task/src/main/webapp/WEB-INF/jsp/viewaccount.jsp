<%@ include file="template-header.jsp" %>
<style type="text/css">
.hei {
    height:42px;
    width:400px;
  
}
 
</style> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script>
	window.onload = function () { document.getElementById("${tabName}Link").click(); }
</script>
<script src="<c:url value="/resources/js/plugins/datatables/jquery.dataTables.js"/>" type="text/javascript"></script>
<script src="<c:url value="/resources/js/plugins/datatables/dataTables.bootstrap.js"/>" type="text/javascript"></script>
    
<script type="text/javascript">
	$(function() {
		$("#positionTable").dataTable({
			"bPaginate": false
		});
		$("#completeTrans").dataTable({
			"bPaginate": false
		});
		$('#pendingTrans').dataTable({
        	"bPaginate": false,
        	"bLengthChange": false,
        	"bFilter": false,
        	"bSort": true,
        	"bInfo": true,
       	 	"bAutoWidth": false
    	});
	});
</script>
          <aside class="right-side">
          <section class="content-header">
                    <h1>
                        <font color=#0489B1>View Your Account</font>
                    </h1>
                </section>
                <section class="content">
 <div class="col-lg-12">
 <ul class="nav nav-tabs">
      <li><a id="custinfoLink" href="#custinfo" data-toggle="tab">Account Information</a></li>
      <li><a id="changepasswordLink" href="#changepassword" data-toggle="tab">Change Password</a></li>
       <li><a id="transitionLink" href="#transition" data-toggle="tab">Transaction History</a></li>
      <li><a id="requestCheckLink" href="#requestCheck" data-toggle="tab">Request Check</a></li>
 </ul>
    
<section class="tab-content">
  <article class="tab-pane" id="custinfo">
    <div class="col-lg-12">
    <div class ="col-lg-12">
    <div class="col-lg-4">
    <address>
    <strong>Address</strong>
    <br>${fn:escapeXml(user.addrLine1) }
    <br>${fn:escapeXml(user.addrLine2) }
    </address>
    </div>
    <div class="col-lg-4">
    <address>
    <strong>Last Trading Date</strong>
    <br>${lastExecutionDate}
    </address>
    </div>
        <div class="col-lg-4">
    <address>
    <strong>Total Cash Balance</strong>
    <br><fmt:formatNumber value="${user.presentCash }" type="currency" currencySymbol="$"/>
    (Pending Amount: <fmt:formatNumber value="${pendingCash }"
     	type="currency" currencySymbol="$" pattern="$#,##0.00;-$#,##0.00"/>)
    </address>
    </div>
    </div>
    <div class="row">
	    <div class="col-lg-12">
	    	<div class="box box-primary">
	            <div class="box-header">
	                <h3 class="box-title">Basic Information of the Fund You Own:</h3>                                    
	            </div>
	            <div class="box-body table-responsive">
	                <table id="positionTable" class="table table-bordered table-striped table-hover">
	                    <thead>
	                        <tr>
	                            <th width="120px">Fund Name</th>
					       		<th width="120px">Fund Ticker</th>
				       		    <th width="120px">Number of Shares</th>
				       		    <th width="120px">Last Closing Price</th>
				       		    <th width="120px">Value of Position</th>
				       		    <th width="120px">Operation</th>
				       		</tr>
	                    </thead>
	                    <tbody>
                            <c:forEach var="position" items="${positionList}">
	                            <tr>
	                            	<td><a href="tofunddetl?fundId=${position.fund.fundId}">${fn:escapeXml(position.fund.name)}</a></td>
				
									<td>${fn:escapeXml(position.fund.symbol)}</td>
									<td style="text-align:right">
									<fmt:formatNumber value="${position.presentShares}" type="number" minFractionDigits="3"/></td>
									<td style="text-align:right">
									<fmt:formatNumber value="${position.curSharePrice}" type="currency" currencySymbol="$"/>
									</td>
									<td style="text-align:right">
									<fmt:formatNumber value="${position.curSharePrice * position.presentShares}" type="currency" currencySymbol="$"/>
									</td>
									<td><a href="tobuyfund?fundId=${position.fund.fundId}" class="btn btn-primary">Buy</a>&nbsp;&nbsp;&nbsp;
									&nbsp;&nbsp;<a href="tosellfund?fundId=${position.fund.fundId}" class="btn btn-primary">Sell</a></td>
						    	</tr> 
							</c:forEach>
	                    </tbody>
	                </table>
	            </div>
	         </div>
	    </div>
	</div>
    </div>
    </article>
    <article class="tab-pane" id="changepassword">
    <div class="hei">
     <address><h4><b>Reset Password</b></h4></address>
	    <form method="post" action="custchangepassword" >
	    <p>Old Password</p>
			<input type="password" class="form-control" placeholder="Please input your old password"
			name="oldPassword" maxlength="100" value="" /><br> 
		<p>New Password</p>
			<input type="password" class="form-control" placeholder="At least 6 digit length"
			name="newPassword" maxlength="100"  value="" /><br> 
		<p>Confirm New Password:</p>
			<input type="password" class="form-control" placeholder="Please confirm your new password"
			name="confirmPassword" maxlength="100"  value="" /><br>
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
		<input type="submit" class="btn btn-primary btn-sm" name="button"
				value="Submit" />
		</form>
    </div>
  </article>
  
  <article class="tab-pane" id="transition">
	<h4>Your transaction history is as follows:</h4>
                    <div class="row">
                        <div class="col-sm-12">
                        	<div class="box box-primary">
                                <div class="box-header">
                                    <h3 class="box-title">Pending Transactions</h3>                                    
                                </div><!-- /.box-header -->
                                <div class="box-body table-responsive">
                                    <table id="pendingTrans" class="table table-bordered table-striped table-hover">
                                        <thead>
                                            <tr>
                                                <th width="120px">Operation</th>
                                                <th width="120px">Ticker</th>
                                                <th width="120px">Fund Name</th>
                                                <th width="120px">Shares Number</th>
                                                <th width="100px">Dollar Amount</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        	<c:forEach var="transaction" items="${transactionPendingList}">
                                        	<tr>
												<td><span class="label label-primary">${transaction.transactionType}</span></td>
												<td>${fn:escapeXml(transaction.fund.symbol)}</td>
												<td><a href="tofunddetl?fundId=${transaction.fund.fundId}">${fn:escapeXml(transaction.fund.name)}</a></td>
												<td style="text-align:right"><fmt:formatNumber value="${transaction.presentShares}" type="number" minFractionDigits="3"/></td>
												<td style="text-align:right">
												<fmt:formatNumber value="${transaction.presentAmount}" type="currency" currencySymbol="$"/>
												</td>
											</tr>
											</c:forEach>
                                        </tbody>
                                    </table>
                                </div><!-- /.box-body -->
                            </div><!-- /.box -->
                            
                            <div class="box box-primary">
                                <div class="box-header">
                                    <h3 class="box-title">Complete Transactions</h3>                                    
                                </div><!-- /.box-header -->
                                <div class="box-body table-responsive">
                                    <table id="completeTrans" class="table table-bordered table-striped table-hover">
                                        <thead>
                                            <tr>
                                            	<th width="120px">Date of Execution</th>
                                                <th width="120px">Operation</th>
                                                <th width="120px">Fund Name</th>
                                                <th width="120px">Ticker</th>
                                                <th width="120px">Number of Shares</th>
                                                <th width="120px">Current Share Price</th>
                                                <th width="100px">Dollar Amount</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                    	<c:forEach var="transaction" items="${transactionCompleteList}">
                                    		<tr>
									
												<td> <fmt:formatDate pattern="MM-dd-yyyy" value="${transaction.executeDate}"/></td>
											
												<td><span class="label label-primary">${transaction.transactionType}</span></td>
											<td><a href="tofunddetl?fundId=${transaction.fund.fundId}">${fn:escapeXml(transaction.fund.name)}</a></td>
											
												<td>${fn:escapeXml(transaction.fund.symbol)}</td>
												<td style="text-align:right"><fmt:formatNumber value="${transaction.presentShares}" type="number" minFractionDigits="3"/></td>
												<td style="text-align:right">
												<fmt:formatNumber value="${transaction.presentSharePrice}" type="currency" currencySymbol="$"/>
												</td>
												<td style="text-align:right">
												<fmt:formatNumber value="${transaction.presentAmount}" type="currency" currencySymbol="$"/>
												</td>
											</tr>
										</c:forEach>
                                    </tbody>
                                </table>
            	</div>
        	</div>
    	</div>
  	</div>
  </article>
  
  <article class="tab-pane" id="requestCheck">
  	<font size="3">
	 <div class="alert alert-info alert-dismissable">
     	Your total cash balance is <fmt:formatNumber value="${user.presentCash}"
     	type="currency" currencySymbol="$"/>, with a pending amount of <fmt:formatNumber value="${pendingCash }"
     	type="currency" currencySymbol="$" pattern="$#,##0.00;-$#,##0.00"/>,<br>
     	so your available amount now is <fmt:formatNumber value="${user.presentCash+pendingCash }"
     	type="currency" currencySymbol="$" pattern="$#,##0.00;-$#,##0.00"/>. You can only spend less than the available amount.<br>
     	You cannot request more than $100,000 per check.
     </div>
     </font>
     <div class="content">
	 <p>Amount:</p>
	 <form class="hei" method="post" action="requestcheck">
	 	<div class="input-group">
	 		<span class="input-group-addon">$</span>
	 		<input type="text" maxlength="100" class="form-control" name="checkNumber" pattern="^[0-9]*\.?[0-9]{0,2}$" placeholder="Up to 2 decimal digits"
						value="" />
		</div><br>
		<c:if test="${!(empty requestErrorMsgs)}">
			<div class="alert alert-danger alert-dismissable">
	    	<i class="fa fa-warning"></i>
	    	<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
	    	<c:forEach var="errorMsg" items="${requestErrorMsgs}">
			<b>${errorMsg}</b><br>
			</c:forEach>
	 	   	</div>
		</c:if>
		<c:if test="${empty requestErrorMsgs and !(empty requestMessage)}">
			<div class="alert alert-success alert-dismissable">
	    	<i class="fa fa-check"></i>
	    	<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
	    	<b>${requestMessage} You have requested $${param.checkNumber} check.</b>
			</div>
		</c:if>
		<div class="form-group">
			<input type="submit" class="btn btn-primary" name="button"
			value="Request Check" />
		</div>

	</form>
	</div>
   </article>
  
 </section>
</div>
 
</body>
</html>

<%@ include file="template-footer.jsp" %>
