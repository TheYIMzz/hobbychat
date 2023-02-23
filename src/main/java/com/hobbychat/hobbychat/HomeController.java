package com.hobbychat.hobbychat;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.GenericXmlApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.hobbychat.mybatis.MyBatisDAO;
import com.hobbychat.vo.HcChatRoom_List;
import com.hobbychat.vo.HcChatRoom_VO;
import com.hobbychat.vo.HcMsg_VO;
import com.hobbychat.vo.HcMyRoom_VO;
import com.hobbychat.vo.HcUser_VO;



@Controller
public class HomeController {

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

	@Autowired
	private SqlSession sqlSession;

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home() {
		logger.info("home컨트롤러의 home메소드");

		return "login";
	}

	// !!미완!!
	@RequestMapping("/login")
	public String login(HttpServletRequest request, Model model) {
		logger.info("login()");
		return "login";
	}


	@RequestMapping("/loginOK")
	public String loginOK(HttpServletRequest request, Model model, HttpServletResponse response) {
		logger.info("home컨트롤러의 loginOK()");

		MyBatisDAO mapper = sqlSession.getMapper(MyBatisDAO.class);
		HttpSession session = request.getSession();

		String userId = request.getParameter("userId").trim();
		String password = request.getParameter("password").trim();


		HcUser_VO originalVO = mapper.selectUser(userId);

		// 입력된 아이디가 존재 & 비번 일치

		if (originalVO == null) {
			Alert.alertAndRedirect(response, "존재하지 않는 아이디 입니다.", "login");
		}

		if (!password.equals(originalVO.getPassword())) {
			Alert.alertAndRedirect(response, "비번이 일치하지않습니다.", "login");
		}

		session.setAttribute("userId", userId);

		System.out.println( "JSESSIONID 값 :"+ session.getId());
		System.out.println( "세션의 유효 기간 :"+ session.getMaxInactiveInterval());
		System.out.println( "세션 생성일시 :" + session.getCreationTime());
		System.out.println("세션과 연결된 사용자가 최근에 서버에 접근한 시간 :" + session.getLastAccessedTime());
		System.out.println(session.isNew());
		System.out.println(Arrays.toString(session.getValueNames()));

		return "redirect:viewHome";
	}

	// 로그아웃
	@RequestMapping("/logout")
	public String logout(HttpServletRequest request) {
		logger.info("Home컨트롤러의 logout()");
		HttpSession session = request.getSession();
		session.invalidate();
		return "redirect:login";
	}

	//	< Home페이지 >
	@RequestMapping("/viewHome")
	public String viewHome(Model model, HttpSession session) {
		logger.info("Home컨트롤러의 viewHome() 실행");

		MyBatisDAO mapper = sqlSession.getMapper(MyBatisDAO.class);
		String userId = (String) session.getAttribute("userId");

		HcUser_VO userVO = mapper.selectUser(userId);
		ArrayList<HcChatRoom_VO> chatRoomList = mapper.selectRoomListByUserId(userId);

		AbstractApplicationContext ctx = null;
		HcMyRoom_VO myRoomVO = null;

		ArrayList<HcMyRoom_VO> myRoomList = new ArrayList<HcMyRoom_VO>();

		HashMap<String, String> hmap = null;
		int newMsg = 0;

		for (HcChatRoom_VO chatRoomVO : chatRoomList) {
			ctx = new GenericXmlApplicationContext("classpath:applicationCTX.xml");
			myRoomVO = ctx.getBean("myRoomVO", HcMyRoom_VO.class);

			hmap = new HashMap<String, String>();
			hmap.put("userId", userId);
			hmap.put("roomId", chatRoomVO.getRoomId());

			newMsg = mapper.selectCountNewMsg(hmap);

			myRoomVO.setRoomId(chatRoomVO.getRoomId());
			myRoomVO.setRoomName(chatRoomVO.getRoomName());
			myRoomVO.setUserCnt(chatRoomVO.getUserCnt());
			myRoomVO.setCoverImg(chatRoomVO.getCoverImg());
			myRoomVO.setNewMsg(newMsg);

			myRoomList.add(myRoomVO);
		}

		model.addAttribute("userVO", userVO);
		model.addAttribute("myRoomList", myRoomList);
		return "viewHome";

	}


	// !!미완!!
//	< My페이지 >
	@RequestMapping("/viewMyPage")
	public String viewMyPage(HttpServletRequest request, Model model, HttpSession session) {
		logger.info("Home컨트롤러의 viewMyPage() 실행");

		MyBatisDAO mapper = sqlSession.getMapper(MyBatisDAO.class);
		HcUser_VO userVO = mapper.selectUser((String)session.getAttribute("userId"));

		model.addAttribute("userVO", userVO);
		return "viewMyPage";

	}


	//	< 채팅방 페이지 >
	@RequestMapping("/viewRoom")
	public String viewRoom(HttpServletRequest request, Model model) {
		logger.info("Home컨트롤러의 viewRoom() 실행");

		HttpSession session = request.getSession();
		MyBatisDAO mapper = sqlSession.getMapper(MyBatisDAO.class);

		String userId = (String) session.getAttribute("userId");
		String roomId = request.getParameter("roomId");
		int newMsg = Integer.parseInt(request.getParameter("newMsg"));

		HcChatRoom_VO chatRoomVO = mapper.selectRoom(roomId);
		HcUser_VO userVO = mapper.selectUser(userId);

		// 채팅 참여자 리스트
		String[] array = chatRoomVO.getUserList().split("/");
		ArrayList<HcUser_VO> userList = new ArrayList<HcUser_VO>();
		HcUser_VO userOne = null;

		for (int i=0; i<array.length; i++) {
			userOne = mapper.selectUser(array[i].substring(1));
			userList.add(userOne);
		}

		ArrayList<HcMsg_VO> msgList = mapper.selectMsgList(roomId);

		// 총 메세지 목록에서 안읽은 메세지의 시작 번호 (zero인덱스 방식을 기준으로)
		int index = msgList.size() - newMsg;

		// 웹소켓에서 쓰기 위해 http세션에 roomId 담음.
		session.setAttribute("roomId", roomId);

		model.addAttribute("chatRoomVO", chatRoomVO);
		model.addAttribute("userVO", userVO);
		model.addAttribute("userList", userList);
		model.addAttribute("msgList", msgList);
		model.addAttribute("index", index);
		System.out.println(msgList);

		return "viewRoom";

	}

	//	< 방검색 페이지 >
	@RequestMapping("/viewSearchRoom")
	public String viewSearchRoom() {
		logger.info("Home컨트롤러의 viewSearchRoom() 실행");
		return "viewSearchRoom";
	}


	//	< 방검색 >
	@RequestMapping("/roomSearch")
	public String roomSearch(HttpServletRequest request, HttpServletResponse response, Model model) {
		logger.info("Home컨트롤러의 roomSearch() 실행");

		MyBatisDAO mapper = sqlSession.getMapper(MyBatisDAO.class);

		String set = request.getParameter("set");
		String item = request.getParameter("item").trim();

		int currentPage = 1;
		try {
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		} catch (NumberFormatException e) {
		}
		int pageSize = 10;

		AbstractApplicationContext ctx = new GenericXmlApplicationContext("classpath:applicationCTX.xml");

		HcChatRoom_List chatRoomList = ctx.getBean("chatRoomList", HcChatRoom_List.class);

		chatRoomList.setCurrentPage(currentPage);
		chatRoomList.setPageSize(pageSize);

		try {
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();

			if (item == null || item.equals("")) {
				out.println("<script>");
				out.println("alert('검색어를 입력해주세요.')");
				out.println("location.href='viewSearchRoom'");
				out.println("</script>");

			} else if (set == null) {
				out.println("<script>");
				out.println("alert('검색조건을 선택해주세요.')");
				out.println("location.href='viewSearchRoom'");
				out.println("</script>");

			} else if (set.equals("rName")) {

				int totalCount = mapper.selectCountChatRoomList_rName(item);
				chatRoomList.setItem(item);
				chatRoomList.setTotalCount(totalCount);
				chatRoomList.calculator();

				chatRoomList.setChatRoomList(mapper.selectChatRoomListByRName(chatRoomList));

				request.setAttribute("chatRoomList", chatRoomList);
				request.setAttribute("set", set);

				return "viewSearchRoom";

			} else if (set.equals("rTag")) {

				int totalCount = mapper.selectCountChatRoomList_rTag(item);
				chatRoomList.setItem(item);
				chatRoomList.setTotalCount(totalCount);
				chatRoomList.calculator();

				chatRoomList.setChatRoomList(mapper.selectChatRoomListByRTag(chatRoomList));

				request.setAttribute("chatRoomList", chatRoomList);
				request.setAttribute("set", set);

				return "viewSearchRoom";

			} else {
				out.println("<script>");
				out.println("alert('잘못된 검색입니다.')");
				out.println("location.href='viewSearchRoom'");
				out.println("</script>");
			}
			out.flush();
			out.close();
		} catch(IOException e) {
			e.printStackTrace();
		}
		return "";
	}




	// 방 입장하기 (방 참여)
	@RequestMapping("/enterRoom")
	public String enterRoom(HttpServletRequest request, Model model, HttpSession session) {
		logger.info("Home컨트롤러의 enterRoom() 실행");

		MyBatisDAO mapper = sqlSession.getMapper(MyBatisDAO.class);

		String roomId = request.getParameter("roomId");
		String userId = (String)session.getAttribute("userId");

		HashMap<String, String> hmap = new HashMap<String, String>();
		hmap.put("userId", userId);
		hmap.put("roomId", roomId);

		mapper.updateRoomUser(hmap);

		model.addAttribute("userId", userId);
		model.addAttribute("roomId", roomId);
//		return "redirect:viewRoom";
		return "redirect:viewSearchRoom";

	}


	//	마이페이지: 나의정보 수정하기 ( 저장위치 C:/hobbychat/profile )
	@RequestMapping("/updateUser")
	public String updateUser(HttpServletResponse response, MultipartHttpServletRequest request, HcUser_VO hcUser_VO) throws IOException {
		logger.info("컨트롤러의 updateUser() 메소드 실행");

		String rootUploadDir = "C:" + File.separator + "hobbychat";
		File dir = new File(rootUploadDir + File.separator + "profile");

		if (!dir.exists()) {
			dir.mkdirs();
		}

		Iterator<String> iterator = request.getFileNames();
		String orgFileName = "";
		String parameterFile = "";
		MultipartFile multipartFile = null;

		if (iterator.hasNext()) {
			parameterFile = iterator.next();  // 파라미터에 담긴 파일명
			multipartFile = request.getFile(parameterFile);
			orgFileName = multipartFile.getOriginalFilename();  // 사용자가 올린 파일명
			System.out.println(orgFileName);
		}

		if (orgFileName != null && orgFileName.length() != 0) {

			String orgFileName2 = orgFileName;
			int i = 1;
			// 파일명 중복 시, 파일명 끝에 (1) 붙이기
			while (new File("C:" + File.separator + "hobbychat" + File.separator + "profile" + File.separator + orgFileName2).exists()) {
				int index = orgFileName2.lastIndexOf(".");
				String prefix = orgFileName2.substring(0, index);
				String suffix = orgFileName2.substring(index);
				orgFileName2 = prefix + "(" + i + ")" + suffix;

			}

			String savedFileName = orgFileName2;

			try {
				multipartFile.transferTo(new File(dir + File.separator + savedFileName));
				response.setContentType("text/html; charset=UTF-8");
				PrintWriter out = response.getWriter();
				hcUser_VO.setProfileImg(savedFileName);
				out.println("<script>alert('업로드 완료')</script>");
				out.println("<script>location.href='viewMyPage'</script>");
				out.flush();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		System.out.println(hcUser_VO.getPassword());

		MyBatisDAO mapper = sqlSession.getMapper(MyBatisDAO.class);
		mapper.updateUser(hcUser_VO);

		return "redirect:viewMyPage";
	}

































}