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
	
	//user 정보를 위한 변수 초기화
	String user_id="";
	String name = "";
	
	//sketch 정보를 위한 변수 초기화
	String userid="";
	String path ="";
	String id ="";
	
	//최신글 3개만 출력 하려는 변수 지정
	int Recent_cnt=0;

	ArrayList<String> errorMsgs = new ArrayList<String>();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="stylesheets/main.css" rel="stylesheet" type="text/css">
<title>홈 화면 </title>
<script src='js/jquery-1.8.2.min.js'></script>
<script type="text/javascript">
</script>
</head>
<body id ="home">
	메인화면입니다.
	<div id="title">
	<a href="./users/signup.jsp" class="btn">회원가입</a>
	<a href="./users/signin.jsp" class="btn">로그인</a>
	<a href="./board/writeForm.jsp" class="btn">게시판</a>


	<%
		if (session.getAttribute("userid") == null) {
	%>
		<UL id="toolbar" class="clearfix">
			<LI><A href="index.jsp">home</A></LI>
			<LI><A href="users/signup.jsp">회원가입</A></LI>
			<LI><A href="users/signin.jsp">로그인 </A></LI>
		</UL>
	<%
		} else {
	%>	
	<UL id="toolbar" class="clearfix">
		<LI><%=session.getAttribute("name")%></LI>
		<LI><A href="index.jsp">home</A></LI>
		<LI><A href="users/signout.jsp">로그아웃</A></LI>
		<LI><A href="users/mypage.jsp">내정보</A></LI>
		<LI><A href="board/writeForm.jsp">게시판</A></LI>
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