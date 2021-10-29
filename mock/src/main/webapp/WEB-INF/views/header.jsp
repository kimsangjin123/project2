<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style type="text/css">
*{

}
.container{ /*헤더 전체 컨테이너로 설정*/
	display:grid;
  	place-items: center;
	height:100%;
	grid-gap:5px;
	grid-template-areas:
		"first first"
		"second second"
		"third third"
		"main main";
}

#first{ /*찻반쩨 로고 및 로그인 css*/
	grid-area:first;
	place-items: center;
	width:1200px;	
	display:flex;
	justify-content: space-between; /*양끝으로 정렬. 아이템들 사이의 거리는 같음.*/
	height:80px;
}
#first .item{

	padding-right:10px;
}

#first .item .w_logo{
}

#first .item .login{
	margin-top: 10px;;
}

#second{ /*메뉴*/
	grid-area:second;
	width:1200px;
	height:30px;
	place-items: center;
	display:flex;
	justify-content: space-between;/*전체 같은 여백으로 정렬*/
}
#third{ /*메뉴 바 밑의 밑줄*/
	grid-area:third;
	width:1200px;
	height:5px;
	border-bottom:2px solid;
}
#main{ /*모든 메인 페이지 적용*/
	width:1200px;
	grid-area:main;
	place-items: center;
}

/* 햄버거부분 */
#line-wrapper {
  width:36px;
  height:15px;
}

.line {
  background:#000000;/*아이콘 색상*/
  margin-bottom:4px;
  width:22px;
  height:3px; 
  border-radius:3px;
}

.item .ai{
	margin-left:0px;
}
a:link {
	color:black;
	text-decoration: none;
}

a:visited {
	color:#999999;
	}

#second a:hover {
	border-bottom: 3px solid black;
	}

button{
	font-size:5px;
	text-align: center;
	text-decoration: none;

	display: inline-block;
	width: auto;

	border: none;
	border-radius: 4px;
	background:litepink;
	color: white;
}

</style>

</head>
<body>
<decorator:head/>
<div class="container">
	<div id="first">
		<div class="item w_logo"><a href="/mock/index"><img src="https://i.imgur.com/P7URtSx.png"></a></div>
		<div class="item login">
		<c:if test="${userid==null}">
			<a href="login">로그인</a>
			<a href="member">회원가입</a>
		</c:if>
		
		<c:if test="${userid!=null}">
			${username}님
			<a href="logout">로그아웃</a>
			<input type="button" onclick="location.href='invest/in_regi'" value="모의투자신청">
		</c:if>	
		</div>
	</div>

	<div id="second">
 		<div id="line-wrapper"><!-- 햄버거 아이콘 -->
   			<div class="line"></div>
   			<div class="line"></div>
  			<div class="line"></div>
 		</div>
 		<div class="item ai"><a href="">AI추천 종목</a></div>
		<div class="item chart"><a href="">실시간 차트</a></div>
		<div class="item mock"><a href="">모의 투자</a></div>
		<div class="item my_market"><a href="">내 종목 보기</a></div>
		<div class="item m_free"><a href="">자유게시판</a></div>
		<div class="item"></div>
		<div class="item"></div>
		<!-- 아이템들 사이 조정을 위해 넣은 값 -->
 	</div>
	<!-- 메뉴바 밑줄 꾸미기 위해 넣은 div -->
 	<div id="third">
	</div>
	<decorator:body/>
	<div id="main">
	
	</div>
</div>
</body>
</html>