<%@ include file="template-header.jsp" %>
<style type="text/css">
.hei {
    height:42px;
    width:400px;
  
}
 
</style> 
<script>
	window.onload = function () { document.getElementById("${tabName}Link").click(); }
</script>
          <aside class="right-side">
          <section class="content-header">
                    <h1>
                        <font color=#0489B1>View Customer</font>
                    </h1>
                </section>
                <section class="content">
<div class="col-lg-12">
    <h4>Account of ${fn:escapeXml(customer.firstname)} ${fn:escapeXml(customer.lastname)} </h4>
	<ul class="nav nav-tabs">
	      <li class="active"><a id="custinfoLink" href="#custinfo" data-toggle="tab">Customer Information</a></li>
	      <li><a id="resetpassLink" href="#resetpass" data-toggle="tab">Reset Password</a></li>
	      <li><a id="transhistLink" href="#transhist" data-toggle="tab">Transaction History</a></li>
	      <li><a id="depositLink" href="#deposit" data-toggle="tab">Deposit Money</a></li>
	</ul> 
<section class="tab-content">
  <article class="tab-pane active" id="custinfo"> 
  <br>
    <div class ="col-lg-12">
    <div class="col-lg-4">
    
    <address>
    <strong>First Name</strong>
    <br> ${fn:escapeXml(customer.firstname)}
    </address>
    </div>
    <div class="col-lg-4">
    <address>
    <strong>Last Name</strong>
    <br> ${fn:escapeXml(customer.lastname)}
    </address>
    </div>
    <div class="col-lg-4">
    <address>
    <strong>Email Address</strong>
    <br> ${fn:escapeXml(customer.username)}
    </address> 
    </div>
    </div>   
    <div class ="col-lg-12">
    <div class="col-lg-4">
    <address>
    <strong>Last Trading Date</strong>
    <br>${lastExecutionDate}
    </address>
    </div>
    <div class="col-lg-4">
    <address>
    <strong>Address</strong>
    <br>${fn:escapeXml(customer.addrLine1)}
    <br>${fn:escapeXml(customer.addrLine2)}
    <br> ${fn:escapeXml(customer.city)} , ${fn:escapeXml(customer.state)} , ${fn:escapeXml(customer.zip)}
    </address>
    </div>
        <div class="col-lg-4">
    <address>
    <strong>Cash Balance</strong>
    <br> <fmt:formatNumber value="${customer.presentCash}" type="currency" currencySymbol="$"/>
    (Pending:<fmt:formatNumber value="${pendingCash }"
     	type="currency" currencySymbol="$" pattern="$#,##0.00;-$#,##0.00"/>)
    </address>
    </div>
    </div>
    <div class="row">
	    <div class="col-lg-12">
	    	<div class="box box-primary">
	            <div class="box-header">
	                <h3 class="box-title">Current Portfolio of the Customer:</h3>                                    
	            </div>
	            <div class="box-body table-responsive">
	                <table id="portfolioTable" class="table table-bordered table-striped table-hover">
	                    <thead>
	                        <tr>
	                            <th style="text-align:center">Fund Name</th>
					       		<th style="text-align:center">Fund Ticker</th>
					       		<th style="text-align:center">Number of Shares</th>
					       		<th style="text-align:center">Last Closing Price</th>
	                        </tr>
	                    </thead>
	                    <tbody>
                        	<c:forEach var="position" items="${positionList}">
                        	<tr>
								<td> ${fn:escapeXml(position.fund.name)}</td>    
					            <td> ${fn:escapeXml(position.fund.symbol)}</td>
					            <td style="text-align:right">
					             <fmt:formatNumber value="${position.presentShares}" type="number" minFractionDigits="3"/>
					             </td>
					            <td style="text-align:right">
					             <fmt:formatNumber value="${position.curSharePrice}" type="currency" currencySymbol="$"/></td>
					        </tr>
							</c:forEach>
	                    </tbody>
	                </table>
	            </div>
	         </div>
	    </div>
	 </div>
    </article>

	<article class="tab-pane" id="resetpass">
		
			<div class="alert alert-info ">
				<i class="fa fa-info"></i>
				By clicking this button, we will generate a random password for
				Customer ${fn:escapeXml(customer.firstname)} ${fn:escapeXml(customer.lastname)} and send an email to
				him/her.
			</div>
		
		<div class="col-lg-4">
		<form method= "post" action="resetCustPassword">
			<input type = "hidden" name = "customerId" value="${customer.id }" />
			<input type="submit" class="btn btn-primary" name = "button" value = "Reset Password"/>
		</form>
		</div>
	</article>

	<article class="tab-pane" id="transhist">
    	<div class="row">
        	<div class="col-sm-12">
            	<div class="box box-primary">
                	<div class="box-header">
                    	<h3 class="box-title">Pending Transactions</h3>                                    
                    </div><!-- /.box-header -->
                    <div class="box-body table-responsive">
                    	<table id="pendingTable" class="table table-bordered table-striped table-hover">
                        	<thead>
	                            <tr>
	                            	<th width="120px">Date of Order</th>
	                                <th width="120px">Operation</th>
	                                <th>Ticker</th>
	                                <th>Fund Name</th>
	                                <th width="120px">Number of Shares</th>
	                                <th width="120px">Dollar Amount</th>
	                            </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="transaction" items="${transactionPendingList}">
                                <tr>
									<td><fmt:formatDate pattern="MM-dd-yyyy" value="${transaction.orderDate}"/></td>
									<td><span class="label label-primary">${transaction.transactionType}</span></td>
									<td>${fn:escapeXml(transaction.fund.symbol)}</td>
									<td>${fn:escapeXml(transaction.fund.name)}</td>
									<td style="text-align:right">
					             	<fmt:formatNumber value="${transaction.presentShares}" type="number" minFractionDigits="3"/>
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
                            
                <div class="box box-primary">
                	<div class="box-header">
                    	<h3 class="box-title">Complete Transactions</h3>                                    
                    </div><!-- /.box-header -->
                    <div class="box-body table-responsive">
                    	<table id="completeTable" class="table table-bordered table-striped table-hover">
                        	<thead>
                            	<tr>
                                	<th width="120px">Date of Execution</th>
                         			<th width="120px">Operation</th>
                                    
                                    <th>Fund Name</th>
                                    <th>Ticker</th>
                                    <th width="120px">Number of Shares</th>
                                    <th width="120px">Current Share Price</th>
                                    <th width="120px">Dollar Amount</th>
                                </tr>
                            </thead>
                            <tbody>
                            	<c:forEach var="transaction" items="${transactionCompleteList}">
                            	<tr>
									<td><fmt:formatDate pattern="MM-dd-yyyy" value="${transaction.executeDate}"/></td>
									<td><span class="label label-primary">${transaction.transactionType}</span></td>
									<td>${fn:escapeXml(transaction.fund.name)}</td>
									<td>${fn:escapeXml(transaction.fund.symbol)}</td>
									
									<td style="text-align:right">
					             	<fmt:formatNumber value="${transaction.presentShares}" type="number" minFractionDigits="3"/>
					             	</td>
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
  
  <article class="tab-pane" id="deposit">
      <div class="alert alert-info alert-dismissable">
      	<i class="fa fa-info"></i>
        Deposit a check into this account
      </div>
      <div class="content">
	  <p>Amount:</p>
	  <form class="hei " action="depositCheck" method = "get" >
	  	<div class="input-group">
			<span class="input-group-addon">$</span> 
			<input type = "hidden" name = "customerId" value="${customer.id }" />
			<input type="text" class="form-control" name="depositamount"
				value="" style="text-align:right"/>
		</div><br><br>
		<c:if test="${!(empty depositErrorMsgs)}">
			<div class="alert alert-danger alert-dismissable">
	    	<i class="fa fa-warning"></i>
	    	<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
	    	<c:forEach var="errorMsg" items="${depositErrorMsgs}">
			<b>${errorMsg}</b><br>
			</c:forEach>
  	   		</div>
		</c:if>
		<c:if test="${empty depositErrorMsgs and !(empty depositMessage)}">
			<div class="alert alert-success alert-dismissable">
	    	<i class="fa fa-check"></i>
	    	<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
	    	<b>${depositMessage} You have deposited $${fn:escapeXml(param.depositamount)} to this customer's account.</b>
 			</div>
		</c:if>

		<div class="form-group">
			<input type="submit" class="btn btn-primary" name="button" value="Deposit" />
		</div>
	  </form>
	  </div>
  </article>
</section>
</div>

<script src="<c:url value="/resources/js/plugins/datatables/jquery.dataTables.js"/>" type="text/javascript"></script>
<script src="<c:url value="/resources/js/plugins/datatables/dataTables.bootstrap.js"/>" type="text/javascript"></script>
    <script type="text/javascript">
        $(function() {
        	$("#portfolioTable").dataTable({
        		"bPaginate": false
        	});
        	$("#pendingTable").dataTable({
        		"bPaginate": false
        	});
        	$('#completeTable').dataTable({
                "bPaginate": false,
                "bLengthChange": false,
                "bFilter": false,
                "bSort": true,
                "bInfo": true,
                "bAutoWidth": false
            });
        });
    </script>
    
</body>
</html>
<%@ include file="template-footer.jsp" %>
