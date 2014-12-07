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

	//sketch 정보를 위한 변수 초기화
	String userid = request.getParameter("userid");
	String path = "";
	String id = request.getParameter("id");
	String subject ="";
	String frcontent ="";
	String content = "";
	String created_at = "";
	String created_at_reply = "";
	String replyuserid = "";
	int replyid = 0;
	
	//sketch friend 변수 초기화
	String userid2 = (String) session.getAttribute("userId");
	String useridA ="";
	String useridB ="";
	String confirm = "";
	int exist = 0;

	ArrayList<String> errorMsgs = new ArrayList<String>();
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
					<LI><A href="../member/signup.jsp">회원가입</A></LI>
					<LI><A href="../member/signin.jsp">로그인</A></LI>
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
					<LI><A href="sketch_creative.jsp">게시글 쓰기</A></LI>
					<LI><A href="sketch_list.jsp">게시글 목록</A></LI>
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
								stmt = conn
										.prepareStatement("SELECT * FROM sketch where userid=? and id=?");
								stmt.setString(1, userid);
								stmt.setInt(2, Integer.parseInt(id));

								//수행
								rs = stmt.executeQuery();

								while (rs.next()) {
									path = rs.getString("path");
									userid = rs.getString("userid");
									subject = rs.getString("subject");
									frcontent =rs.getString("content");
									created_at = rs.getString("created_at");
									%>
									<div id="board">
									<table border="1">
									<tr><td>글제목</td><td colspan="3"><%=subject %></td></tr>
									<tr><td>글내용</td><td colspan="10"><%=frcontent %></td></tr>
									</table>
									</div>
								<% out.print("<img src=" + path + "><br>" + created_at);
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
				
				<div id="content_friendList">
					<%
						if (errorMsgs.size() == 0) {
							try {
								conn = DriverManager.getConnection(dbUrl, dbUser,
										dbPassword);
								//질의준비
								stmt = conn.prepareStatement("SELECT * FROM friend");

								//수행
								rs = stmt.executeQuery();

								while (rs.next()) {
									useridA = rs.getString("user1");
									useridB = rs.getString("user2");
									if (userid.equals((String) session
											.getAttribute("userId"))) {
					%>
					<a href="sketch_delete.jsp?id=<%=id%>&userid=<%=userid%>">삭제</a>

					<%
						exist = 1;
										break;
									} else if (useridB.equals((String) session
											.getAttribute("userId"))) {
										if (userid.equals(useridA)) {
											exist = 1;											
											break;
										}
									}
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
								if (exist == 0) {
					%>
					<a href="../member/friend_add.jsp?useridB=<%=userid%>">친구 추가</a>
					
					<%
						}
							}
						}
					%>
					
					
					
				</div>

				<div id="sketch_item_reply">
					<form id="reply" action="sketch_reply_save.jsp" method="post">
						<input type="text" name="content"> <input type="hidden"
							name="sketchId" value="<%=id%>"> <input type="hidden"
							name="userid"
							value="<%=(String) session.getAttribute("userId")%>"> <input
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
									created_at_reply = rs.getString("created_at");
					%>
					<h2>
						<a href="sketch_userpage.jsp?userid=<%=replyuserid%>"><%=replyuserid%>
							: </a><%=content%>
						<font size=1px><%=created_at_reply%></font>
					</h2>
					<%
						if (userid.equals((String) session
											.getAttribute("userId"))) {
					%>
					<a
						href="sketch_reply_delete.jsp?replyid=<%=replyid%>&sketchId=<%=id%>&userid=<%=userid%>">삭제</a>
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


		<div id="footer">함께 하는 봉사</div>
	</div>
</body>
</html>
