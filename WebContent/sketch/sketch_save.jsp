<%@page import="java.sql.*"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
if(session.getAttribute("userId") == null) 
	out.println("<script>alert('로그인 해 주세요.'); location='../index.jsp'</script>");
%>	
<%
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;

	// DB 접속을 위한 준비
	Class.forName("com.mysql.jdbc.Driver");
	String dbUrl = "jdbc:mysql://localhost:3306/wb_bong4";
	String dbUser = "root";
	String dbPassword = "tiger";

	request.setCharacterEncoding("utf-8");

	String sketchUrl = (String) request.getParameter("sketchUrl");
	String userid = (String) session.getAttribute("userId");
	String subject = request.getParameter("subject");
	String content = request.getParameter("content").replaceAll("\r\n","<br/>");

	ArrayList<String> errorMsgs = new ArrayList<String>();
	int result = 0;

	if (errorMsgs.size() == 0) {
		try {
			conn = DriverManager.getConnection(dbUrl, dbUser,
					dbPassword);
			stmt = conn
					.prepareStatement("INSERT INTO sketch(path,userid,subject,content) VALUES(?,?,?,?)");
			stmt.setString(1, sketchUrl);
			stmt.setString(2, userid);
			stmt.setString(3,subject);
			stmt.setString(4,content);
			result = stmt.executeUpdate();
			if (result != 1) {
				errorMsgs.add("등록에 실패하였습니다.");
			}
		} catch (SQLException e) {
			errorMsgs.add("SQL 에러:" + e.getMessage());
		} finally {
			if (rs != null)
				try {
					rs.close();
				} catch (SQLException e) {
				}
			if (stmt != null)
				try {
					stmt.close();
				} catch (SQLException e) {
				}
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e) {
				}
		}
	}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="../stylesheets/main.css" rel="stylesheet" type="text/css">
<script src='../js/jquery-1.8.2.min.js'></script>


<title>bong4</title>
</head>
<body id="home">
	<div id="sketchy_bg"></div>
	<div id="fake_body">
		<div id="wrap">
			<div id="header" class="clearfix">
				<div id="title">
				</div>
				<%
					if (session.getAttribute("userId") == null) {
				%>

				<UL id="toolbar" class="clearfix">
					<LI><A href="../index.jsp">홈</A></LI>
					<LI><A href="../member/signup.jsp">회원 가입</A></LI>
					<LI><A href="../member/signin.jsp">로그 인</A></LI>
				</UL>

				<%
					} else {
				%>
				<UL id="toolbar" class="clearfix">
					<LI><%=session.getAttribute("userName")%></LI>
					<LI><A href="../index.jsp">홈</A></LI>
					<LI><A href="../member/signout.jsp">로그 아웃</A></LI>
					<LI><A href="../member/mypage.jsp">내 정보</A></LI>
					<LI><A href="sketch_mypage.jsp">내가 쓴 게시글</A></LI>
					<LI><A href="sketch_creative.jsp">게시 글 쓰기</A></LI>
					<LI><A href="sketch_list.jsp">게시글 목록</A></LI>
				</UL>
				<%
					}
				%>
			</div>
			<div id="board">
			<table border="1">
			<tr><td>글제목</td><td colspan="3"><%=subject %></td></tr>
			<tr><td>글내용</td><td colspan="10"><%=content %></td></tr>
			</table>
			</div>
			<div id="sketch_save_content">
				<%
					out.print("<img src=" + sketchUrl + "> <br> 저장 되었습니다.");
				%>
			</div>
		</div>

		<div id="footer">함께 하는 봉사
			</div>
	</div>
</body>
</html>