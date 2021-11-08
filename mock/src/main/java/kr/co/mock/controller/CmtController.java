package kr.co.mock.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.mock.dao.CmtDao;
import kr.co.mock.dto.CmtDto;

@Controller
public class CmtController {

	@Autowired
	private SqlSession sqlSession;
	
	@RequestMapping("/freeboard/content/cmt_list")
	public String cmt_list(Model model,HttpServletRequest request)
	{
		int c_id=Integer.parseInt(request.getParameter("c_id"));	
		int page;
		if(request.getParameter("page")==null)
		{
			page=1;
		}
		else
		{
			page=Integer.parseInt(request.getParameter("page"));
		}
		int index=(page-1)*10;
		
		CmtDao cdao=sqlSession.getMapper(CmtDao.class);
		ArrayList<CmtDto> list=cdao.cmt_list(index);

		// page출력을 위해 필요한 값
		// 현재페이지:page, pstart,pend, page_cnt
		// pstart,pend
		int pstart=page/10;
		if(page%10 == 0)
			pstart=pstart-1;
		pstart=(pstart*10)+1;
		int pend=pstart+9;
		int page_cnt=cdao.get_pagecount();
		
		if(pend>page_cnt)
			pend=page_cnt;
		
		model.addAttribute("pstart",pstart);
		model.addAttribute("pend",pend);
		model.addAttribute("page_cnt",page_cnt);
		model.addAttribute("page",page);
		model.addAttribute("list",list);
		return "redirect:/freeboard/content?c_id="+c_id;
	}
	
	@RequestMapping("/freeboard/content/cmt_write")
	public String cmt_write()
	{
		return "/freeboard/content/cmt_write";
	}
	
	@RequestMapping("/freeboard/content/cmt_write_ok")
	public String cmt_write_ok(CmtDto cdto,HttpServletRequest request,HttpSession session)
	{
		int c_id=Integer.parseInt(request.getParameter("c_id"));		
		CmtDao cdao=sqlSession.getMapper(CmtDao.class); 
		cdto.setUserid(session.getAttribute("userid").toString());
		cdao.cmt_write_ok(cdto);
		return "redirect:/freeboard/content?c_id="+c_id;
	}
	
	@RequestMapping("/freeboard/content/cmt_update")
	public String cmt_update(Model model,HttpServletRequest request)
	{
		int c_id=Integer.parseInt(request.getParameter("c_id"));
		CmtDao cdao=sqlSession.getMapper(CmtDao.class); 
		CmtDto cdto=cdao.cmt_update(c_id);
		model.addAttribute("cdto",cdto);
		return "/freeboard/content/cmt_update";
	}
	
	@RequestMapping("/freeboard/content/cmt_update_ok")
	public String cmt_update_ok(CmtDto cdto,HttpServletRequest request,HttpSession session)
	{
		int c_id=Integer.parseInt(request.getParameter("c_id"));		
		CmtDao cdao=sqlSession.getMapper(CmtDao.class); 
		cdao.cmt_update_ok(cdto);
		return "redirect:/freeboard/content?f_id="+c_id;
	}
	
	@RequestMapping("/freeboard/content/cmt_delete")
	public String cmt_delete(HttpServletRequest request)
	{
		int c_id=Integer.parseInt(request.getParameter("c_id"));
		CmtDao cdao=sqlSession.getMapper(CmtDao.class); 
		cdao.cmt_delete(c_id);
		return "redirect:/freeboard/content?f_id="+c_id;
	}
}