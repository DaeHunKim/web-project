<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.sql.*" import="java.util.*"%>
<%
if(session.getAttribute("userId") == null) 
	out.println("<script>alert('로그인 해 주세요.'); location='../index.jsp'</script>");
%>	
<%
	// 현재 메뉴
	String errorMsg = null;
	int result = 0;

	// DB 접속을 위한 준비
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;

	String dbUrl = "jdbc:mysql://localhost:3306/wb_bong4";
	String dbUser = "root";
	String dbPassword = "tiger";

	request.setCharacterEncoding("utf-8");
	String userid = (String) session.getAttribute("userId");
	String password = "";
	String pwd = request.getParameter("pwd");
	String pwd_confirm = request.getParameter("pwd_confirm");
	List<String> errorMsgs = new ArrayList<String>();
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
					if (pwd.equals(pwd_confirm)) {
						session.invalidate();
						out.println("<script>alert('비밀번호가 틀렸습니다.'); location='mypage.jsp'</script>");
					}
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
			stmt = conn.prepareStatement("DELETE FROM user WHERE id=?");
			stmt.setString(1, userid);
			result = stmt.executeUpdate();
			if (result != 1) {
				errorMsg = "삭제에 실패했습니다.";
			}
		} catch (SQLException e) {
			errorMsg = "SQL 에러: " + e.getMessage();
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
<title>Sketch your Creative inner Voice</title>
<link href="../stylesheets/bootstrap.min.css" rel="stylesheet">
<link href="../stylesheets/main.css" rel="stylesheet" type="text/css">
<script src="http://code.jquery.com/jquery-latest.js"></script>
<script src="../js/bootstrap.min.js"></script>
</head>
<body>
	<div class="container">
		<%
			if (errorMsg != null) {
		%>
		<div class="alert alert-error">
			<h3>Errors:</h3>
			<%=errorMsg%>
		</div>
		<%
			} else {
		%>
		<div class="alert alert-success">사용자 정보를 삭제하였습니다.</div>
		<%
			}
		%>
		<div class="form-action">
			<a href="../index.jsp" class="btn">목록으로</a>
		</div>
	</div>
</body>
</html>