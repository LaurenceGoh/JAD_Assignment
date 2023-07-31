<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Add User Page</title>
<link rel="canonical"
	href="https://getbootstrap.com/docs/5.3/examples/sign-in/">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ"
	crossorigin="anonymous">
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"></script>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
</head>
<body>
	<%@page import="java.sql.*"%>
	<%
	//If user has already logged in, 
	String loginStatus = "false";
	String name = "public";
	String role = "public";
	String navString = "";
	String message = request.getParameter("code");
 
	try {
	if (session.getAttribute("Name") != null && session.getAttribute("Role") != null
			&& session.getAttribute("loginStatus") != null) {
		name = session.getAttribute("Name").toString();
		role = session.getAttribute("Role").toString();
		loginStatus = session.getAttribute("loginStatus").toString();
	}

	if (!role.equals("administrator") && !role.equals("owner")) {
		response.sendRedirect("login.jsp");
	}

	// Set attribute for function
	session.setAttribute("userFunction", "add");

			
	if (loginStatus.equals("true")) {
		navString = name;
	} 
	} catch (Exception e){
		System.out.println(e);
		response.sendRedirect("index.jsp");
	}
	%>
<!-- Navbar -->
	<nav class="navbar navbar-expand bg-black">
		<div class="container-fluid">
			<a class="navbar-brand text-white" href=""><%=navString%></a>
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
							<a class="nav-link text-white" href="login.jsp">Logout</a>		
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
						String messages = request.getParameter("code");
						if (message != null && message.equals("conflictPwd")) {
							out.print("Password does not match.. <br><h2>Please try again!</h2>");
						}

						else if (messages != null && message.equals("invalidDate")) {
							out.print("Date format does not match YYYY-MM-DD.. <br><h2>Please try again!</h2>");
						}

						else if (messages != null && message.equals("emailExist")) {
							out.print("Email already exist.. <br><h2>Please try again!</h2>");
						}

						else if (messages != null && message.equals("insertError")) {
							out.print("Error.. <br><h2>Please try again!</h2>");
						}

						else if (messages != null && message.equals("invalidRole")) {
							out.print("Role not found.. <br><h2>Please try again!</h2>");
						}

						else if (messages != null && message.equals("insertSuccess")) {
							out.print("<h2>Account created!</h2>");
						}
						%>
						<form class="w-50 mx-auto" action="<%=request.getContextPath()%>/UserDB" method="POST">
							<h1 class="h3 mb-3 fw-bold fs-1">Register</h1>
							<div class="form-floating my-4">
								<input type="text" class="form-control" id="floatingInput"
									placeholder="name" name="name"> <label
									for="floatingInput">Name</label>
							</div>
							<div class="form-floating my-4">
								<input type="email" class="form-control" id="floatingInput"
									placeholder="name@example.com" name="email"> <label
									for="floatingInput">Email address</label>
							</div>
							<div class="form-floating my-4">
								<input type="text" class="form-control" id="floatingInput"
									placeholder="YYYY-MM-DD" name="birthday"> <label
									for="floatingInput">Birthday (YYYY-MM-DD)</label>
							</div>
							<div class="form-floating my-4">
								<input type="text" class="form-control" id="floatingInput"
									placeholder="home address" name="address"> <label
									for="floatingInput">Home address</label>
							</div>
							<div class="form-floating my-4">
								<input type="password" class="form-control"
									id="floatingPassword" placeholder="Password" name="pwd">
								<label for="floatingPassword">Password</label>
							</div>
							<div class="form-floating my-4">
								<input type="password" class="form-control"
									id="floatingPassword" placeholder="Password" name="pwdConfirm">
								<label for="floatingPassword">Confirm password</label>
							</div>
							<div class="form-floating my-4">
								<input type="password" class="form-control"
									id="floatingPassword" placeholder="Admin / Member"
									name="role"> <label for="floatingPassword">Role</label>
							</div>

							<hr class="my-4">

							<div class="container">
								<div class="row">
									<div class="col">
										<input class="btn btn-success btn-block form-control"
											type="submit" name="save" value="Add user">
									</div>
									<div class="col">
										<input class="btn btn-primary btn-block form-control"
											type="submit" name="cancel" value="Return to admin page">
									</div>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</main>
	</div>

	<footer class="my-5 pt-5 text-body-secondary text-center text-small">
		<p class="mb-1">© 2017–2023 Company Name</p>
		<ul class="list-inline">
			<li class="list-inline-item"><a href="#">Privacy</a></li>
			<li class="list-inline-item"><a href="#">Terms</a></li>
			<li class="list-inline-item"><a href="#">Support</a></li>
		</ul>
	</footer>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe"
		crossorigin="anonymous"></script>
</body>
</html>