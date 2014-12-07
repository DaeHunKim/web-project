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
	String id = "";
	String created_at = "";
	String subject ="";
	
	//sketch friend 변수 초기화
	String userid2 = (String) session.getAttribute("userId");
	String useridA ="";
	String useridB ="";
	String confirm = "";

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
					<LI><A href="../member/signup.jsp">로그 아웃</A></LI>
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
					<LI><A href="sketch_creative.jsp">게시글 쓰기 </A></LI>
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
										.prepareStatement("SELECT * FROM sketch where userid = ? order by id desc");
								stmt.setString(1, userid);

								//수행
								rs = stmt.executeQuery();

								while (rs.next()) {
									path = rs.getString("path");
									id = rs.getString("id");
									created_at = rs.getString("created_at");
									subject = rs.getString("subject");
									out.println("<br>");
									out.println("<br>");
									
									
						 %>
						<table border="1">					
						<tr><td>글제목</td><td><%=subject %></td></tr>
						<tr><td colspan="2"><a href="sketch/sketch_item.jsp?userid=<%=userid%>&id=<%=id%>"><img
						src="<%=path%>" width="300" height="210"></a></td></tr>
						</table>
						
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
			<div id="footer"> 함께 하는 봉사 </div>
	</div>
</body>
</html>

