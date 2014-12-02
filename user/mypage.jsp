<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" import="java.util.ArrayList"%>
<%
if(session.getAttribute("userid") == null) 
	out.println("<script>alert('로그인 해 주세요.'); location='../index.jsp'</script>");
%>
<%
	String errorMsg = null;

	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	// DB 접속을 위한 준비
	Class.forName("com.mysql.jdbc.Driver");
	String dbUrl = "jdbc:mysql://localhost:3306/project";
	String dbUser = "kim";
	String dbPassword = "daehun";
		
	request.setCharacterEncoding("utf-8");
	String user_id = (String) session.getAttribute("userid");
	String path = "";
	String id = "";
	String user1 = "";
	String user2 = "";
	String confirm = "";
	String name = "";
	String pwd = "";
	String pwd_confirm = "";
	String myurl = "";

	ArrayList<String> errorMsgs = new ArrayList<String>();
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<link href="../stylesheets/bootstrap.min.css" rel="stylesheet">
<link href="../stylesheets/main.css" rel="stylesheet" type="text/css">
<script src='../js/jquery-1.8.2.min.js'></script>
<script src="../js/bootstrap.min.js"></script>
<script type="text/javascript">

</script>
</head>
<body>
		<%
			if (session.getAttribute("userid") == null) {
		%>
		<UL id="toolbar" class="clearfix">
			<LI><A href="../index.jsp">home</A></LI>
			<LI><A href="signup.jsp">sign up</A></LI>
			<LI><A href="signin.jsp">sign in</A></LI>
		</UL>
		
		<%
			}
		%>
		
		<form name="update" class="form-horizontal" action="update.jsp"
				method="post">
				회원정보를 수정하시거나 회원을 탈퇴 하실 수 있습니다. 정보를 수정하거나 삭제하시려면 현재 비밀번호를 입력해 주세요<br> 
				비밀 번호를 변경 하시려면 아래의 링크를 이용해 주세요 <br>
				<a href = "pwd_change.jsp">비밀번호 변경</a>
				<fieldset>
					<legend class="legnd">마이페이지</legend>
					<h5><%=session.getAttribute("name")%></h5>
					<div class="control-group">
						<label class="control-label" for="name">name</label>
						<div class="controls">
							<input type="text" name="name">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label" for="pwd">Password</label>
						<div class="controls">
							<input type="password" name="pwd">
						</div>
					</div>

					<div class="control-group">
						<label class="control-label" for="pwd_confirm">Password
							Confirmation</label>
						<div class="controls">
							<input type="password" name="pwd_confirm">
						</div>
					</div>

					<div class="form-actions">
						<a href="../index.jsp" class="btn">home</a> <input type="submit"
							class="btn btn-primary" value="수정"> <input type="button"
							class="btn btn-primary" value="탈퇴" onclick="del()">
					</div>
				</fieldset>
			</form>
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
								user1 = rs.getString("useridA");
								user2 = rs.getString("useridB");
								confirm = rs.getString("confirm");
								if (confirm.equals("false")) {
									if (user2.equals(user_id)) {
				%>
				<h2>
					<a href="../member/friend_confirm.jsp?useridA=<%=user1%>"><%=user1%>
						wants to be your friend</a>
				</h2>
				<%
					}
								} else if (confirm.equals("true")) {
									if (user2.equals(user_id)) {
				%>
				<h2>
					<a href="sketch_userpage.jsp?userid=<%=user1%>"><%=user1%></a>
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
		<div id="footer">Copyright ⓒ . 2012 . L.o.h . All Rights
			Reserved
			</div>
			
</body>
</html>