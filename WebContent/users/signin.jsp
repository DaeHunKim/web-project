<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" import="java.util.*"
    %>
<%
	String errorMsg = null;

	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;

	// DB 접속을 위한 준비
	Class.forName("com.mysql.jdbc.Driver");
	String dbUrl = "jdbc:mysql://localhost:3309/bong4";
	String dbUser = "root";
	String dbPassword = "qwe123";

	//사용자 정보를 위한 변수 초기화
	String user_id = "";
	String name = "";
	String pwd = "";
	
	//post
	String userid = request.getParameter("userid");	
	String password = request.getParameter("pwd");
	boolean signin = false;

	try {
		Class.forName("com.mysql.jdbc.Driver");

		//DB 접속
		conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

		//질의준비
		stmt = conn
				.prepareStatement("SELECT * FROM user");		
		//수행
		rs = stmt.executeQuery();

		while(rs.next()) {
			user_id = rs.getString("userid");
			name = rs.getString("name");
			pwd = rs.getString("password");
			if (user_id.equals(userid) && pwd.equals(password)) {
				// 로그인 성공
				session.setAttribute("userid", user_id);
				session.setAttribute("name", name);
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
	<title>로그인 창</title>
	<link href="../stylesheets/bootstrap.min.css" rel="stylesheet">
  <link href="../stylesheets/signin.css" rel="stylesheet">
	<script src="../js/jquery-1.11.1.min.js"></script>
	<script src="../js.bootstrap.min.js"></script>
</head>
<body>

			<%
				if (request.getMethod() == "POST") {
					if (userid == null || password == null || userid.length() == 0
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
			<div class="container">

      <form class="form-signin" method="post">
        <h2 class="form-signin-heading">Please sign in</h2>
        <input type="text" class="form-control" name="userid" placeholder="User ID" autofocus>
        <input type="password" class="form-control" name="pwd" placeholder="Password">
        <label class="checkbox">
          <input type="checkbox" value="remember-me"> Remember me
        </label>
        <button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>
      </form>
			</div>
    
</body>
</html>