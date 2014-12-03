<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" import="java.util.*"
    %>
<%
	String errorMsg = null;

	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	String user_id="";
	String path = "";
	String name = "";

	// DB 접속을 위한 준비
	Class.forName("com.mysql.jdbc.Driver");
	String dbUrl = "jdbc:mysql://localhost:3306/project";
	String dbUser = "kim";
	String dbPassword = "daehun";
	
	ArrayList<String> errorMsgs = new ArrayList<String>();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>메인</title>
	<link href="./stylesheets/bootstrap.min.css" rel="stylesheet">
  <link href="./stylesheets/main.css" rel="stylesheet">
	<script src="./js/jquery.min.js"></script>
	<script src="./js.bootstrap.min.js"></script>
</head>
<body>

<div id="wrap">
<%
	if (session.getAttribute("userid") == null) {
%>
	<div id="top">
	
		<a href="./users/signup.jsp">회원가입</a>
		<a href="./users/signin.jsp">로그인</a>
		<IMG id="masthead_image" alt="scv_main_logo"
						src="images/image4.PNG">
	</div>
<%
	}else{
%>
	<div id="top">
			<A href="users/signout.jsp">로그아웃</A>
			<A href="users/mypage.jsp">나의페이지</A>
			<!-- <LI id="friendListButton">친구목록</LI>-->
			<A href="users/mypage.jsp"><%=session.getAttribute("name")%>님</A>
			<IMG id="masthead_image" alt="scv_main_logo"
						src="images/image4.PNG">
	</div>
<%} %>
	<div id="header">
		
		<div id="navbar">
			<ul>
				<li><a href="" class="selected">HOME</a></li>
				<li><a href="">사이트소개</a></li>
				<li><a href="">봉사</a></li>
			</ul>	
		</div>

	
	<%
		if (errorMsgs.size() == 0) {
			try {
				conn = DriverManager.getConnection(dbUrl, dbUser,
						dbPassword);
				//질의준비
				stmt = conn.prepareStatement("SELECT * FROM user order by userid desc");

								//수행
								rs = stmt.executeQuery();

								out.println("<ul>");
								while (rs.next()) {
									user_id = rs.getString("userid");
									name = rs.getString("name");


							}
			} catch (SQLException e) {
					errorMsgs.add("SQL 에러:" + e.getMessage());
			} finally {
					if (rs != null)
						try {
							rs.close();
						} catch (SQLException e) {}
					if (stmt != null)
						try {
							stmt.close();
						} catch (SQLException e) {}
							if (conn != null)
								try {
									conn.close();
								} catch (SQLException e) {}
			}
		}
%>
	</div>
	</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <script src="../../dist/js/bootstrap.min.js"></script>
    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <script src="../../assets/js/ie10-viewport-bug-workaround.js"></script>
	

	
</body>
</html>