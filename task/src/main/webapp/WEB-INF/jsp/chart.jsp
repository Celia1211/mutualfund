<%@ include file="template-header.jsp" %>

               	          <aside class="right-side">
          <section class="content-header">
                    <h1>
                        <font color=#0489B1>Fund Chart</font>
                    </h1>
                </section>
                <!-- Main content -->
                <section class="content">
                    <div class="row">
                    <div class="col-lg-12">
                        <div class="col-lg-8">

                            <!-- interactive chart -->
                            <div class="box box-primary">
                            
                                <div class="box-header">
                                    <i class="fa fa-bar-chart-o"></i>
                                    <h3 class="box-title">Price History of ${fn:escapeXml(fund.name) }</h3>
                                    </div>
                                </div>
                                <div class="box-body">
                                <c:choose>
                                <c:when test="${!(empty fundPriceHistory)}">
                                    <div id="interactive" style="height: 300px;"></div>
                                </c:when>
                                <c:otherwise>
                                	<h4 class="box-title">There is no price available currently.</h4>
                                </c:otherwise>
                                </c:choose>
                                </div><!-- /.box-body-->
                                
                                
                           <div class="content col-lg-offset-10">
                        <a href="tobuyfund?fundId=${fund.fundId}" class="btn btn-primary btn-lg">Buy</a>
                        </div>
                            </div><!-- /.box -->
                       <div class="col-lg-4">
                        <div class="box box-primary">
                                <div class="box-header">
                                    <h3 class="box-title">History Performance</h3>                                    
                                </div><!-- /.box-header -->
                                <div class="box-body table-responsive">
                                    <table id="completeTrans" class="table table-bordered table-striped table-hover">
                                        <thead>
                                            <tr>
                                            	<th width="120px">Date</th>
                                                <th width="100px">Closing Price</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                    	<c:forEach var="history" items="${fundPriceHistory}">
                                    		<tr>
									
												<td> <fmt:formatDate pattern="MM-dd-yyyy" value="${history.id.priceDate}"/></td>
												<td style="text-align:right">
												<fmt:formatNumber value="${fn:escapeXml(history.price)}" type="currency" currencySymbol="$"/>
												</td>
											</tr>
										</c:forEach>
                                    </tbody>
                                </table>
            	</div>
        	</div>
        	</div>
                        </div><!-- /.col -->
                    </div><!-- /.row -->       
                </section><!-- /.content -->
            </aside><!-- /.right-side -->
        </div><!-- ./wrapper -->

<script src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
<script src="<c:url value="/resources/js/bootstrap.min.js"/>" type="text/javascript"></script>
<script src="<c:url value="/resources/js/AdminLTE/app.js"/>" type="text/javascript"></script>
<script src="<c:url value="/resources/js/plugins/flot/jquery.flot.min.js"/>" type="text/javascript"></script>
<script src="<c:url value="/resources/js/plugins/flot/jquery.flot.resize.min.js"/>" type="text/javascript"></script>
<script src="<c:url value="/resources/js/plugins/flot/jquery.flot.pie.min.js"/>" type="text/javascript"></script>
<script src="<c:url value="/resources/js/plugins/flot/jquery.flot.categories.min.js"/>" type="text/javascript"></script>
<script src="<c:url value="/resources/js/plugins/flot/jquery.flot.time.js"/>" type="text/javascript"></script>

        <!-- Page script -->
        <script type="text/javascript">
            $(function() {
                var maxprice = 0;
                var minprice = 100000;
                function getData() {
                     //JSON String fetched from backend
                     var json = ${fundHistoryData};
                     var data = [];
                    	 $.each(json, function(index, value) {
                    		 date = Date.parse(value.id.priceDate);
                    		 maxprice = Math.max(maxprice, value.price);
                    		 minprice = Math.min(minprice, value.price);
                    		 data.push([date, value.price]);
                     });
                     return data;
                 }
                var interactive_plot = $.plot("#interactive", [getData()], {
                    grid: {
                        borderColor: "#f3f3f3",
                        borderWidth: 1,
                        tickColor: "#f3f3f3",
                        hoverable: true, 
                        clickable: false 
                    },
                    series: {
                        shadowSize: 0, // Drawing is faster without shadows
                        color: "#3c8dbc",
                        lines: { show: true }, points: { show: true }
                    },
                    lines: {
                        fill: true, //Converts the line chart to area chart
                        color: "#3c8dbc"
                    },
                    yaxis: {
                        min: minprice- 50,
                        max: maxprice + 50,
                        show: true
                    },
                    xaxis: {
                    	 mode: "time",
                    	 timeformat:"%m/%d/%y",
                    	 show: true
                    }
                });
            });
          //Initialize tooltip on hover
            $("<div class='tooltip-inner' id='line-chart-tooltip'></div>").css({
                position: "absolute",
                display: "none",
                opacity: 0.8
            }).appendTo("body");
            $("#interactive").bind("plothover", function(event, pos, item) {

                if (item) {
                    var y = item.datapoint[1].toFixed(2);

                    $("#line-chart-tooltip").html("Price: " + y)
                            .css({top: item.pageY + 5, left: item.pageX + 5})
                            .fadeIn(200);
                } else {
                    $("#line-chart-tooltip").hide();
                }

            });
            function labelFormatter(label, series) {
                return "<div style='font-size:13px; text-align:center; padding:2px; color: #fff; font-weight: 600;'>"
                        + label
                        + "<br/>"
                        + Math.round(series.percent) + "%</div>";
            }
        </script>
    </body>
</html>
                    