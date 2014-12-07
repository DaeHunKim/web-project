<%@page import="java.sql.*"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;

	// DB 접속을 위한 준비
	Class.forName("com.mysql.jdbc.Driver");
	String dbUrl = "jdbc:mysql://localhost:3306/wb_bong4";
	String dbUser = "root";
	String dbPassword = "tiger";
	
	//그림판 약도 그리기 정보를 위한 변수 초기화
	String subject = "";
	String userid="";
	String path = "";
	String id = "";
	String created_at = "";
	
	//친구 리스트 변수 초기화
	String userid2 = (String) session.getAttribute("userId");
	String useridA ="";
	String useridB ="";
	String confirm = "";
		
	//게시글 3개 출력 란
	int sketch_cnt = 0;

	ArrayList<String> errorMsgs = new ArrayList<String>();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="../stylesheets/main.css" rel="stylesheet" type="text/css">
<link href="../stylesheets/bootstrap.min.css" rel="stylesheet">
<script src='../js/jquery-1.8.2.min.js'></script>

<title>그림판 약도로 그리고 봉사도 함께 함께</title>

</head>

<body id="home">
	<div id="sketchy_bg"></div>
	<div id="fake_body">
		<div id="wrap">
			<div id="header" class="clearfix">
				<div id="title">
					<A href="./sketch_recent.jsp">최근 게시글</A>
				</div>
				<%
					if (session.getAttribute("userId") == null) {
				%>

				<UL id="toolbar" class="clearfix">
					<LI><A href="../index.jsp">홈</A></LI>
					<LI><A href="../member/signup.jsp">회원 가입</A></LI>
					<LI><A href="../member/signin.jsp">로그 인</A></LI>
					<LI><A href="../member/photo.jsp">즐거운 봉사</A><LI>
				</UL>

				<%
					} else {
				%>
				<UL id="toolbar" class="clearfix">
					<LI><%=session.getAttribute("userName")%></LI>
					<LI><A href="../index.jsp">홈</A></LI>
					<LI><A href="../member/signout.jsp">로그 아웃</A></LI>
					<LI><A href="../member/mypage.jsp">내정보</A></LI>
					<LI><A href="./sketch_mypage.jsp">내게시글</A></LI>
					<LI><A href="./sketch_creative.jsp">게시글 작성</A></LI>
				</UL>
				<%
					}
				%>
			</div>

			<div id="content">
				<div id="content_recent">
					<h1>모집게시글</h1>
					
					<%
						if (errorMsgs.size() == 0) {
							try {
								conn = DriverManager.getConnection(dbUrl, dbUser,
										dbPassword);
								//질의준비
								stmt = conn
										.prepareStatement("SELECT * FROM sketch order by id desc");

								//수행
								rs = stmt.executeQuery();

								out.println("<ul>");
								while (rs.next()) {
									sketch_cnt++;
									path = rs.getString("path");
									userid = rs.getString("userid");
									id = rs.getString("id");
									subject = rs.getString("subject");
									created_at = rs.getString("created_at");
					%>
					<table border="1">
									<tr><td>글제목</td><td colspan="3"><a href="./sketch_item.jsp?userid=<%=userid%>&id=<%=id%>"><%=subject %></a></td></tr>
									<tr><td>작성자</td><td colspan="3"><%=userid %></td></tr>
									<tr><td>생성일</td><td colspan="3"><%=created_at %></td></tr>
					</table>
					

					<%
						if (sketch_cnt > 5) {
										out.println("<h1 align='right'><a href='./sketch_recent.jsp'>more...</a></h1>");
										break;

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