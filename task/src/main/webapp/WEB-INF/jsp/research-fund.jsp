<%@ include file="template-header.jsp" %>

	          <aside class="right-side">
          <section class="content-header">
                    <h1>
                        <font color=#0489B1>Research Fund</font>
                    </h1>
                </section>
                <section class="content">
                
<div class="row">
	<div class="col-lg-12">
	<div>
		<form method="post" action="researchFund"
			class="form-inline col-lg-offset-2 col-lg-10" role="search">
		<div class="table-responsive col-lg-10">
			<div class="form-group">
				<label><font size=3> Search by</font></label>
				<div class="form-group">
					<select class="form-control" name="searchBy">
						<option value="name">Fund Name</option>
						<option value="symbol">Fund Ticker</option>
					</select>
				</div>&nbsp;&nbsp;
				<div class="form-group">
					<input type="text" class="form-control" style="text-align:right" placeholder="Search Fund" 
						name="value" maxlength="100" value="${fn:escapeXml(param.fund)}">
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
		            <b>${message}</b>
		        	</div>
				</c:if>&nbsp;&nbsp;
				<button type="submit" class="btn btn-primary">Search</button>
			</div>
		</div>
		</form>
	</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-4">
		<h2>Research Fund</h2>
	</div>
</div>
<div class="row">
  <div class="col-lg-8">
    <div class="thumbnail">
    	<h3><font color="black"><strong>How Much Lower Will Markets Go? Top Investors See No Bottom Yet</strong></font></h3>
  		<p>19-Jan-2016</p>
  		<div class="col-lg-4">
      		<img src="resources/img/3-research.jpg" alt="3-research.jpg" width="200">
      	</div>
      	<div class="caption" >
        <p><font color="black" size="3" >Investment managers are warning that markets probably have further to fall as China's growth slows,
        oil prices and central bankers lack tools to prop up economies. The Standard & Poor's 500 Index will drop another 10 percent to 1,650 
        and oil could fall as low as $20 a barrel as investors flee for safety, according to Scott Minerd,chief investment officer of Guggenheim
        Partners.Jeffrey Rottinghaus,whose T.Rowe Price mutual fund beat 99 percent of rivals over the past year, said stock prices could fall
        another 10 percent as the U.S economy slips into a mild recession...</font></p>

    	<span style="display:block; width:650px; text-align:right">
        <a href="#" class="btn btn-primary" role="button">Read More</a>
      	</span>
     	</div>
    </div>
    <div class="thumbnail">
    	<h3><font color="black"><strong> PayPal Targets Millennials With 'Easy Payment' Plans</strong></font></h3>
  		<p>19-Jan-2016</p>
  		<div class="col-lg-4">
      	<img src="resources/img/2-research.jpg" alt="2-research.jpg" width="200">
     	 </div>
      	<div class="caption" >
        <p><font color="black" size="3" >Consumers trolling shop.com may have noticed a marketing hook more often associated
        with big-box stores like Best Buy than an online retailer. Under the product description for a Dell Inspiron laptop
        there's a PayPal Credit button that says:"Enjoy Easy Payments."
        The company is offering consumers a choice between buying the machine outright for a discount-or stretching the payments 
        over nine months. The enticement looks to be effective. Since Shop.com introduced the option last July,average order sizes... 
        </font></p>
    	<span style="display:block; width:650px; text-align:right">
        <a href="#" class="btn btn-primary" role="button">Read More</a>
      	</span>
      	</div>
    </div>
     <div class="thumbnail">
    	<h3><font color="black"><strong> Viacom Says Redstone's 2015 Pay Declined 85% to $2 Million</strong></font></h3>
  		<p>20-Jan-2016</p>
  		<div class="col-lg-4">
      	<img src="resources/img/1-research.jpg" alt="1-research.jpg" width="200">
      	</div>
      	<div class="caption" >
        <p><font color="black" size="3" >Viacom Inc.,under pressure from activists for lagging 
        behind its media peers, paid Chairman Sumner Redstone $2 million in fiscal 2015, an 85 percent drop
        from the previous year.
        Redstone's base salary was unchanged from the year before, the New York-based media company said 
        Wednesday in an e-mailed statement. The 92-year-old billionaire became ineligible to receive a 
        bonus last year and hasn;t received an annual equity award since 2012 the company said...</font></p>
    	<span style="display:block; width:650px; text-align:right">
        <a href="#" class="btn btn-primary" role="button">Read More</a>
     	 </span>
      	</div>
    </div>
  </div>
  <c:if test="${!(empty increaseFundList)}">
 <div class="col-lg-4">
    	<div class="box box-primary">
    	<div class="box-body table-responsive">
          <h3 class="box-title">TOP ${fn:length(increaseFundList)} Star Funds</h3>  
                  <table class="table table-striped table-hover">
                      <thead>
                           <tr>
                           	<th>Fund Name</th>
                             <th>Increase</th>
                           </tr>
                       </thead>
                       <tbody>
                           
                               <c:forEach var="fund" items="${increaseFundList}">
                               <tr>
								<td><a href="tofunddetl?fundId=${fund.fundId}">${fn:escapeXml(fund.name)}</a></td>
								<td><font color="#669933"><b>&#8593;<fmt:formatNumber value="${fund.increaseRate}" type="percent" maxFractionDigits="3"/></b></font></td>
								</tr>
							   </c:forEach>                          
                       </tbody>
                  </table>
       </div>
  </div>
</div>
</c:if>

<%@ include file="template-footer.jsp" %>
