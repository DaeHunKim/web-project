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
	String userid = request.getParameter("userid");
	String path = "";
	String id = "";
	String created_at = "";
	
	//sketch friend 변수 초기화
	String userid2 = (String) session.getAttribute("userId");
	String useridA ="";
	String useridB ="";
	String confirm = "";

	ArrayList<String> errorMsgs = new ArrayList<String>();
%>
<!DOCTYPE html>
<html>
<head>

<title>Insert title here</title>
</head>
<body>
<%
					if (session.getAttribute("userId") == null) {
				%>

				<UL id="toolbar" class="clearfix">
					<LI><A href="../index.jsp">home</A></LI>
					<LI><A href="../meber/signup.jsp">sign up</A></LI>
					<LI><A href="../meber/signin.jsp">sign in</A></LI>
				</UL>

				<%
					} else {
				%>
				<UL id="toolbar" class="clearfix">
					<LI><%=session.getAttribute("userName")%></LI>
					<LI><A href="../index.jsp">home</A></LI>
					<LI><A href="../meber/signout.jsp">sign out</A></LI>
					<LI id="friendListButton">Friend List</LI>
				</UL>
				<%
					}
				%>
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
								if (useridB.equals(userid2)) {
			%>
			<h2>
				<a href="../meber/friend_confirm.jsp?useridA=<%=useridA%>"><%=useridA%>
					wants to be your friend</a>
			</h2>
			<%
				}
							} else if (confirm.equals("true")) {
								if (useridB.equals(userid2)) {
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
</body>
</html>