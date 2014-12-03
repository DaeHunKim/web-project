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
	String userid = request.getParameter("userid");
	String path = "";
	String id = request.getParameter("id");
	String content = "";
	String created_at = "";
	String created_at_reply = "";
	String replyuserid = "";
	int replyid = 0;
	
	ArrayList<String> errorMsgs = new ArrayList<String>();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="../stylesheets/main.css" rel="stylesheet" type="text/css">
<script src='../js/jquery-1.8.2.min.js'></script>

<title>item board</title>
</head>

<body id="home">
	<div id="sketchy_bg"></div>
		<div id="wrap">
			<div id="header" class="clearfix">
				<div id="title">
					최근 : <A href="recent_board.jsp">게시글</A>
				</div>
				<%
					if (session.getAttribute("userid") == null) {
				%>

				<UL id="toolbar" class="clearfix">
					<LI><A href="../index.jsp">home</A></LI>
					<LI><A href="../users/signup.jsp">sign up</A></LI>
					<LI><A href="../users/signin.jsp">sign in</A></LI>
				</UL>

				<%
					} else {
				%>
				<UL id="toolbar" class="clearfix">
					<LI><%=session.getAttribute("userid")%></LI>
					<LI><A href="../index.jsp">home</A></LI>
					<LI><A href="../users/signout.jsp">sign out</A></LI>
					<LI><A href="#">mypage</A></LI>
					<LI><A href="writemypage.jsp">내가 쓴 글보기</A></LI>
					<LI><A href="writeForm.jsp">게시글 쓰기</A></LI>
				</UL>
				<%
					}
				%>
			</div>

			<div id="content">
				<div id="content_pic">
					<h1><%=userid%></h1>
					<%
						if (errorMsgs.size() == 0) {
							try {
								conn = DriverManager.getConnection(dbUrl, dbUser,
										dbPassword);
								//질의준비
								stmt = conn.prepareStatement("SELECT * FROM sketch where userid=? and id=?");
								stmt.setString(1, userid);
								stmt.setInt(2, Integer.parseInt(id));

								//수행
								rs = stmt.executeQuery();

								while (rs.next()) {
									path = rs.getString("path");
									userid = rs.getString("userid");
									out.print("<img src=" + path + "><br>" + userid);
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
					<div id="item_reply">
					<form id="reply" action="sketch_reply_save.jsp" method="post">
						<input type="text" name="content"> <input type="hidden"
							name="sketchid" value="<%=id%>"> <input type="hidden"
							name="userid"
							value="<%=(String) session.getAttribute("userid")%>"> <input
							type="submit" value="COMMENT">
					</form>
					<%
						if (errorMsgs.size() == 0) {
							try {
								conn = DriverManager.getConnection(dbUrl, dbUser,
										dbPassword);
								//질의준비
								stmt = conn
										.prepareStatement("SELECT * FROM reply where sketchid=?");
								stmt.setInt(1, Integer.parseInt(id));

								//수행
								rs = stmt.executeQuery();

								while (rs.next()) {
									replyuserid = rs.getString("userid");
									replyid = rs.getInt("id");
									content = rs.getString("content");
					%>
					<h2>
						<a href="sketch_userpage.jsp?userid=<%=replyuserid%>"><%=replyuserid%>
							: </a><%=content%>
						<font size=1px><%=userid%></font>
					</h2>
					<%
						if (userid.equals((String) session
											.getAttribute("userid"))) {
					%>
					<a
						href="sketch_reply_delete.jsp?replyid=<%=replyid%>&sketchId=<%=id%>&userid=<%=userid%>">delete</a>
					<%
						}
					%>
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
				