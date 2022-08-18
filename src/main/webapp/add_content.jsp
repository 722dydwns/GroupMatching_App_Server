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
	//System.out.println(uploadPath);
	
	//파일 업로드 처리 
	DefaultFileRenamePolicy policy = new DefaultFileRenamePolicy(); //중복된 파일이름 변경 정책 객체
	MultipartRequest multi = new MultipartRequest(request, uploadPath, 100*1024*1024, "utf-8", policy);

	//클라이언트가 보낸 작성 게시글 관련 데이터 추출 [request -> multi 변경 ]
	String str1= multi.getParameter("content_board_idx");
	int content_board_idx = Integer.parseInt(str1); //형변환
	
	String str2 = multi.getParameter("content_writer_idx");
	int content_writer_idx = Integer.parseInt(str2); //형변환
	
	String content_subject = multi.getParameter("content_subject");
	String content_text = multi.getParameter("content_text");
	
	//이미지 데이터 
	String content_image = multi.getFilesystemName("content_image"); 
	
	//DB 접속 정보 세팅
	String dbUrl = "jdbc:mysql://localhost:3306/groupapp_db";
	String dbId = "root";
	String dbPw = "1234";
	
	//드라이버 로딩
	Class.forName("com.mysql.cj.jdbc.Driver");
	
	//DB 실질적 접속
	Connection conn = DriverManager.getConnection(dbUrl, dbId, dbPw);
	
	//쿼리문 작성 - 게시글목록/작성자idx/글제목/글내용
	String sql = "insert into content_table "
				+ "(content_board_idx, content_writer_idx, content_subject, content_text, content_image) values (?, ?, ?, ?, ?)";
	
	//쿼리 실행 
	PreparedStatement pstmt = conn.prepareStatement(sql);
	
	pstmt.setInt(1, content_board_idx);
	pstmt.setInt(2, content_writer_idx);
	pstmt.setString(3, content_subject);
	pstmt.setString(4, content_text);
	pstmt.setString(5, content_image);
	
	pstmt.execute();//실행 
	
	//현재 작성한 게시글 idx 값을 응답 결과로 보내준다.
	//현재의 게시글 목록 idx 중에서 가장 content_idx 가 큰 애를 가져옴 (최근 작성 순)
	String sql2 = "select max(content_idx) as read_content_idx from content_table where content_board_idx = ?";
	
	PreparedStatement pstmt2 = conn.prepareStatement(sql2);
	pstmt2.setInt(1, content_board_idx);
	
	ResultSet rs = pstmt2.executeQuery();
	rs.next();
	
	int read_content_idx = rs.getInt("read_content_idx");
	
	conn.close();//접속 끊기 
%>
<%= read_content_idx %>