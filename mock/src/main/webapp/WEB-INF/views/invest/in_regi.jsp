<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style type="text/css">
.main{
	display:grid;
	place-items: center;
	height:100%;
	margin-top:30px;
}
#warning{ /*안내문*/
	width: 800px;
	display:inline-block;
}
#conline{
	display:grid;
	width:800px;
	height:90px;
	border: 1px solid;
	place-items: center;
}
#regist{ /*투자기간과 금액(포인트)*/
	width:500px;
	height:30px;
	display:flex;
	justify-content: space-between;
}
#subm{/*신청 버튼*/
	margin-top:10px;
	display:flex;
	justify-content:center;
}

#inv_input{/*버튼 css*/
	background:Deeppink;
	color:white;
	width:100px;
	height:30px;
}

.line2 {
  display:inline-block;
  background:Powderblue;/*아이콘 색상*/
  width:15px;
  height:25px; 
  border-radius:3px;
}
.title{
	font-size:20px;
	font-weight:bold;
}
.not1{
	color:red;
}
</style>

</head>
<body>
<div id="main" class="main">
	<div id="warning">
	<span class="line2"></span><span class="title">&nbsp;투자원금 및 참가기간</span><p>
	&nbsp;&nbsp;● 참가 신청시 모의투자에서 사용할 투자자금을 선택하여 설정 할 수 있습니다.<br>
	&nbsp;&nbsp;&nbsp;▷ 투자 원금 : 개인 설정(300만원, 500만원, 1천만원)<br>
	&nbsp;&nbsp;&nbsp;▷ 참가 기간 : 개인 설정(1개월, 2개월, 3개월)<br>
	&nbsp;&nbsp;&nbsp;▷ 투자 원금과 참가기간 변경은 불가능합니다.<br><br><br>

	<span class="line2"></span><span class="title">&nbsp;거래 및 거래시간</span><p>
	&nbsp;&nbsp;● 거래일 : 실제 주식 영업일 기준<br>
	&nbsp;&nbsp;● 매매시간 : 실제 시장과 동일하게 적용<br><br><br><br>

	<span class="line2"></span><span class="title">&nbsp;모의 투자 진행방식</span><br><br>
	&nbsp;&nbsp;● 시세<p>
	&nbsp;&nbsp;&nbsp;▷ 모의투자의 시세는 실제 시장의 실시간 시세를 이영하며, 참가자의 주문을 실제시장의 시세에 영향을 미치지 않습니다.<br>
	&nbsp;&nbsp;&nbsp;(단, 모의투자는 실제 시장에서의 체결과 약간 다를 수 있습니다.)<br>
	&nbsp;&nbsp;&nbsp;▷ 주문은 마일리지 매도/매수에 한하며 신용이나 공매도는 허용하지 않습니다.<br><br>

	&nbsp;&nbsp;● 투자대상종목<p>
	&nbsp;&nbsp;&nbsp;▷ 매매제한 종목을 제외한 일부 코스피만 투자할 수 있습니다.<br>
	&nbsp;&nbsp;&nbsp;단, 실제 주식시장에서 거래가 발생하지 않았던 종목과 매매거래 정지종목은 투자 대상 종목에서 제외합니다.<br><br><br>
	</div>
	<c:if test="${count==1}">
		<div class="not1">이미 신청한 적이 있고 종료날짜가 지나지 않아 재신청이 불가합니다.</div>
	</c:if>
	
	<c:if test="${count!=1}">
	<div id="conline">
		<form name="aa" method="post" action="../in_regi_ok">
		<div id="regist">
			<div class="in_date date">투자 기간</div>
			<div class="in date month">
				<select name="m_close">
				<option value="1">1개월</option>
				<option value="2">2개월</option>
				<option value="3">3개월</option>
				</select>
			</div>	
			<div class="in_mile mileage">투자 금액</div>
			<div class="in_mile price">
				<select name="mileage">
					<option value="3000000">300만원</option>
					<option value="5000000">500만원</option>
					<option value="10000000">1,000만원</option>
				</select>
			</div>
		</div>
		
		<div id="subm">
			<input id="inv_input" type="submit" value="신청하기">
		</div>	
		</form>
	</div>
	</c:if>
</div>
</body>
</html>