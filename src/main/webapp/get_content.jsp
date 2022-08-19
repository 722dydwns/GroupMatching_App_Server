<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.json.simple.*" %>
<%
	//이 곳에서 DB 상에 저장해놨던 Content 테이블 데이터를 다시 응답결과로 클라이언트에게 보내주는 작업할 것
	
	request.setCharacterEncoding("utf-8");
	
	//1) 우선 클라이언트가 보낸 요청에서 read_content_idx값을 추출
	String str1 = request.getParameter("read_content_idx");
	int readContentIdx = Integer.parseInt(str1);
	
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
			+ "date_format(a1.content_write_date, '%Y-%m-%d') as content_write_date, a1.content_text, a1.content_image "
			+ "from content_table a1, user_table a2 "
			+ "where a1.content_writer_idx = a2.user_idx "
			+ "and content_idx = ?;";
			
	//sql 실행
	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, readContentIdx);
	
	//응답 보낼 데이터 세팅
	ResultSet rs = pstmt.executeQuery();
	rs.next();
	
	//여기서 select 정보는 1행이므로 JSON Object 객체에 담을 예정
	JSONObject obj = new JSONObject();
	
	//DB 상에서 추출한 데이터 임시로 뽑아온 뒤 
	String contentSubject = rs.getString("content_subject");
	String contentNickName = rs.getString("content_nick_name");
	String contentWriteDate = rs.getString("content_write_date");
	String contentText = rs.getString("content_text");
	String contentImage = rs.getString("content_image");
	
	//json object객체에 다시 세팅 
	obj.put("content_subject", contentSubject);
	obj.put("content_nick_name", contentNickName);
	obj.put("content_write_date", contentWriteDate);
	obj.put("content_text", contentText);
	obj.put("content_image", contentImage);
	
	//접속 종료
	conn.close();
%>
<%= obj.toJSONString() %>