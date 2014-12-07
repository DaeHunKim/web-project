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

	String name = "";
	String pwd = "";
	String pwd_confirm = "";
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
	function del() {
		if (confirm("삭제 하시겠습니까?")) {
			document.update.action = "delete.jsp";
			document.update.submit();
		}
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
					if (session.getAttribute("userId") == null) {
				%>

				<UL id="toolbar" class="clearfix">
					<LI><A href="../index.jsp">홈</A></LI>
					<LI><A href="signup.jsp">회원 가입</A></LI>
					<LI><A href="signin.jsp">로그 인</A></LI>
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
					<LI id="friendListButton">친구 목록</LI>
				</UL>
				<%
					}
				%>
			</div>

			<form name="update" class="form-horizontal" action="update.jsp"
				method="post">
				회원정보를 수정하시거나 회원을 탈퇴 하실 수 있습니다. 정보를 수정하거나 삭제하시려면 현재 비밀번호를 입력해 주세요<br> 
				비밀 번호를 변경 하시려면 아래의 링크를 이용해 주세요 <br>
				<a href = "pwd_change.jsp">비밀번호 변경</a>
				<fieldset>
					<legend class="legnd">내 정보</legend>
					<h5><%=session.getAttribute("userName")%></h5>
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
		</div>
		<div class="container">
		<div id="friendList">
		친구아이디를 클릭하시면 친구의 게시글을 보실 수 있습니다.<br> 
		<legend class="legnd">친구리스트</legend>
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
									if (useridB.equals(userid)) {
				%>
				<h2>
					<a href="../member/friend_confirm.jsp?useridA=<%=useridA%>"><%=useridA%>
						님이 친구가 되고 싶어 합니다.</a>
				</h2>
				<%
					}
								} else if (confirm.equals("true")) {
									if (useridB.equals(userid)) {
				%>
				<h2>
					<a href="../sketch/sketch_userpage.jsp?userid=<%=useridA%>"><%=useridA%></a>
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
			</div>
		<div id="footer">함께 하는 봉사
			</div>
	</div>
</html>

