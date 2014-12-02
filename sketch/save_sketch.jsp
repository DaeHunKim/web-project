<%@page import="java.sql.*"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
if(session.getAttribute("userid") == null) 
	out.println("<script>alert('로그인 해 주세요.'); location='../index.jsp'</script>");
%>	
<%
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;

	// DB 접속을 위한 준비
	Class.forName("com.mysql.jdbc.Driver");
	String dbUrl = "jdbc:mysql://localhost:3309/bong4";
	String dbUser = "root";
	String dbPassword = "qwe123";

	request.setCharacterEncoding("utf-8");

	String sketchUrl = (String) request.getParameter("sketchUrl");
	String userid = (String) session.getAttribute("userid");
	String subject = request.getParameter("subject");
	String content = request.getParameter("content");
	
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
			stmt.setString(3, subject);
			stmt.setString(4, content);
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
<script src='../js/jquery-1.8.2.min.js'></script>


<title>Sketch your Creative inner Voice</title>
</head>
<body id="home">
	<div id="sketchy_bg"></div>
		<div id="wrap">
			<div id="header" class="clearfix">
				<div id="title">
					신규 작성된 글 : <A href="recent_board.jsp">Best &amp; Recent
						Sketches</A>, <A href="#">User Accounts</A>, <A href="#">Sketch
						Slide show</A>
				</div>
				<%
					if (session.getAttribute("userid") == null) {
				%>

				<UL id="toolbar" class="clearfix">
					<LI><A href="../index.jsp">home</A></LI>
					<LI><A href="../user/signup.jsp">sign up</A></LI>
					<LI><A href="../user/signin.jsp">sign in</A></LI>
				</UL>

				<%
					} else {
				%>
				<UL id="toolbar" class="clearfix">
					<LI><%=session.getAttribute("userid")%></LI>
					<LI><A href="../index.jsp">home</A></LI>
					<LI><A href="../user/signout.jsp">로그 아웃</A></LI>
					<LI><A href="#">내정보</A></LI>
					<LI><A href="../writeForm.jsp">게시글 작성</A></LI>
				</UL>
				<%
					}
				%>
			</div>
			<div id="save_content">
				<%
					out.print("<img src=" + sketchUrl + "> <br> 저장 되었습니다.");
					out.print("내용"+content+ "<br> 나와랍");
				%>
			</div>
		</div>
</body>
</html>