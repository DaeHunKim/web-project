<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*" import="java.sql.*"%>
<% 
Connection conn = null;
Statement stmt = null;
ResultSet rs = null;

//db 접속
String dbUrl = "jdbc:mysql://localhost:3306/wb_bong4";
String dbUser = "root";
String dbPassword = "tiger";

int pageNo = 1;

try {
	pageNo = Integer.parseInt(request.getParameter("page"));
} catch (NumberFormatException ex) {}

int numInPage=5;
int startPos = (pageNo -1) * numInPage;
int numItems, numPages;

%>   

<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="utf-8">
    <title>bong4</title>
    <!-- Bootstrap core CSS -->
		<link href="../stylesheets/bootstrap.min.css" rel="stylesheet">
    <link href="../stylesheets/main.css" rel="stylesheet">
    <!-- JQuery -->
    <script src="../js/jquery-1.11.1.min.js"></script>
		<script src="../js.bootstrap.min.js"></script>
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="../../favicon.ico">
    <script src="../../assets/js/ie-emulation-modes-warning.js"></script>

  </head>  
<% 
		try {
		Class.forName("com.mysql.jdbc.Driver");
		
		conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
		
		stmt = conn.createStatement();
		
		// 게시글 수 폐이지 수 계산
		rs = stmt.executeQuery("select count(*) from sketch");
		rs.next();
		numItems = rs.getInt(1);
		numPages = (int) Math.ceil((double)numItems / (double)numInPage);
		rs.close();
		stmt.close();
		
		stmt = conn.createStatement();
		rs = stmt.executeQuery("select * from sketch ORDER BY id LIMIT " + startPos + ", " + numInPage);		
		
   
%>
   
  <body>
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
					<LI><A href="../member/mypage.jsp">내정보</A></LI>
					<LI><A href="./sketch_mypage.jsp">내게시글</A></LI>
					<LI><A href="./sketch_creative.jsp">게시글 작성</A></LI>
					<LI><A href=#>게시글 목록</A></LI>
				</UL>
				<%
					}
				%>
			</div>
  
    <div class="container">
      <div class="page-header">
        <h1>모집게시글</h1>
      </div>
      <div class="row">
			<div class="span12 page-info">
				<div class="pull-left">
					Total <b><%=numItems %></b> writings
				</div>
				<div class="pull-right">
					<b><%=pageNo %></b> page / total <b><%=numPages %></b>pages
				</div>
			</div>
		</div>				
       			<table class="table table-bordered table-stripped">
            		<thead>
                <tr>
                  <th width=30px;>No</th>
                  <th>제목</th>
                  <th>작성자</th>
                  <th width=100px;>작성일</th>
                </tr>
                </thead>
                <tbody>
                <%
                
                	while(rs.next()){
                %>
                <tr>
                  <td><%=rs.getInt("id") %></td>
                  <td><a href="./sketch_item.jsp?userid=<%=rs.getString("userid") %>&id=<%=rs.getInt("id")%>"><%=rs.getString("subject")%></a></td>
                  <td><%=rs.getString("userid")%></td>
                  <td><%=rs.getString("created_at") %></td>
                </tr> 
                <%
                } 
                %>
								</tbody>
            	</table>
            
            <div class="form-action">
            	<a href="./sketch_creative.jsp" class="btn btn-primary">글쓰기</a>
            </div>
           
           <div class = "pagination pagination-centered">
            	<ul>
            		<%
            		int startPageNo, endPageNo;
            		int delta = 5;
            		startPageNo = (pageNo <= delta) ? 1: pageNo - delta;
            		endPageNo = startPageNo + (delta*2) +1;
            		
            		if (endPageNo > numPages) {
            			endPageNo = numPages;
            		}
            		//이전 페이지로
            		if (pageNo <= 1) {
            		%>
            			<li><a href="#"></a></li>
            		<% 
            		} else {
            		%>
            			<li><a href="sketch_list.jsp?page=<%= pageNo -1 %>"></a></li>
            		<%
            		}
            		
            		String className = "";
            		for(int i = startPageNo; i <= endPageNo; i++){
            			className = (i ==pageNo)?"active" : "";
            			out.println("<li class'" + className + "'>");
            			out.println("<a href='sketch_list.jsp?page=" + i + "'>" + i + "</a>");
            			out.println("</li>");
            		}
            		
            		//다음 페이지로
            		if (pageNo >= numPages) {
            		%>
            			<li><a href="#">&laquo;</a></li>
            		<% 
            		} else {
            		%>
            			<li><a href="sketch_list.jsp?page=<%= pageNo +1 %>">&laquo;</a></li>
            		<%
            		}
            		%>
            </ul>
           </div>
           <%
            } catch(SQLException e) {
            	out.print("<div class='alert'>" + e.getLocalizedMessage() + "</div>");
            }finally {
            	
            		if (rs != null) try{rs.close();} catch(SQLException e) {}
            		if (stmt != null) try{stmt.close();} catch(SQLException e) {}
            		if (conn != null) try{conn.close();} catch(SQLException e) {}
            		
            }
            %>
       </div>
       </div>
      
     <div id="footer"> 함께 하는 봉사 </div>  
    </div>
   
	</body>
</html>
