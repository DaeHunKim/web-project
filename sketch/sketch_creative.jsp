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
	String userid = (String) session.getAttribute("userId");
	
	//sketch friend 변수 초기화
	String useridA ="";
	String useridB ="";
	String confirm = "";

	ArrayList<String> errorMsgs = new ArrayList<String>();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="../stylesheets/main.css" rel="stylesheet" type="text/css">
<script src='../js/jquery-1.8.2.min.js'></script>
<script type="text/javascript">
	if (window.addEventListener) {
		window.addEventListener('load', InitEvent, false);
	}
	var canvas, context, tool;
	function InitEvent() {
		canvas = document.getElementById('drawCanvas');
		if (!canvas) {
			alert("캔버스 객체를 찾을 수 없음");
			return;
		}
		if (!canvas.getContext) {
			alert("Drawing Contextf를 찾을 수 없음");
			return;
		}
		context = canvas.getContext('2d');
		if (!context) {
			alert("getContext() 함수를 호출 할 수 없음");
			return;
		}
		// Pencil tool 객체를 생성 한다.
		tool = new tool_pencil();
		canvas.addEventListener('mousedown', ev_canvas, false);
		canvas.addEventListener('mousemove', ev_canvas, false);
		canvas.addEventListener('mouseup', ev_canvas, false);
	}
	function tool_pencil() {
		var tool = this;
		this.started = false;
		// 마우스를 누르는 순간 그리기 작업을 시작 한다. 
		this.mousedown = function(ev) {
			context.beginPath();
			context.moveTo(ev._x, ev._y);
			tool.started = true;
		};
		// 마우스가 이동하는 동안 계속 호출하여 Canvas에 Line을 그려 나간다
		this.mousemove = function(ev) {
			if (tool.started) {
				context.lineTo(ev._x, ev._y);
				context.stroke();
			}
		};
		// 마우스 떼면 그리기 작업을 중단한다
		this.mouseup = function(ev) {
			if (tool.started) {
				tool.mousemove(ev);
				tool.started = false;
			}
		};
	}
	// Canvas요소 내의 좌표를 결정 한다.
	function ev_canvas(ev) {
		if (ev.layerX || ev.layerX == 0) { // Firefox 브라우저
			ev._x = ev.layerX;
			ev._y = ev.layerY;
		} else if (ev.offsetX || ev.offsetX == 0) { // Opera 브라우저
			ev._x = ev.offsetX;
			ev._y = ev.offsetY;
		}
		// tool의 이벤트 핸들러를 호출한다.
		var func = tool[ev.type];
		if (func) {
			func(ev);
		}
	}
	function toDataURL() {
		var sketchUrl = $('#hiddenUrl')[0];
		// id f로 검색이기때문에 아까처럼 name 에만 적어노면 이게 안나옴 제이쿼리를 적극 이용해야지
		sketchUrl.value = canvas.toDataURL();

		$('#sketchForm').submit();

		// 이걸 누구한테 요청함?
		//save에 sketchUrl에있는 jsp 변수용!
	}
</script>
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
					'top' : '50px',
					'left' : $('#wrap').offset().left + $('#wrap').width()
							- $('#friendList').width() + 'px'
				});
	}
</script>

<title>Sketch your Creative inner Voice</title>
</head>
<body id="home">
	<div id="sketchy_bg"></div>

		<div id="wrap">
			<div id="header" class="clearfix">
				<div id="title">
					New to SCV : <A href="sketch_recent.jsp">Recent Sketches</A>
				</div>
				<%
					if (session.getAttribute("userId") == null) {
				%>

				<UL id="toolbar" class="clearfix">
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
					<LI><A href="../meber/mypage.jsp">mypage</A></LI>
					<LI><A href="sketch_mypage.jsp">sketch my page</A></LI>
					<LI><A href="sketch_creative.jsp">go to sketch page</A></LI>
					<LI id="friendListButton">Friend List</LI>
				</UL>
				<%
					}
				%>
			</div>


			<div id="container">
				<canvas id="drawCanvas" width="800" height="560"
					style="position: relative; border: 1px solid #000;"></canvas>
				<form action="sketch_save.jsp" method="post" id="sketchForm">
					<input type="hidden" name="sketchUrl" id="hiddenUrl"> <input
						type="button" value="저장" onclick="toDataURL();"> <img
						id="myImage">
				</form>
			</div>
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
									if (useridB.equals(userid)) {
				%>
				<h2>
					<a href="../meber/friend_confirm.jsp?useridA=<%=useridA%>"><%=useridA%>
						wants to be your friend</a>
				</h2>
				<%
					}
								} else if (confirm.equals("true")) {
									if (useridB.equals(userid)) {
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
		</div>
		
</body>
</html>