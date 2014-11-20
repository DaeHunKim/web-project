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
<title>Insert title here</title>
</head>
<body>
	메인화면입니다.
	<div id="title">
	<a href="./users/signup.jsp" class="btn">회원가입</a>
	<a href="./users/signin.jsp" class="btn">로그인</a>
	<%
		if (session.getAttribute("userid") == null) {
	%>
		<UL id="toolbar" class="clearfix">
			<LI><A href="index.jsp">home</A></LI>
			<LI><A href="users/signup.jsp">sign up</A></LI>
			<LI><A href="users/signin.jsp">sign in</A></LI>
		</UL>
	<%
		} else {
	%>	
	<UL id="toolbar" class="clearfix">
		<LI><%=session.getAttribute("name")%></LI>
		<LI><A href="index.jsp">home</A></LI>
		<LI><A href="users/signout.jsp">sign out</A></LI>
		<LI><A href="users/mypage.jsp">mypage</A></LI>
		<LI>로그인상태</LI>
	</UL>
	<%
		}
	%>
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
	%>
	

	<%

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
	

	
	
	
</body>
</html>