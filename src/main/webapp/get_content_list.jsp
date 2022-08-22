<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "org.json.simple.*" %>
<%
	//클라이언트가 전달하는 데이터 한글 깨지지 않도록 설정
	request.setCharacterEncoding("utf-8");
	
	//클라이언트가 전달한 데이터 - 게시판 목록 idx 값 추출
	String str1 = request.getParameter("content_board_idx");
	int content_board_idx = Integer.parseInt(str1);
	
	//  -> 각 페이지별로 목록 구성할 것. page_num도 받을 것이디ㅏ.
	String str2 = request.getParameter("page_num");
	int page_num = Integer.parseInt(str2);
	
	int startIndex = (page_num -1) * 10; //각 목록 시작 idx 값 구함  
	
	
	//DB 접속 정보 세팅
	String dbUrl = "jdbc:mysql://localhost:3306/groupapp_db";
	String dbId = "root";
	String dbPw = "1234";
	
	//드라이버 로딩
	Class.forName("com.mysql.cj.jdbc.Driver");
	
	//DB 실질적 접속
	Connection conn = DriverManager.getConnection(dbUrl, dbId, dbPw);
	
	//sql 문 작성
	String sql = "select a1.content_subject, a2.user_nick_name as content_nick_name, "
				+ "date_format(a1.content_write_date, '%Y-%m-%d %H:%i:%s') as content_write_date, a1.content_idx "
				+ "from content_table a1, user_table a2 "
				+ "where a1.content_writer_idx = a2.user_idx ";
	
	//'전체 게시판 목록을 선택한 경우 위 sql문에서 끝나고
	
	//특정 게시판 목록을 선택한 경우라면
	if(content_board_idx != 0){ 
		sql += "and a1.content_board_idx = ? "; //sql문 추가 
	}
	sql += "order by a1.content_idx desc limit ?, 10;"; // ?값에 시작 목록 번호 ~ 10개씩 데이터 가져옴
			
	
	
	//sql 실행
	PreparedStatement pstmt = conn.prepareStatement(sql);
	
	if(content_board_idx != 0) { //전체 게시판일 경우 
		pstmt.setInt(1, content_board_idx);
		pstmt.setInt(2, startIndex);
	}else {
		pstmt.setInt(1, startIndex);
	}
	
	//응답 결과 세팅
	ResultSet rs = pstmt.executeQuery();
	
	JSONArray root = new JSONArray();
	
	while(rs.next()) {
		int contentIdx = rs.getInt("content_idx");
		String contentNickName = rs.getString("content_nick_name");
		String contentWriteDate = rs.getString("content_write_date");
		String contentSubject = rs.getString("content_subject");
		
		JSONObject obj = new JSONObject();
		obj.put("content_idx", contentIdx);
		obj.put("content_nick_name", contentNickName);
		obj.put("content_write_date", contentWriteDate);
		obj.put("content_subject", contentSubject);
		
		root.add(obj); //JSON 배엵객체에 최종 add 처리 
	}
	
	conn.close(); //접속 종료 
%>
<%= root.toJSONString() %>