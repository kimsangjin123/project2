<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="https://code.highcharts.com/css/stocktools/gui.css">
<link rel="stylesheet" type="text/css" href="https://code.highcharts.com/css/annotations/popup.css">
<style>
#container {
    max-height: 800px;
    min-height: 75vh;
}

</style>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://code.highcharts.com/stock/highstock.js"></script>
<script src="https://code.highcharts.com/stock/modules/data.js"></script>
<script src="https://code.highcharts.com/stock/indicators/indicators-all.js"></script>
<script src="https://code.highcharts.com/stock/modules/drag-panes.js"></script>
<script src="https://code.highcharts.com/modules/annotations-advanced.js"></script>
<script src="https://code.highcharts.com/modules/price-indicator.js"></script>
<script src="https://code.highcharts.com/modules/full-screen.js"></script>
<script src="https://code.highcharts.com/modules/stock-tools.js"></script>
<script src="https://code.highcharts.com/stock/modules/heikinashi.js"></script>
<script src="https://code.highcharts.com/stock/modules/hollowcandlestick.js"></script>


</head>
<body>




<div id="stock-graph"></div>

<h1>stockchart</h1>


<script>

$(document).ready(function(){
	var reqData={code:"<c:out value='${code}'/>"}	// 변수

	
	$.ajax({
		url:"./testData2",
		type:'post',
		data:reqData,
		dataType:'json',
		timeout: 2000,
		success:function(data){

		    // split the data set into ohlc and volume
		    var ohlc = [],
		        volume = [],
		        dataLength = data.length,
		        i = 0;

		    for (i; i < dataLength; i += 1) {
		        ohlc.push([
		            data[i].date, // the date
		            data[i].open, // open
		            data[i].high, // high
		            data[i].low, // low
		            data[i].close // close
		        ]);

		        volume.push([
		            data[i].date, // the date
		            data[i].volume // the volume
		        ]);
		    }

		    Highcharts.stockChart('stock-graph', {
		        yAxis: [{
		            labels: {
		                align: 'left'
		            },
		            height: '80%',
		            resize: {
		                enabled: true
		            }
		        }, {
		            labels: {
		                align: 'left'
		            },
		            top: '80%',
		            height: '20%',
		            offset: 0
		        }],
		        tooltip: {
		            shape: 'square',
		            headerShape: 'callout',
		            borderWidth: 0,
		            shadow: false,
		            positioner: function (width, height, point) {
		                var chart = this.chart,
		                    position;

		                if (point.isHeader) {
		                    position = {
		                        x: Math.max(
		                            // Left side limit
		                            chart.plotLeft,
		                            Math.min(
		                                point.plotX + chart.plotLeft - width / 2,
		                                // Right side limit
		                                chart.chartWidth - width - chart.marginRight
		                            )
		                        ),
		                        y: point.plotY
		                    };
		                } else {
		                    position = {
		                        x: point.series.chart.plotLeft,
		                        y: point.series.yAxis.top - chart.plotTop
		                    };
		                }

		                return position;
		            }
		        },
		        series: [{
		            type: 'ohlc',
		            id: 'aapl-ohlc',
		            name: 'AAPL Stock Price',
		            data: ohlc
		        }, {
		            type: 'column',
		            id: 'aapl-volume',
		            name: 'AAPL Volume',
		            data: volume,
		            yAxis: 1
		        }],
		        responsive: {
		            rules: [{
		                condition: {
		                    maxWidth: 800
		                },
		                chartOptions: {
		                    rangeSelector: {
		                        inputEnabled: false
		                    }
		                }
		            }]
		        }
		    });

		}
		
		
	});


	});



</script>

</body>
</html>