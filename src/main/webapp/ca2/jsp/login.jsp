<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login Page</title>

<style><%@ include file="/ca2/css/login.css" %></style>
</head>
<!-- CSS Style -->
<!-- Bootstrap link -->
<link rel="canonical" href="https://getbootstrap.com/docs/5.3/examples/sign-in/">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
<body class="text-center background">


	<!-- Navbar -->
	<nav class="navbar navbar-expand bg-black">
		<div class="container-fluid">
			<a class="navbar-brand text-white" href="">Public User</a>
			
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
							<a class="nav-link text-white" href="login.jsp">Login</a>
						</h4>
					</li>
				</ul>
			</div>
		</div>
	</nav>

   <%
   	// Remove account data
   	session.setAttribute("Name", "public");
	session.setAttribute("Role", "public");
	session.setAttribute("loginStatus", "false");
	session.setAttribute("book",null);
   %>
  <div class="d-flex flex-column min-vh-100">
<main class="form-signin w-50 py-5 m-auto userInput ">
	<div class="container">
		<div class="row">
				<div class="card-body">
				<%
					String message = request.getParameter("errCode");
					if (message != null && message.equals("invalidLogin")) {
						out.print("Sorry, error in login.. <br><h2>Please try again!</h2>");
					}
				%>
				  <form class="w-50 mx-auto" action="<%=request.getContextPath()%>/VerifyUser" method="POST">			   
				    <h1 class="h3 mb-3 fw-bold fs-1">Login</h1>				
				    <div class="form-floating my-4">
				      <input type="email" class="form-control" id="floatingInput" placeholder="name@example.com" name="email">
				      <label for="floatingInput">Email address</label>
				    </div>
				    <div class="form-floating my-4">
				      <input type="password" class="form-control" id="floatingPassword" placeholder="Password" name="pwd">
				      <label for="floatingPassword">Password</label>
				    </div>

				    <button class="w-100 btn btn-lg btn-primary" type="submit">Log in</button>
				  </form>
				  <form class="w-50 mx-auto" action="register.jsp" method="POST" style="padding-top: 20px">
				  	<button class="w-100 btn btn-lg btn-primary" type="submit">Register new user</button>
				  </form>
			  </div>
		  </div>
  </div>
</main>
</div>

</body>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" crossorigin="anonymous"></script>
</html>