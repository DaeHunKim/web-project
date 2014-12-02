<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" import="java.util.*"
    %>
    
<%

	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;

	// DB 접속을 위한 준비
	String dbUrl = "jdbc:mysql://localhost:3306/project";
	String dbUser = "kim";
	String dbPassword = "daehun";
	
	request.setCharacterEncoding("utf-8");
	String userid = request.getParameter("userid");
	String pwd = request.getParameter("pwd");
	String pwd_confirm = request.getParameter("pwd_confirm");
	String name = request.getParameter("name");
	
	
	
	ArrayList<String> errorMsgs = new ArrayList<String>();
	int result = 0;

	if (userid == null || userid.trim().length() == 0) {
		errorMsgs.add("아이디를 입력하시오.");
	}
	if (pwd == null || pwd.trim().length() < 6) {
		errorMsgs.add("패스워드를 6자리 이상 입력하시오.");
	}
	if (!pwd.equals(pwd_confirm)) {
		errorMsgs.add("패스워드가 일치하지 않습니다.");
	}
	if (name == null || name.trim().length() == 0) {
		errorMsgs.add("이름을 입력해주세요.");
	}
	
	if (errorMsgs.size() == 0) {
		try {
			conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
			stmt = conn.prepareStatement("INSERT INTO user(userid,password,name) VALUES(?,?,?)");
			stmt.setString(1, userid);
			stmt.setString(2, pwd);
			stmt.setString(3, name);
			
			
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
<title>환영합니다</title>
	<link href="../stylesheets/bootstrap.min.css" rel="stylesheet">
  <link href="../stylesheets/main.css" rel="stylesheet">
	<script src="../js/jquery-1.11.1.min.js"></script>
	<script src="../js.bootstrap.min.js"></script>
</head>
<body>
	<div class="container">
		<% if (errorMsgs.size() != 0) { %>
			<div class="alert alert-error">
				<h3>에러:</h3>
				<ul>
					<% for(String msg: errorMsgs) { %>
						<li><%=msg %></li>
						<% } %>
				</ul>
			</div>
			<div class="form-action">
				<a onclick="history.back();" class="btn">재작성</a>
			</div>
		<% } else if (result == 1) {%>
			<div class="alert alert-success">
				<b><%=name %></b>님 가입해 주셔서 감사합니다.
			</div>
			<div class="form-action">
				<a href="../index.jsp" class="btn">목록으로</a>
			</div>
			
		<% } %>
	</div> 
</body>
</html>