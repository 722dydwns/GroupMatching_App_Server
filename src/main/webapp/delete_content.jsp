<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%

	//클라이언트가 전달하는 데이터 한글 깨지지 않도록 설정
	request.setCharacterEncoding("utf-8");

	//클라이언트가 전달한 데이터 = 삭제할 게시글 idx 값 
	String str1 = request.getParameter("content_idx");
	int contentIdx = Integer.parseInt(str1);
	
	//DB 접속 정보 세팅
	String dbUrl = "jdbc:mysql://localhost:3306/groupapp_db";
	String dbId = "root";
	String dbPw = "1234";
	Class.forName("com.mysql.cj.jdbc.Driver");
	
	Connection conn = DriverManager.getConnection(dbUrl, dbId, dbPw);
	
	String sql = "delete from content_table where content_idx = ?";
	
	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, contentIdx);
	
	pstmt.execute();
	
	conn.close();
%>
