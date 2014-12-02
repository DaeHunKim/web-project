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
	String dbUrl = "jdbc:mysql://localhost:3309/scv";
	String dbUser = "root";
	String dbPassword = "qwe123";

	//sketch 정보를 위한 변수 초기화
	String userid = (String) session.getAttribute("userId");
	String path = "";
	String id = "";
	String useridA = "";
	String useridB = "";
	String confirm = "";

	ArrayList<String> errorMsgs = new ArrayList<String>();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="../stylesheets/main.css" rel="stylesheet" type="text/css">
<script src='../js/jquery-1.8.2.min.js'></script>
<title>Sketch your Creative inner Voice</title>
<script type="text/javascript">
	$(document).ready(function() {
		var isExpand = false;
		$('#friendListButton').bind('click', function() {
			if (isExpand) {
				isExpand = false;
				$('#friendList').slideUp(500);
			} else {
				isExpand = true;
				$('#friendList').slideDown(500);
			}
		});

		$(window).bind('resize', function() {
			friendListPosition();
		});
	});

	function friendListPosition() {
		$('#friendList').css(
				{
					'top' : '50px',
					'left' : $('#wrap').offset().left + $('#wrap').width()
							- $('#friendList').width() + 'px'
				});
	}
</script>
</head>

<body id="home">
	<div id="sketchy_bg"></div>
	<div id="fake_body">
		<div id="wrap">
			<div id="header" class="clearfix">
				<div id="title">
					New to SCV : <A href="sketch_recent.jsp">Recent Sketches</A>
				</div>
				<%
					if (session.getAttribute("userId") == null) {
				%>

				<UL id="toolbar" class="clearfix">
					<LI><A href="../index.jsp">home</A></LI>
					<LI><A href="../member/signup.jsp">sign up</A></LI>
					<LI><A href="../member/signin.jsp">sign in</A></LI>
				</UL>

				<%
					} else {
				%>
				<UL id="toolbar" class="clearfix">
					<LI><%=session.getAttribute("userName")%></LI>
					<LI><A href="../index.jsp">home</A></LI>
					<LI><A href="../member/signout.jsp">sign out</A></LI>
					<LI><A href="../member/mypage.jsp">mypage</A></LI>
					<LI><A href="sketch_mypage.jsp">sketch my page</A></LI>
					<LI><A href="sketch_creative.jsp">go to sketch page</A></LI>
					<LI id="friendListButton">Friend List</LI>
				</UL>
				<%
					}
				%>
			</div>
			<div id="friendList">
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
								confirm = rs.getString("confirm");
								if (confirm.equals("false")) {
									if (useridB.equals(userid)) {
				%>
				<h2>
					<a href="../member/friend_confirm.jsp?useridA=<%=useridA%>"><%=useridA%> wants to be your friend</a>
				</h2>
				<%
					}
								} else if (confirm.equals("true")) {
									if (useridB.equals(userid)) {
				%>
				<h2>
					<a href="sketch_userpage.jsp?userid=<%=useridA%>"><%=useridA%></a>
				</h2>
				<%
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
						}
					}
				%>
			</div>
			<div id="content">
				<div id="content_pic">
				<h1><%=session.getAttribute("userId") %></h1>
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
					%>
					<a href="sketch_item.jsp?userid=<%=userid%>&id=<%=id%>"><img
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

		<div id="footer">Copyright ⓒ . 2012 . L.o.h . All Rights
			Reserved</div>
	</div>
</body>
</html>

