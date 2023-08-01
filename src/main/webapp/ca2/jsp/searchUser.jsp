<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Search User Page</title>
<!-- Bootstrap link -->
<link rel="canonical"
	href="https://getbootstrap.com/docs/5.3/examples/sign-in/">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ"
	crossorigin="anonymous">
<style>

<%@ include file="/ca2/css/searchUser.css"%>

</style>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"></script>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
<%@page import="java.sql.*"%>
</head>
<body>
	<%
	// If user has already logged in, 
	String loginStatus = "false";
	String name = "public";
	String role = "public";
	
	if (session.getAttribute("Name") != null && session.getAttribute("Role") != null && session.getAttribute("loginStatus") != null) {
		name = session.getAttribute("Name").toString();
		role = session.getAttribute("Role").toString();
		loginStatus = session.getAttribute("loginStatus").toString();
	}
	
	String navString = "";
	
	if (loginStatus.equals("true")) {
		navString = name;
	} 
	
	else {
		navString = "Public User";
	}
	
	// Set attribute for function
		session.setAttribute("userFunction", "search");
	%>
	
	<!-- Navbar -->
	<nav class="navbar navbar-expand bg-black">
		<div class="container-fluid">
			<a class="navbar-brand text-white" href=""><%=navString%></a>
			<%
				if (role.equals("administrator") || role.equals("owner")) {
					out.print("<a class=\"navbar-brand text-white\" href=\"admin.jsp\">Admin</a>");
				}
			
				else if (role.equals("member")) {
					out.print("<a class=\"navbar-brand text-white\" href=\"editUser.jsp\">Account</a>");
				}
			%>
			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarsExample02"
				aria-controls="navbarsExample02" aria-expanded="false"
				aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse">
				<ul class="navbar-nav ms-auto me-5 d-flex justify-content-end">
					<li class="nav-item">
						<h4>
							<a class="nav-link active text-white" aria-current="page"
								href="index.jsp">Home</a>
						</h4>
					</li>
					<li class="nav-item">
						<h4>
						<%
							if (loginStatus.equals("true")){
								out.print("<a class=\"nav-link text-white\" href=\"login.jsp\">Logout</a>");
							}
						
							else if (loginStatus.equals("false")) {
								out.print("<a class=\"nav-link text-white\" href=\"login.jsp\">Login</a>");
							}
						%>
						</h4>
					</li>
				</ul>
			</div>
		</div>
	</nav>
	
	<!-- Search menu -->
	<div class="container ">
		<div
			class="row height d-flex justify-content-center align-items-center">
			<div class="col-md-8 searchContainer">
				<h2>Welcome to Admin User Search!</h2>
				<div class="search">
					<i class="bi bi-search"></i>
					<form action="<%=request.getContextPath()%>/UserDB" method="post">
						<input type="text" class="form-control"
							placeholder="Search for a user here!" name="userSearch">
						<input type="submit" name="btnSearch" value="Search" class="search button">
						<div class="form-check form-check-inline mt-2">
						  <input class="form-check-input" type="radio" name="radio" id="inlineRadio1" value="author" required>
						  <label class="form-check-label" for="inlineRadio1">Search by Name</label>
						</div>
						<div class="form-check form-check-inline mt-2">
						  <input class="form-check-input" type="radio" name="radio" id="inlineRadio2" value="title">
						  <label class="form-check-label" for="inlineRadio2">Search by Address</label>
						</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe"
	crossorigin="anonymous"></script>
</html>