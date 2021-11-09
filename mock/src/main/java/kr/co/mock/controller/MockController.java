package kr.co.mock.controller;

import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.co.mock.dao.MockDao;
import kr.co.mock.dao.StockDao;
import kr.co.mock.dto.MockDto;
import kr.co.mock.dto.StockDto;
import kr.co.mock.dto.UserDto;

@Controller
public class MockController {

	@Autowired
	private SqlSession sqlSession;
	
	@RequestMapping("/main_view")
	public String main_view()
	{
		return "/main_view";
	}
	
	@RequestMapping("/invest/in_regi")
public String in_regi(Model model,HttpSession session)
{
	String userid=null;
	if(session.getAttribute("userid")!=null) {
		userid=session.getAttribute("userid").toString();
	}
	
	MockDao mdao=sqlSession.getMapper(MockDao.class);
	int count=mdao.mockInvestCount(userid);
	
	model.addAttribute("count", count);
	
	
	return "/invest/in_regi";
}
	
	@RequestMapping("/in_regi_ok")
	public String in_regi_ok(UserDto udto,MockDto mdto,HttpServletRequest request,Model model,HttpSession session) throws Exception
	{
		MockDao mdao=sqlSession.getMapper(MockDao.class);
		String userid;
		
		if(session.getAttribute("userid")!=null) {//로그인 한 상태라면			
			userid=session.getAttribute("userid").toString();//로그인했을 경우 userid 세선에서 가져옴.
			int id_count=mdao.mockInvestCount(userid); //모의신청한 적이 있는 userid 검색용
			if(id_count==0)//로그인 상태에서 해당 userid가 모의신청 테이블에 정보가 없으면 모의신청가능.
			{
				int m_close=Integer.parseInt(request.getParameter("m_close"));
				int mileage=Integer.parseInt(request.getParameter("mileage"));
				mdao.in_regi_ok(mdto, userid, m_close, mileage);
				return "redirect:/main_view";
			} //로그인&모의 신청 X
			else { // 로그인&모의 신청 O 
				int diff=mdao.get_enddate(userid);
				String notday;
				if(diff ==0) {//모의 투자 신청을 한 적이 있을 경우 마지막 신청 날짜와 비교한다.
					//현재 날짜 > 종료날짜 =1//종료시점이 지나 다시 신청 가능.

					int m_close=Integer.parseInt(request.getParameter("m_close"));
					int mileage=Integer.parseInt(request.getParameter("mileage"));
					mdao.in_regi_ok(mdto, userid, m_close, mileage);
					notday=null;
					return "redirect:/main_view";
					 
					}
				else { //diff=0 or 음수 일 경우 현재 날짜와 같거나 종료이전 이므로 신청 불가
					notday="1";
					return "redirect:/invest/in_regi?notday=1";	
				}			
			} //로그인&모의 신청 if문 종료
		}//로그인 했을 시의 if문 종료
		
		else { // 로그인을 하지 않았다면 로그인 페이지로
			return "/user/login";
		}//전체 if 문 종료
	}
	//---모의 신청 완료
	
	@RequestMapping("/stocks/st_list")

	public String st_list(StockDto sdto,Model model,HttpServletRequest request)
	{
		MockDao mdao=sqlSession.getMapper(MockDao.class);
		
		// 페이징 =======================================================
		// 페이지&index, curpage=========
		int curpage=10; //한페이지당 나타낼 게시글 수 (조절 가능)
		int page;
		if(request.getParameter("page") ==null )
		{
			page=1;
		}
		else {
			page=Integer.parseInt(request.getParameter("page"));
		}
		int index=(page-1)*curpage; //limit 시의 인덱스 값, 초기값은 0
		// ======================
		// 첫페이지, 마지막페이지
		String field,word;
		if(request.getParameter("field")==null)
		{
			field="code";
			word="";
		}
		else {
			field=request.getParameter("field");
			word=request.getParameter("word");
		}

		
		int startpage=(int)Math.floor((page-1)/curpage)*curpage+1; //한 블럭의 시작페이지
		int lastpage=startpage+(curpage-1); //마지막 페이지
		
		int totalpage=mdao.get_pagecount(curpage,field,word);
		
		if(lastpage>totalpage) { //만일 마지막 페이지가 전체 페이지보다 크게 될 경우
			lastpage=totalpage; //마지막 페이지는 전체 페이지와 같다.
		}
		// ========페이징 종료
		ArrayList<StockDto> list=mdao.st_list(field,word,index,curpage);
		model.addAttribute("list",list);
		model.addAttribute("field", field);
		model.addAttribute("word", word);
		model.addAttribute("page",page);
		model.addAttribute("startpage",startpage);
		model.addAttribute("lastpage",lastpage);
		model.addAttribute("totalpage",totalpage);
		
		return "/stocks/st_list";
	}
	
	@RequestMapping("/stocks/s_content")
	public String s_content(@RequestParam("code") String code,Model model) {
		StockDao sdao= sqlSession.getMapper(StockDao.class);
		String name=sdao.selectName(code);
		
		
		model.addAttribute("code",code);
		model.addAttribute("name", name);
		
		return "/stocks/s_content";
	}

	//----매도
	@RequestMapping("/stocks/buying")
	public String buying(HttpServletRequest request,Model model,HttpSession session)
	{
		String code=request.getParameter("code");
		String name=request.getParameter("name");
		MockDao mdao=sqlSession.getMapper(MockDao.class);
		StockDto sdto=mdao.st_buysell(code);

		//mock 테이블에서 포인트 조회를 위해 가져오는 값
		if(session.getAttribute("userid")!=null) { //로그인 
			String userid=session.getAttribute("userid").toString();
			int id_check=mdao.mockInvestCount(userid); //포인트 조회를 위해 먼저 신청했던 적이 있는지 확인
			if(id_check==0) { //만약 아이디가 조회되지 않으면
				int mileage=0; //마일리지 값을 0으로 조정.
				model.addAttribute("mileage",mileage);
				model.addAttribute("sdto",sdto);
				model.addAttribute("name",name);
			}
			else { //모의신청 신청한 아이디가 있을 시
				int mileage=mdao.get_point(userid); //조회된 마일리지를 가져옴.			
				model.addAttribute("sdto",sdto);
				model.addAttribute("mileage",mileage);
				model.addAttribute("name",name);

			}
		}else //로그인 X
		{
			int mileage=0; //마일리지 값을 0으로 조정.
			model.addAttribute("mileage",mileage);
			model.addAttribute("sdto",sdto);
			model.addAttribute("name",name);
 		}
	
		return "/stocks/buying";
	}
	
	@RequestMapping("/buying_ok")
	public String buying_ok(HttpServletRequest request,HttpSession session,Model model)
	{
		if(session.getAttribute("userid")!=null) //로그인 지속 시간이 지나 로그아웃 되었을 때를 대비 
		{
			String userid=session.getAttribute("userid").toString();
			String mileage=request.getParameter("curr_mil");
			String code=request.getParameter("code");
			int n_buying=Integer.parseInt(request.getParameter("n_buying"));
			int ask_spread=Integer.parseInt(request.getParameter("ask_spread"));
			ask_spread=ask_spread*n_buying;
			MockDao mdao=sqlSession.getMapper(MockDao.class);
			mdao.buying_ok(userid, code, n_buying, ask_spread);
			mdao.mileage_update(mileage,userid);
			return "redirect:/mypage/mypage";
		}
		else {
			return "/user/login";
		}
			
	}
	//-----매수
	
	//매도-----
	@RequestMapping("/stocks/selling")
	public String selling(HttpServletRequest request,Model model,HttpSession session)
	{
		String code=request.getParameter("code");
		MockDao mdao=sqlSession.getMapper(MockDao.class);
		StockDto sdto=mdao.st_buysell(code); // ---------------
		//mock 테이블에서 포인트 조회를 위해 가져오는 값
		if(session.getAttribute("userid")!=null) { //로그인 
			String userid=session.getAttribute("userid").toString();
			int id_check=mdao.mockInvestCount(userid); //포인트 조회를 위해 먼저 신청했던 적이 있는지 확인 
			if(id_check==0) { //만약 아이디가 조회되지 않으면-----------
				int mileage=0; //마일리지 값을 0으로 조정.
				model.addAttribute("mileage",mileage);
				model.addAttribute("sdto",sdto);
			}
			else { //모의신청 신청한 아이디가 있을 시
				int mileage=mdao.get_point(userid); //조회된 마일리지를 가져옴.	--------
				 //해당 아이디가 구매한 총 매수 갯수를 가져옴
				int buy=mdao.buy_get(code,userid); //주식을 구매했는지  여부
				int diff;
				if(buy>0) { //주식을 구매했다면
					int n_buying=mdao.buy_count(userid,code);
					int sell=mdao.sell_get(code, userid); //판매주식이 있는지 확인
					if(sell>0) {//판매한 내용이 있다면
						int n_selling=mdao.sell_count(userid,code); //해당 아이디가 판매한 총 매도 갯수를 가져옴
						diff=(n_buying-n_selling);	// 여기 왜 1뺐지?

						model.addAttribute("sdto",sdto);
						model.addAttribute("mileage",mileage);
						model.addAttribute("diff",diff);
					}
					else { //판매한 내용이 없다면
						sell=0;
						diff=n_buying;
						model.addAttribute("sdto",sdto);
						model.addAttribute("mileage",mileage);
						model.addAttribute("diff",diff);
					}

				}
				else {
					diff=0;
					model.addAttribute("sdto",sdto);
					model.addAttribute("mileage",mileage);
					model.addAttribute("diff",diff);
				}
			}
		}else //로그인 X
		{
			int mileage=0; //마일리지 값을 0으로 조정.
			model.addAttribute("mileage",mileage);
			model.addAttribute("sdto",sdto);
 		}
	
		return "/stocks/selling";
	}
	
	@RequestMapping("/selling_ok")
	public String selling_ok(HttpServletRequest request,Model model,HttpSession session)
	{
		
		if(session.getAttribute("userid")!=null) //로그인 지속 시간이 지나 로그아웃 되었을 때를 대비 
		{
			String userid=session.getAttribute("userid").toString();
			String mileage=request.getParameter("curr_mil");
			String code=request.getParameter("code");
			int n_selling=Integer.parseInt(request.getParameter("n_selling"));
			int bid_spread=Integer.parseInt(request.getParameter("bid_spread"));
			bid_spread=bid_spread*n_selling;
			MockDao mdao=sqlSession.getMapper(MockDao.class);
			mdao.selling_ok(userid, code, n_selling, bid_spread);
			mdao.mileage_update(mileage,userid);
			return "redirect:/mypage/mypage";
		}
		else {
			return "/user/login";
		}
	}
	//----매도
	
}