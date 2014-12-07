<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="javax.servlet.jsp.tagext.TryCatchFinally"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String errorMsg = null;

	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;

	// DB 접속을 위한 준비
	String dbUrl = "jdbc:mysql://localhost:3306/wb_bong4";
	String dbUser = "root";
	String dbPassword = "tiger";
	//사용자 정보를 위한 변수 초기화
	String userid = "";
	String name = "";
	String password = "";
	
	//post
	String id = request.getParameter("id");	
	String pwd = request.getParameter("pwd");
	boolean signin = false;

	try {
		Class.forName("com.mysql.jdbc.Driver");

		//DB 접속
		conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

		//질의준비
		stmt = conn
				.prepareStatement("SELECT * FROM user ");		
		//수행
		rs = stmt.executeQuery();

		while(rs.next()) {
			userid = rs.getString("id");
			name = rs.getString("name");
			password = rs.getString("password");
			if (userid.equals(id) && password.equals(pwd)) {
				// 로그인 성공
				session.setAttribute("userId", userid);
				session.setAttribute("userName", name);
				signin = true;
				break;
			}
		}
	} catch (SQLException e) {
		errorMsg = "SQL 에러 : " + e.getMessage();
	} finally {
		//리소스를 종료
		if (rs != null)
			try {
				rs.close();
			} catch (SQLException e) {
			}
		if (stmt != null)
			try {
				rs.close();
			} catch (SQLException e) {
			}
		if (conn != null)
			try {
				rs.close();
			} catch (SQLException e) {
			}
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>bong4</title>
<link href="../stylesheets/bootstrap.min.css" rel="stylesheet">
<link href="../stylesheets/main.css" rel="stylesheet" type="text/css">
<script src="http://code.jquery.com/jquery-latest.js"></script>
<script src="../js/bootstrap.min.js"></script>
</head>
<body id="home">
	<div id="sketchy_bg"></div>
	<div id="fake_body">
		<div id="wrap">
			<div id="header" class="clearfix">
				<div id="title">
					  
				</div>

				<UL id="toolbar" class="clearfix">
					<LI><A href="../index.jsp">홈</A></LI>
					<LI><A href="signup.jsp">회원 가입</A></LI>
					<LI><A href="signin.jsp">로그 인</A></LI>
				</UL>

			</div>
			<%
				if (request.getMethod() == "POST") {
					if (id == null || pwd == null || id.length() == 0
							|| pwd.length() == 0) {
			%>
			<div class="error">아이디와 비밀번호를 입력하세요.</div>
			<%
				} else if (signin) {
						// 로그인 성공
						response.sendRedirect("../index.jsp");
					} else {
			%>
			<div class="error">아이디나 비밀번호가 잘못되었습니다.</div>
			<%
				}

				}
			%>

			<form method="post">
				<br> ID: <input type="text" name="id"><br>
				Password: <input type="password" name="pwd"><br> <input
					type="submit" value="Sign in">
			</form>
		</div>

		<div id="footer">함께 하는 봉사</div>
	</div>
</html>

