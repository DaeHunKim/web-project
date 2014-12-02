<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" import="java.util.*"
    %>
<%
 	String errorMsg = null;
 
 	String actionUrl;
 	
 	Connection conn = null;
 	PreparedStatement stmt = null;
 	ResultSet rs = null;
	// DB 접속을 위한 준비
	Class.forName("com.mysql.jdbc.Driver");
	String dbUrl = "jdbc:mysql://localhost:3309/bong4";
	String dbUser = "root";
	String dbPassword = "qwe123";
	
	String userid = "";
	String pwd = "";
	String name = "";

	
	
	int id = 0;
	try{
		id=Integer.parseInt(request.getParameter("id"));
	}catch (Exception e) {}

	if (id>0) {
		actionUrl="modify.jsp";
		try { 
			Class.forName("com.mysql.jdbc.Driver");
			
			conn = DriverManager.getConnection(dbUrl,dbUser,dbPassword);
			
			stmt = conn.prepareStatement("select * from user where id=?");
			stmt.setInt(1,id);
			
			rs = stmt.executeQuery();
			
				if(rs.next()) {
					userid = rs.getString("userid");
					pwd = rs.getString("password");
					name = rs.getString("name");
					
				}
			}catch (SQLException e) {
				errorMsg="SQL 에러:" + e.getMessage();
			} finally {
				if (rs != null) try{rs.close();} catch(SQLException e) {}
        if (stmt != null) try{stmt.close();} catch(SQLException e) {}
        if (conn != null) try{conn.close();} catch(SQLException e) {}
        		
			}
		} else {
			actionUrl ="register.jsp";
		}
%>   
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>회원가입</title>
	<link href="../stylesheets/bootstrap.min.css" rel="stylesheet">
  <link href="../stylesheets/main.css" rel="stylesheet">
	<script src="../js/jquery-1.11.1.min.js"></script>
	<script src="../js.bootstrap.min.js"></script>
</head>
<body>
	<%
	if (errorMsg != null && errorMsg.length() > 0 ) {
		out.print("<div class='alert'>" + errorMsg + "</div>");
	}
	%>
	<div>
	<form class="form-horizontal" action="<%=actionUrl %>" method="post">
			<fieldset>
					<legend class="legnd">빈칸없이 작성해 주십시오.</legend>
					<%
					if (id >0){
						out.println("<input type='hidden' name='userid' value='"+id+"'>");
					}
					%>
					<div class="control-group">
						<label class="control-label" for="userid">아이디</label>
						<div class="controls">
							<input type="text" name="userid" value="<%=userid%>">
						</div>
					</div>
					<%if (id <= 0) { %>
					<div class="control-group">
						<label class="control-label" for="pwd">패스워드</label>
						<div class="controls">
							<input type="password" name="pwd">
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="pwd_confirm">패스워드확인</label>
						<div class="controls">
							<input type="password" name="pwd_confirm">
						</div>
					</div>
					<% } %>
					<div class="control-group">
						<label class="control-label" for="name">이름</label>
						<div class="controls">
							<input type="text" name="name" value="<%=name%>">
						</div>
					</div>
					<div class="form-actions">
					<%if (id <= 0) { %>
						<input type="submit" class="btn btn-primary" value="등록">
					<%}else{ %>
						<input type="submit" class="btn btn-primary" value="수정">
					<% } %>
						<a href="../index.jsp" class="btn">취소</a> 
					</div>
				</fieldset>
			</form>
		</div>
</body>
</html>