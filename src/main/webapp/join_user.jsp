<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<% 
	//이 jsp 에서는 클라이언트가 DB 상에 가입 처리를 원하는 회원 정보를 POST 형태로 받아서
	//다시 DB 상에 저장시켜주는 기능을 할 것이다.
	
	//클라이언트가 전달하는 데이터 한글 깨지지 않도록 설정
	request.setCharacterEncoding("utf-8");
		
	//클라이언트가 전달한 데이터 추출
	String userId = request.getParameter("user_id");
	String userPw = request.getParameter("user_pw");
	String userNickName = request.getParameter("user_nick_name");
	
	//DB 접속 정보 세팅
	String dbUrl = "jdbc:mysql://localhost:3306/groupapp_db";
	String dbId = "root";
	String dbPw = "1234";
	
	//드라이버 로딩
	Class.forName("com.mysql.cj.jdbc.Driver");
	
	//DB 실질적 접속
	Connection conn = DriverManager.getConnection(dbUrl, dbId, dbPw);
	
	//쿼리문 작성
	String sql = "insert into user_table "
				+ "(user_id, user_pw, user_nick_name) "
				+ "values (?, ?, ?)";
	//쿼리 실행
	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, userId);
	pstmt.setString(2, userPw);
	pstmt.setString(3, userNickName);
	
	pstmt.execute();
	
	//접속 종료
	conn.close();

%>