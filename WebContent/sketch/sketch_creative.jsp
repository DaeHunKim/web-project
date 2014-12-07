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
	 function clearAllCanvas(){
	      var jobCanvas   = document.getElementById("drawCanvas");
	      var thisCanvas  = document.getElementById("drawCanvas");
	      jobCanvas.setAttribute("width", "150px");
	      jobCanvas.setAttribute("height","150px");
	      jobCanvas.setAttribute("width", "400px");
	      jobCanvas.setAttribute("height","300px");
	 }
	
	
	function toDataURL() {
		var sketchUrl = $('#hiddenUrl')[0];
	
		sketchUrl.value = canvas.toDataURL();

		$('#sketchForm').submit();

	}
</script>


<title>bong4</title>
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
					<LI><A href="index.jsp">홈</A></LI>
					<LI><A href="../member/signup.jsp">회원 가입</A></LI>
					<LI><A href="../member/signin.jsp">로그 인</A></LI>
				</UL>

				<%
					} else {
				%>
				<UL id="toolbar" class="clearfix">
					<LI><%=session.getAttribute("userName")%></LI>
					<LI><A href="../index.jsp">홈</A></LI>
					<LI><A href="../member/signout.jsp">로그 아웃</A></LI>
					<LI><A href="../member/mypage.jsp">내 정보</A></LI>
					<LI><A href="sketch_mypage.jsp">내가 쓴 게시글</A></LI>
					<LI><A href="sketch_creative.jsp">게시글 쓰기</A></LI>
					<LI><A href="sketch_list.jsp">게시글 목록</A></LI>
				</UL>
				<%
					}
				%>
			</div>
			
			<form action="sketch_save.jsp" method="post" id="sketchForm">
			<table>
			<tr>
			<td width="70" align="center">제목</td>
			<td width="330" align="left">
			<input type="text" size="20" maxlength="30" name="subject" ></td>
			</tr>
			<tr>
			<td width="70" align="center">내용</td>
			<td width="330" align="left">
			<textarea name ="content" rows="13" cols ="40"></textarea></td>				
			</tr>
			</table>
				<canvas id="drawCanvas" width="400" height="300"
					style="position: relative; border: 1px solid #000;"></canvas>
					<input type="button" onclick="clearAllCanvas()" value="지우기">
					<input type="hidden" name="sketchUrl" id="hiddenUrl"> <input
						type="submit" value="저장" onclick="toDataURL();"> <img
						id="myImage">
				</form>
		
		</div>
		<div id="footer">함께 하는 봉사</div>
	</div>
</body>
</html>