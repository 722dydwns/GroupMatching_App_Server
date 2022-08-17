<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "org.json.simple.*" %>

<%
	//여기서 할 작업은 곧장 클라이언트에 DB 속 게시글 목록 데이터를 추출해서 JSON 타입으로 보내주는 것
	
	//DB 접속 정보 세팅
	String dbUrl = "jdbc:mysql://localhost:3306/groupapp_db";
	String dbId = "root";
	String dbPw = "1234";
	
	//드라이버 로딩
	Class.forName("com.mysql.cj.jdbc.Driver");
	
	//DB 실질적 접속
	Connection conn = DriverManager.getConnection(dbUrl, dbId, dbPw);
	
	//쿼리문
	String sql = "select board_idx, board_name from board_table order by board_idx"	;
	
	PreparedStatement pstmt = conn.prepareStatement(sql);
	ResultSet rs = pstmt.executeQuery(); //쿼리 실행 
	
	//JSON 배열 객체 생성 
	JSONArray root = new JSONArray();
	
	while(rs.next()){
		int boardIdx = rs.getInt("board_idx");
		String boardName = rs.getString("board_name");
		
		//각각의 데이터 (idx, name)를  하나의 JSON 객체로 담음
		JSONObject obj = new JSONObject();
		obj.put("board_idx", boardIdx);
		obj.put("board_name", boardName);
		
		//위의 한 JSON 객체를 JSON배열 객체에 다시 담는다.
		root.add(obj);
	}
	
	//연결 종료
	conn.close();
%>
<%= root.toJSONString() %>