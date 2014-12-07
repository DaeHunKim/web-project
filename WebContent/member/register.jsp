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

	
	request.setCharacterEncoding("utf-8");
	String userid = request.getParameter("userid");
	String name = request.getParameter("name");
	String pwd = request.getParameter("pwd");
	String pwd_confirm = request.getParameter("pwd_confirm");

	ArrayList<String> errorMsgs = new ArrayList<String>();
	int result = 0;

	if (userid == null || userid.trim().length() == 0) {
		errorMsgs.add("ID를 반드시 입력해주세요.");
	}
	if (pwd == null || pwd.length() < 6) {
		errorMsgs.add("비밀번호는 6자 이상 입력해주세요.");
	}
	if (!pwd.equals(pwd_confirm)) {
		errorMsgs.add("비밀번호가 일치하지 않습니다.");
	}
	if (name == null || name.trim().length() == 0) {
		errorMsgs.add("이름을 반드시 입력해주세요.");
	}

	if (errorMsgs.size() == 0) {
		try {
			conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
			stmt = conn.prepareStatement("INSERT INTO user(id,password,name) VALUES(?,?,?)");
			stmt.setString(1, userid);
			stmt.setString(3, name);
			stmt.setString(2, pwd);

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
				<%
					if (session.getAttribute("userId") == null) {
				%>

				<UL id="toolbar" class="clearfix">
					<LI><A href="signup.jsp">sign up</A></LI>
					<LI><A href="signin.jsp">sign in</A></LI>
				</UL>

				<%
					} else {
				%>
				<UL id="toolbar" class="clearfix">
					<LI><%=session.getAttribute("userName")%></LI>
					<LI><A href="member/signout.jsp">sign out</A></LI>
					<LI><A href="#">mypage</A></LI>
					<LI><A href="#">sketch my page</A></LI>
					<LI><A href="#">go to sketch page</A></LI>
				</UL>
				<%
					}
				%>
			</div>
			<div class="container">
				<%
					if (errorMsgs.size() > 0) {
				%>
				<div class="aler alert-error">
					<h3>Errors:</h3>
					<ul>
						<%
							for (String msg : errorMsgs) {
						%>
						<li><%=msg%></li>
						<%
							}
						%>
					</ul>
				</div>
			</div>
			<div class="form-action">
				<a onclick="history.back();" class="btn">back</a>
			</div>
			<%
				} else if (result == 1) {
			%>
			<div class="alert alert-success">
				<b><%=name%></b>님 등록해주셔서 감사합니다. 로그인 해주세요.
			</div>
			<div class="form-action">
				<a href="../index.jsp" class="btn">home</a>
			</div>
			<%
				}
			%>
		</div>
		<div id="footer">함께 하는 봉사</div>
	</div>
</body>
</html>