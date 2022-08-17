<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%
	//login_user.jsp에서는 클라이언트에서 로그인 시도 시 입력받은 사용자 id/pw 데이터값을 
	//받아서 실제로 해당 id/pw값의 user_idx 값을 반환하는 용도이다.
	
	//클라이언트가 전달하는 데이터 한글 깨지지 않도록 설정
	request.setCharacterEncoding("utf-8");
	//클라이언트가 보낸 데이터 추출
	String userId = request.getParameter("user_id");
	String userPw = request.getParameter("user_pw");

	//DB 접속 정보 세팅
	String dbUrl = "jdbc:mysql://localhost:3306/groupapp_db";
	String dbId = "root";
	String dbPw = "1234";
	
	//드라이버 로딩
	Class.forName("com.mysql.cj.jdbc.Driver");
	
	//DB 실질적 접속
	Connection conn = DriverManager.getConnection(dbUrl, dbId, dbPw);
	
	//쿼리문 작성
	String sql = "select user_idx from user_table "
				+ "where user_id = ? and user_pw = ?";
	//쿼리 실행 세팅
	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, userId);
	pstmt.setString(2, userPw);
	
	//쿼리 실행 반환값은 ResultSet으로 받음
	ResultSet rs = pstmt.executeQuery();
	
	boolean chk = rs.next();
	
	if(chk == false){ //가져온 값이 없다면
		out.write("FAIL");
	}else{ //가져온 값이 존재할 경우 
		int user_idx = rs.getInt("user_idx");
		out.write(user_idx + "");
	}
	
	//DB접속 종료
	conn.close();
%>