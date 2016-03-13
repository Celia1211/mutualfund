<%@ include file="template-header.jsp" %>

          <aside class="right-side">
          <section class="content-header">
                    <h1>
                        <font color=#0489B1>Transition Day</font>
                    </h1>
                </section>
                <section class="content">
<div class="col-lg-12">

<form method="post" action="transit" class="col-md-8" id="form">
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

<div class="row">
	<div class="col-lg-12">
	
    <div class="box box-solid box-primary">
    	<div class="box-header">
        	<h4 class="box-title">Transition the System</h4>                                    
        </div>
        <div class="box-body">
        <c:choose>
			<c:when test="${!(empty fundList)}">
            <input type = "text" id = "mydate" value="${defaultTransitionDate}" name="date"/>
        	<table class="table table-hover table-striped" id="trasitionDay" >
		  	<thead>
				<tr>
				<th></th>
				<th><b>Fund Name</b></th>
				<th><b>Fund Ticker</b></th>
				 <th width="120px"><b>Closing Price($)</b></th>
				</tr>
			</thead>
			
		<c:forEach var="fund" items="${fundList}" varStatus ="count">
			<tr>
			<td ><input type="hidden" id ="fundId" 
						name="fundId" value="${fund.fundId}"/></td>
			<td class="col-lg-4"><label  id ="fundName" name="name">${fn:escapeXml(fund.name)}</label></td>
			<td class="col-lg-3"><label id ="fundTicker" name="symbol"> ${fn:escapeXml(fund.symbol)}</label></td>
			<td class="col-lg-4"><input type="text" class="form-control" 
						style="text-align:right" maxlength="100"
						pattern="^[0-9]*\.?[0-9]{0,2}$" placeholder="Upto 2 decimal digits"name="price" value=""/></td>
			</tr>
			
		</c:forEach>
		</table>
		</c:when>
		<c:otherwise>
		There is no fund.
		</c:otherwise>
		</c:choose>
		
	</div>
	</div>
	
    </div>
</div>
<div class="form-group"> 
	<div class="col-sm-offset-3 col-sm-3"> 
		<button type="submit" class="btn btn-primary">Submit</button><br><br>
	</div> 
	<div class="col-sm-offset-1 col-sm-5"> 
		<button type="button" class="btn btn-primary" id="myreset">Reset</button><br><br>
	</div> 
</div>
</form>

<script type = "text/javascript">
			
			$(window).load(function(){
				var defaultdate = new Date(document.getElementById("mydate").value);
			if ( $('#mydate')[0].type != 'date' ) $('#mydate').datepicker({ dateFormat: 'mm-dd-yy', minDate: defaultdate });
			}); 
</script>

<%@ include file="template-footer.jsp" %>

  