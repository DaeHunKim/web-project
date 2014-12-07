<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.sql.*" import="java.util.*"%>
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
	String dbUrl = "jdbc:mysql://localhost:3306/wb_bong4";
	String dbUser = "root";
	String dbPassword = "tiger";
	//sketch 정보를 위한 변수 초기화
	request.setCharacterEncoding("utf-8");
	String userid = (String) session.getAttribute("userId");
	String path = "";
	String id = "";
	String useridA = "";
	String useridB = "";
	String confirm = "";

	ArrayList<String> errorMsgs = new ArrayList<String>();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>bong4</title>
<link href="../stylesheets/bootstrap.min.css" rel="stylesheet">
<link href="../stylesheets/main.css" rel="stylesheet" type="text/css">
<script src='../js/jquery-1.8.2.min.js'></script>
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
					<LI><A href="../index.jsp">home</A></LI>
					<LI><A href="signup.jsp">sign up</A></LI>
					<LI><A href="signin.jsp">sign in</A></LI>
				</UL>

				<%
					} else {
				%>
				<UL id="toolbar" class="clearfix">
					<LI><%=session.getAttribute("userName")%></LI>
					<LI><A href="../index.jsp">홈</A></LI>
					<LI><A href="signout.jsp">로그 아웃</A></LI>
					<LI><A href="mypage.jsp">내정보</A></LI>
					<LI><A href="sketch/sketch_mypage.jsp">내가 쓴 게시글</A></LI>
					<LI><A href="sketch/sketch_creative.jsp">게시 글 쓰기</A></LI>
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
		
		<div id="footer">함께 하는 봉사</div>
	</div>
</body>
</html>