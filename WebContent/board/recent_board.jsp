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

	//sketch 정보를 위한 변수 초기화
	String path = "";
	String userid = "";
	String id = "";

	ArrayList<String> errorMsgs = new ArrayList<String>();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="../stylesheets/main.css" rel="stylesheet" type="text/css">
<script src='../js/jquery-1.8.2.min.js'></script>

<title>최근 게시판</title>
</head>

<body id="home">
	<div id="sketchy_bg"></div>
	<div id="fake_body">
		<div id="wrap">
			<div id="header" class="clearfix">
				<div id="title">
					최신 : <A href="recent_board.jsp"> 글</A>
				</div>
				<%
					if (session.getAttribute("userid") == null) {
				%>

				<UL id="toolbar" class="clearfix">
					<LI><A href="index.jsp">home</A></LI>
					<LI><A href="users/signout.jsp">로그아웃</A></LI>
					<LI><A href="users/mypage.jsp">내정보</A></LI>
					<LI><A href="board/writeForm.jsp">게시판</A></LI>
				</UL>

				<%
					} else {
				%>
				<UL id="toolbar" class="clearfix">
					<LI><%=session.getAttribute("userid")%></LI>
					<LI><A href="../index.jsp">home</A></LI>
					<LI><A href="../users/signout.jsp">로그 아웃</A></LI>
					<LI><A href="#">내정보</A></LI>
					<LI><A href="../board/writeForm.jsp">글쓰기</A></LI>
			
				</UL>

				<%
					}
				%>
			</div>
			
			<div id="content">
				<%
					if (errorMsgs.size() == 0) {
						try {
							conn = DriverManager.getConnection(dbUrl, dbUser,
									dbPassword);
							//질의준비
							stmt = conn.prepareStatement("SELECT * FROM sketch order by id desc");

							//수행
							rs = stmt.executeQuery();

							while (rs.next()) {
								path = rs.getString("path");
								userid = rs.getString("userid");
								id = rs.getString("id");
				%>
				<a href="item_board.jsp?userid=<%=userid%>&id=<%=id%>"><img
					src="<%=path%>" width="300" height="210"></a>

				<%
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
			</div>
		</div>

		
	</div>
</body>
</html>