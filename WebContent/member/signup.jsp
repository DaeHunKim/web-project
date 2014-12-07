<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="javax.servlet.jsp.tagext.TryCatchFinally"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	//사용자 정보를 위한 변수 초기화
	String userid = "";
	String name = "";
	String password = "";

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
				<UL id="toolbar" class="clearfix">
					<LI><A href="../index.jsp">홈</A></LI>
					<LI><A href="signup.jsp">회원 가입</A></LI>
					<LI><A href="signin.jsp">로그 인</A></LI>
				</UL>
			</div>
			<div class="container"></div>
			<form class="form-horizontal" action="register.jsp" method="post">
				<fieldset>
					<legend class="legnd">회원 가입</legend>
					<div class="control-group">
						<label class="control-label" for="userid">ID</label>
						<div class="controls">
							<input type="text" name="userid" value="<%=userid%>">
						</div>
					</div>

					<div class="control-group">
						<label class="control-label" for="name">Name</label>
						<div class="controls">
							<input type="text" name="name" value="<%=name%>">
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
							class="btn btn-primary" value="가입">
					</div>
				</fieldset>
			</form>

		</div>
		<div id="footer">함께 하는 봉사</div>
	</div>
</html>

