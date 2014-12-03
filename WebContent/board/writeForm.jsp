<%@page import="java.sql.*"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
	String dbUrl = "jdbc:mysql://localhost:3309/bong4";
	String dbUser = "root";
	String dbPassword = "qwe123";

	//sketch 정보를 위한 변수 초기화
	String userid = (String) session.getAttribute("userid");
	
	//게시글 정보 변수 초기화
	int num=0, ref=1, re_step =0, re_level=0;
	String strV="";
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
		
		sketchUrl.value = canvas.toDataURL();

		$('#sketchForm').submit();

		// 이걸 누구한테 요청함?
		//save에 sketchUrl에있는 jsp 변수용!
	}
	
</script>


<title>게시글 작성</title>
</head>

<body id="home">
	<div id="sketchy_bg"></div>

			<div id="header" class="clearfix">
				<div id="title">
					최근: <A href="recent_board.jsp">게시글 보기</A>
				</div>
				<%
					if (session.getAttribute("userid") == null) {
				%>

				<UL id="toolbar" class="clearfix">
					<LI><A href="../users/signup.jsp">가입하기</A></LI>
					<LI><A href="../users/signin.jsp">로그 인</A></LI>
				</UL>

				<%
					} else {
				%>
				<UL id="toolbar" class="clearfix">
					<LI><%=session.getAttribute("userid")%></LI>
					<LI><A href="../index.jsp">home</A></LI>
					<LI><A href="../users/signout.jsp">로그 아웃</A></LI>
					<LI><A href="../users/mypage.jsp">내 정보</A></LI>					
				</UL>
				<%
					}
				%>
			</div>	
			<div id="board">
			<form action="writePro.jsp" method ="post" id="boardForm">
			<input type="hidden" name="num" value="<%=num%>">
			<input type="hidden" name="ref" value="<%=ref%>">
			<input type="hidden" name="re_step" value="<%=re_step%>">
			<input type="hidden" name="re_level" value="<%=re_level%>">			
			</form></div>
			
			<form action="../sketch/save_sketch.jsp" method="post" id="sketchForm">
			<table>
			<tr>
			<td width="70" align="center">제목</td>
			<td width="330" align="left">
			<%
				if(request.getParameter("num")==null)
					strV="";
			%>	
			<input type="text" size="20" maxlength="30" name="subject" ></td>
			</tr>
			<tr>
			<td width="70" align="center">내용</td>
			<td width="330" align="left">
			<textarea name ="content" rows="13" cols ="40"></textarea></td>				
			</tr>
			</table>
		
			
			<p>약도 그리기</p>
		<!--	<div id="container"> -->
			<canvas id="drawCanvas" width="400" height="300"
					style="position:relative; border: 1px solid #000;"></canvas>
				<%// <form action="./sketch/save_sketch.jsp" method="post" id="sketchForm">%>
					<input type="hidden" name="sketchUrl" id="hiddenUrl"> <input
						type="button" value="저장" onclick="toDataURL();"> <img
						id="myImage">
						<div>
				</div></form>
		<!--</div>  -->	 
</body>
</html>