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
	String name = request.getParameter("name");
	String pwd = request.getParameter("pwd");
	String pwd_confirm = request.getParameter("pwd_confirm");
	String password = "";

	Class.forName("com.mysql.jdbc.Driver");
	List<String> errorMsgs = new ArrayList<String>();
	int result = 0;

	if (name == null || name.trim().length() == 0) {
		errorMsgs.add("이름을 반드시 입력해주세요.");
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
					  out.println("<script>alert('비밀번호가 틀렸습니다.'); location='mypage.jsp'</script>");
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
			if (pwd != null) {
				if (pwd.equals(pwd_confirm)) {
					if (name != null) {
						stmt = conn
								.prepareStatement("UPDATE user SET name=? where id=?");
						stmt.setString(1, name);
						stmt.setString(2, userid);
						result = stmt.executeUpdate();
						if (result != 1) {
							errorMsgs.add("변경에 실패하였습니다.");
						}
					}
				}
			}
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
					<LI><A href="../index.jsp">홈</A></LI>
					<LI><A href="signup.jsp">회원가입</A></LI>
					<LI><A href="signin.jsp">로그인</A></LI>
				</UL>

				<%
					} else {
				%>
				<UL id="toolbar" class="clearfix">
					<LI><%=session.getAttribute("userName")%></LI>
					<LI><A href="../index.jsp">홈</A></LI>
					<LI><A href="signout.jsp">로그 아웃</A></LI>
					<LI><A href="mypage.jsp">내정보</A></LI>
					<LI><A href="../sketch/sketch_mypage.jsp">내가 쓴 게시글 </A></LI>
					<LI><A href="../sketch/sketch_creative.jsp">게시 글 쓰기</A></LI>
					
				</UL>
				<%
					}
				%>
			</div>
			<div class="container">
				<%
					if (errorMsgs.size() > 0) {
				%>
				<div class="alert alert-error">
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
				<div class="form-action">
					<a onclick="history.back();" class="btn">뒤로 돌아가기</a>
				</div>
				<%
					} else if (result == 1) {
				%>
				<div class="alert alert-success">
					<b><%=name%></b>님 정보가 수정되었습니다.
				</div>
				<div class="form-action">
					<a href="../index.jsp" class="btn">home</a>
				</div>
				<%
					}
				%>
			</div>
		</div>


		<div id="footer">함께 하는 봉사</div>
	</div>
</body>
</html>