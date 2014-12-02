<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.sql.*" import="java.util.*"%>
<%
if(session.getAttribute("name") == null) 
	out.println("<script>alert('로그인 해 주세요.'); location='../index.jsp'</script>");
%>
<%
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;

	// DB 접속을 위한 준비
	Class.forName("com.mysql.jdbc.Driver");
	String dbUrl = "jdbc:mysql://localhost:3306/project";
	String dbUser = "kim";
	String dbPassword = "daehun";

	//sketch 정보를 위한 변수 초기화
	request.setCharacterEncoding("utf-8");
	String user_id = (String) session.getAttribute("userid");
	String path = "";
	String useridA = "";
	String useridB = "";
	String confirm = "";

	ArrayList<String> errorMsgs = new ArrayList<String>();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sketch your Creative inner Voice</title>
<link href="../stylesheets/bootstrap.min.css" rel="stylesheet">
<link href="../stylesheets/main.css" rel="stylesheet" type="text/css">
<script src='../js/jquery-1.8.2.min.js'></script>
<script src="../js/bootstrap.min.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		var isExpand = false;
		$('#friendListButton').bind('click', function() {
			if (isExpand) {
				isExpand = false;
				$('#friendList').slideUp(500);
			} else {
				isExpand = true;
				$('#friendList').slideDown(500);
			}
		});

		$(window).bind('resize', function() {
			friendListPosition();
		});
	});

	function friendListPosition() {
		$('#friendList').css(
				{
					'top' : '60px',
					'left' : $('#wrap').offset().left + $('#wrap').width()
							- $('#friendList').width() + 'px'
				});
	}
</script>
</head>
<body id="home">
	<div id="sketchy_bg"></div>
	<div id="fake_body">
		<div id="wrap">
			<div id="header" class="clearfix">
				<div id="title">
				
				</div>
				<%
					if (session.getAttribute("userid") == null) {
				%>

				<UL id="toolbar" class="clearfix">
					<LI><A href="../index.jsp">home</A></LI>
					<LI><A href="signup.jsp">sign up</A></LI>
					<LI><A href="signin.jsp">sign in</A></LI>
				</UL>

				<%
					} else {
				%>
				<UL id="toolbar" class="clearfix">
					<LI><%=session.getAttribute("name")%></LI>
					<LI><A href="../index.jsp">home</A></LI>
					<LI><A href="signout.jsp">sign out</A></LI>
					<LI><A href="mypage.jsp">mypage</A></LI>
				</UL>
				<%
					}
				%>
			</div>
			<div class="container">
				<form name="pwd_change" class="form-horizontal"
					action="pwd_change_ok.jsp" method="post">
					<fieldset>
						<h1>현재 비밀번호</h1>
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

						<h1>변경할 비밀번호</h1>
						<div class="control-group">
							<label class="control-label" for="pwd_chn">Password</label>
							<div class="controls">
								<input type="password" name="pwd_chn">
							</div>
						</div>

						<div class="control-group">
							<label class="control-label" for="pwd_confirm_chn">Password
								Confirmation</label>
							<div class="controls">
								<input type="password" name="pwd_confirm_chn">
							</div>
						</div>
						<div class="form-actions">
							<input type="submit" class="btn btn-primary" value="변경">
						</div>
					</fieldset>
				</form>
			</div>
		</div>
		</div>
</body>
</html>