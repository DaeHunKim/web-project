<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.sql.*" import="java.util.*"%>
<%
if(session.getAttribute("userId") == null) 
	out.println("<script>alert('로그인 해 주세요.'); location='../index.jsp'</script>");
%>	
<%
	// DB 접속을 위한 준비
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;

	String dbUrl = "jdbc:mysql://localhost:3306/wb_bong4";
	String dbUser = "root";
	String dbPassword = "tiger";

	request.setCharacterEncoding("utf-8");

	String userid = (String) session.getAttribute("userId");
	String pwd = request.getParameter("pwd");
	String pwd_confirm = request.getParameter("pwd_confirm");
	String pwd_chn = request.getParameter("pwd_chn");
	String pwd_confirm_chn = request.getParameter("pwd_confirm_chn");
	String password = "";

	Class.forName("com.mysql.jdbc.Driver");
	List<String> errorMsgs = new ArrayList<String>();
	int result = 0;
	if (pwd == null || pwd.length() < 6) {
		errorMsgs.add("비밀번호는 6자 이상 입력해주세요.");
	}
	if (!pwd.equals(pwd_confirm)) {
		errorMsgs.add("비밀번호가 일치하지 않습니다.");
	}
	if (!pwd_chn.equals(pwd_confirm_chn)) {
		errorMsgs.add("비밀번호가 일치하지 않습니다.");
	}
	if (errorMsgs.size() == 0) {
		try {
			//DB 접속
			conn = DriverManager.getConnection(dbUrl, dbUser,
					dbPassword);
			//질의준비
			stmt = conn
					.prepareStatement("SELECT * FROM user where id=?");
			stmt.setString(1, userid);
			//수행
			rs = stmt.executeQuery();

			if (rs.next()) {
				password = rs.getString("password");
				if (!password.equals(pwd)) {
					  out.println("<script>alert('비밀번호가 틀렸습니다.'); location='pwd_change.jsp'</script>");
				} 
			}
		} catch (SQLException e) {
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
		try {
			conn = DriverManager.getConnection(dbUrl, dbUser,
					dbPassword);
			stmt = conn
					.prepareStatement("UPDATE user SET password=? where id=?");
			stmt.setString(1, pwd_chn);
			stmt.setString(2, userid);
			result = stmt.executeUpdate();
		} catch (SQLException e) {
			errorMsgs.add("SQL 에러: " + e.getMessage());
		} finally {
			// 무슨 일이 있어도 리소스를 제대로 종료
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
					<LI><A href="member/signout.jsp">로그 아웃</A></LI>
					<LI><A href="#">내 정보</A></LI>
					<LI><A href="#">내가 쓴 게시글</A></LI>
					<LI><A href="#">게시글 쓰기</A></LI>
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
					session.invalidate();
					out.println("<script>alert('변경된 비밀 번호로 다시 로그인해 주세요.'); location='../index.jsp'</script>");
				}
			%>
		</div>
		<div id="footer">함께 하는 봉사</div>
	</div>
</body>
</html>