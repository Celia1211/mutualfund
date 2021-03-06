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
            <font color=#0489B1>Buy Fund</font>
        </h1>
    </section>
    <section class="content">
    	<font size="4">
	 	<div class="alert alert-info alert-dismissable">
     	Your available amount to spend is <fmt:formatNumber value="${user.presentCash+pendingCash }"
     	type="currency" pattern="$#,##0.00;-$#,##0.00" currencySymbol="$"/>. You can spend money only within that range to buy funds.
     	</div>
     	</font>
    <div class="col-lg-12">
	<h3>Please enter the amount of money you plan to spend:</h3><br>
	
	<form method="post" action="buyfund" class="hei" id="form">
	<input type="hidden" name="fundId" value="${fund.fundId}" />
	<div class="form-group">
		<font size="4">
			<label for="fundName">Fund Name:</label>
		</font>
			<label id ="fundName" name="fundName">${fn:escapeXml(fund.name)}</label>
			
	</div>
		
	<div class="form-group">
		<font size="4">		
			<label for="fundTicker">Fund Ticker:</label>
		</font>
		<label id ="fundTicker" name="fundTicker">${fn:escapeXml(fund.symbol)}</label>
	</div>
		
	<div class="form-group">
		<font size="4">	<label>Current Price:</label>
			<label ><fmt:formatNumber value="${fn:escapeXml(fund.currentPrice)}" type="currency" currencySymbol="$"/>/share</label>
		</font>
	</div>
	<div class="form-group">
		<font size="4">	
			<label for="totalAmount">Total amount to spend:</label>
		</font>
		<div class="input-group">
			<span class="input-group-addon">$</span> 
			<input type="text" name ="totalAmount" class="form-control" pattern="^[0-9]*\.?[0-9]{0,2}$" placeholder="Up to 2 decimal digits"
			name="totalAmount" maxlength="100"/>
			</div>
	</div>
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
	        <b>${message}! You have spent $${fn:escapeXml(param.totalAmount)} to purchase this fund.</b>
    	</div>
	</c:if>
	<div class="form-group"> 
 		<div class="col-sm-offset-3 col-sm-3"> 
			<button type="submit" class="btn btn-primary">Submit</button><br><br>
		</div> 
		<div class="col-sm-offset-1 col-sm-5"> 
			<button type="button" class="btn btn-primary" id="myreset">Reset</button><br><br>
		</div> 
	</div>
</form>
</div>
</section>
<%@ include file="template-footer.jsp" %>
