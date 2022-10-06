<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import = "com.oreilly.servlet.*" %>
<%@ page import = "com.oreilly.servlet.multipart.*" %>
<%
	//클라이언트가 전달하는 데이터 한글 깨지지 않도록 설정
	request.setCharacterEncoding("utf-8");

	//실제 이미지 업로드할 upload 폴더의 경로 구하기 
	String uploadPath = application.getRealPath("upload");
	
	//중복된 이름에 대한 정책 객체 
	DefaultFileRenamePolicy policy = new DefaultFileRenamePolicy();
	//Request 이미지 담을 multiRequest
	//MultipartRequest multi = new MultipartRequest(request, uploadPath, 100*1024*1024, policy);
	MultipartRequest multi = new MultipartRequest(request, uploadPath, 100*1024*1024, "utf-8", policy);
		
	//클라이언트가 보낸 데이터 추출 
	// 수정할 글 번호 idx값 추출
	String str1 = multi.getParameter("content_idx");
	int contentIdx = Integer.parseInt(str1);

	//수정 이후 처리된 게시글 내용 데이터 차례로 받아 추출
	String contentSubject = multi.getParameter("content_subject"); //글 제목
	String contentText = multi.getParameter("content_text"); //글 내용text
	String contentImage = multi.getFilesystemName("content_image"); //첨부 이미지 
	String str2 = multi.getParameter("content_board_idx"); //게시글 목록 idx
	int contentBoardIdx = Integer.parseInt(str2);
	
	System.out.println(contentSubject);
	System.out.println(contentText);
	
	

	//DB 접속 정보 세팅
	String dbUrl = "jdbc:mysql://localhost:3306/groupapp_db";
	String dbId = "root";
	String dbPw = "1234";
	
	//드라이버 로딩
	Class.forName("com.mysql.cj.jdbc.Driver");
	
	//DB 실질적 접속
	Connection conn = DriverManager.getConnection(dbUrl, dbId, dbPw);
	
	//이미지 존재 유무에 따르 처리 분기
	if(contentImage == null) {
		String sql = "update content_table "
					+ "set content_subject = ?, content_text = ?, content_board_idx = ? "
					+ "where content_idx = ?";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		
		pstmt.setString(1, contentSubject);
		pstmt.setString(2, contentText);
		pstmt.setInt(3, contentBoardIdx);
		pstmt.setInt(4, contentIdx);
		
		pstmt.execute();
	}else{
		String sql = "update content_table "
				+ "set content_subject = ?, content_text = ?, content_board_idx = ?, content_image = ? "
				+ "where content_idx = ?";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		
		pstmt.setString(1, contentSubject);
		pstmt.setString(2, contentText);
		pstmt.setInt(3, contentBoardIdx);
		pstmt.setString(4, contentImage);
		pstmt.setInt(5, contentIdx);
		
		pstmt.execute();
	}	
	//데이터 베이스 접속 종료
	conn.close();

%>