<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register membership</title>
<!-- Bootstrap link -->
<link rel="canonical"
	href="https://getbootstrap.com/docs/5.3/examples/sign-in/">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ"
	crossorigin="anonymous">
<style>
<%@ include file="/ca2/css/register.css"%>
</style>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"></script>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
<%@page import="java.sql.*"%>
</head>
<body class="text-center background">
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

  <div class="d-flex flex-column min-vh-100">
<main class="form-signin w-50 py-5 m-auto userInput ">
	<div class="container">
		<div class="row">
				<div class="card-body">
				<%
				
				// Message from code
					String message = request.getParameter("code");
					if (message != null && message.equals("conflictPwd")) {
						out.print("Password does not match.. <br><h2>Please try again!</h2>");
					}
					
					else if (message != null && message.equals("invalidDate")) {
						out.print("Date format does not match YYYY-MM-DD.. <br><h2>Please try again!</h2>");
					}
					
					else if (message != null && message.equals("emailExist")) {
						out.print("Email already exist.. <br><h2>Please try again!</h2>");
					}
					
					else if (message != null && message.equals("insertError")) {
						out.print("Error.. <br><h2>Please try again!</h2>");
					}
					
					else if (message != null && message.equals("insertSuccess")) {
						out.print("<h2>Account created!</h2>");
					}
				%>
				  <form class="w-50 mx-auto" action="<%=request.getContextPath()%>/RegisterUser" method="POST">			   
				    <h1 class="h3 mb-3 fw-bold fs-1">Register</h1>		
				    <div class="form-floating my-4">
				      <input type="text" class="form-control" id="floatingInput" placeholder="name" name="name">
				      <label for="floatingInput">Name</label>
				    </div>		
				    <div class="form-floating my-4">
				      <input type="email" class="form-control" id="floatingInput" placeholder="name@example.com" name="email">
				      <label for="floatingInput">Email address</label>
				    </div>
				    <div class="form-floating my-4">
				      <input type="text" class="form-control" id="floatingInput" placeholder="YYYY-MM-DD" name="birthday">
				      <label for="floatingInput">Birthday (YYYY-MM-DD)</label>
				    </div>
				    <div class="form-floating my-4">
				      <input type="text" class="form-control" id="floatingInput" placeholder="home address" name="address">
				      <label for="floatingInput">Home address</label>
				    </div>
				    <div class="form-floating my-4">
				      <input type="password" class="form-control" id="floatingPassword" placeholder="Password" name="pwd">
				      <label for="floatingPassword">Password</label>
				    </div>
				    <div class="form-floating my-4">
				      <input type="password" class="form-control" id="floatingPassword" placeholder="Password" name="pwdConfirm">
				      <label for="floatingPassword">Confirm password</label>
				    </div>

				    <button class="w-100 btn btn-lg btn-primary" type="submit">Register</button>
				  </form>
				  
				  <%
				  	if (message != null && message.equals("insertSuccess")) {
				  		out.print("<form class=\"w-50 mx-auto\" action=\"login.jsp\" method=\"POST\" style=\"padding-top: 20px\">" 
				  		+ "<button class=\"w-100 btn btn-lg btn-primary\" type=\"submit\">Login</button>"
				  		+ "</form>");
				  	}
				  %>
			  </div>
		  </div>
  </div>
</main>
</div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" crossorigin="anonymous"></script>
</body>

</html>