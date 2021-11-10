<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title> 마이페이지 </title>
<style>
    .main{
      display:grid;
      width:100%;
      justify-items:start;
    }
    .main h3{
    text-align:right;
    margin-bottom:50px;
    }
    .mypage_view{
      display:grid;
      grid-gap:70px;
      place-items: center;
    }
    .myid{
      width:50%;
    }
    .mymil{
      width:80%;
      border: 1px solid #D2691E;
      text-align:center;
      padding: 20px 0;
      font-size:17px;
    }
</style>
<script>
function delete_id(){
	if(confirm("정말로 탈퇴하시겠습니까?(클릭시 탈퇴됩니다.)")==true)
	{
		document.location.href="/mock/mypage/mypage_delete";
	}
	else
	{
		return false;
	}
	
}
</script>
</head>
<body>
<div id="main" class="main">
	<h3> 마이페이지 </h3>
<div class="mypage_view">
<div  class="mypage myid">
  <table align="center" class="table table-light">
    <tr class="table-danger">
      <th> 아이디 </th>
      <td> ${udto.userid} </td>
      </tr>
      
      <tr>
      <th> 이름 </th>
      <td> ${udto.username} </td>
      </tr>
      
      <tr class="table-danger">
      <th> 이메일 </th>
      <td> ${udto.email} </td>
    </tr>
  
    <tr>
      <td>
      <button  class="btn btn-outline-danger btn-sm" onclick="location.href='/mock/mypage/mypage_update?userid=${udto.userid}'"
      style="width:100%;">수정</button>
      </td>
      <td>
       <button  class="btn btn-outline-danger btn-sm" onclick="delete_id()"
       style="width:100%;">탈퇴</button>
      </td>

    </tr>
   </table>

  </div>

  
  <div class="mypage myspread">
  
    <c:if test="${mileage==null}">
     	<div>마일리지 신청한 내역이 없습니다.
     	<button  class="btn btn-outline-danger btn-sm" onclick="location.href='/mock/invest/in_regi'">마일리지 신청</button>
     	</div>
    </c:if>
    <c:if test="${mileage!=null}">
    <table class="table table-striped table-hover" align="center">
      <c:if test="${buy!=1}">
        <tr align="center">
          <td>보유 주 정보가 없습니다</td>
        </tr>
      </c:if>
      <c:if test="${buy==1}">
        <tr align="center">
          <td colspan="6" class="table-danger">보유 주 정보</td>
        </tr>
        <tr><td colspan="6"><hr></td></tr>
        <tr align="center">
          <td>종목코드</td>
          <td>종목명</td>
          <td>보유 주 개수</td>
          <td>주당 평균 매수금</td>
          <td>총 매수금</td>
        </tr>
        <c:forEach items="${total3}" var="total3">
          <c:if test="${total3.n_buying!=0 }">
          <tr align="center">
            <td><a href="/mock/stocks/s_content?code=${total3.code}">${total3.code}</a></td>
            <td><a href="/mock/stocks/s_content?code=${total3.code}">${total3.name}</a></td>
            <td><fmt:formatNumber value="${total3.n_buying}" pattern="#,##0" /></td>
            <td><fmt:formatNumber value="${total3.total / total3.n_buying}" pattern="#,##0" /></td>
            <td><fmt:formatNumber value="${total3.total}" pattern="#,##0" /></td>
          </tr>
          </c:if>
        </c:forEach>
      </c:if>      
    </table>
     </c:if>
   </div>
   
 
	<c:if test="${mileage!=null}">
  		<div class="mypage mymil">보유포인트 : <fmt:formatNumber value="${mileage}" pattern="#,##0" /></div>
	</c:if>
  
  <div class="mypage mybuy">
  <c:if test="${mileage!=null}">
    <table class="table table-striped table-hover">
      <c:if test="${buy!=1}">
        <tr align="center">
          <td>매수정보가 없습니다</td>
        </tr>
      </c:if>
      <c:if test="${buy==1}">
        <tr align="center">
          <td colspan="6" class="table-danger">매수정보</td>
        </tr>
        <tr height="10"/>
        <tr align="center">
          <td>종목코드</td>
          <td>종목명</td>
          <td>매수 주 개수</td>
          <td>주당 매수금</td>
          <td>총 매수금</td>
          <td>매수일</td>
        </tr>
        <tr><td colspan="6"><hr></td></tr>
        <c:forEach items="${bdto3}" var="bdto3">
          <tr align="center">
            <td><a href="/mock/stocks/s_content?code=${bdto3.code}">${bdto3.code}</a></td>
            <td><a href="/mock/stocks/s_content?code=${bdto3.code}">${bdto3.name}</a></td>
            <td><fmt:formatNumber value="${bdto3.n_buying}" pattern="#,##0" /></td>
            <td><fmt:formatNumber value="${bdto3.ask_spread / bdto3.n_buying}" pattern="#,##0" /></td>
            <td><fmt:formatNumber value="${bdto3.ask_spread}" pattern="#,##0" /></td>
            <td>${bdto3.b_day}</td>
          </tr>
        </c:forEach>
      </c:if>      
    </table>
    </c:if>
    </div>
    
    <div>
    <c:if test="${mileage!=null}">
    <table class="mypage mysell table table-striped table-hover">
      <c:if test="${sel!=1}">
        <tr align="center">
          <td>매도정보가 없습니다</td>
        </tr>
      </c:if>
      <c:if test="${sel==1}">
        <tr align="center">
          <td colspan="6" class="table-danger">매도정보</td>
        </tr>
        <tr height="10"/>
        <tr align="center">
          <td>종목코드</td>
          <td>종목명</td>
          <td>매도 주 개수</td>
          <td>주당 매도금</td>
          <td>총 매도금</td>
          <td>매도일</td>
        </tr>
        <tr><td colspan="6"><hr></td></tr>
        <c:forEach items="${sdto3}" var="sdto3">
          <tr>
            <td><a href="/mock/stocks/s_content?code=${sdto3.code}">${sdto3.code}</a></td>
            <td><a href="/mock/stocks/s_content?code=${sdto3.code}">${sdto3.name}</a></td>
            <td align="center"><fmt:formatNumber value="${sdto3.n_selling}" pattern="#,##0" /></td>
            <td><fmt:formatNumber value="${sdto3.bid_spread / sdto3.n_selling}" pattern="#,##0" /></td>
            <td><fmt:formatNumber value="${sdto3.bid_spread}" pattern="#,##0" /></td>
            <td>${sdto3.s_day}</td>
          </tr>
        </c:forEach>
      </c:if>
    </table>
    </c:if>
 </div>

  </div>
 </div>
</body>
</html>
          