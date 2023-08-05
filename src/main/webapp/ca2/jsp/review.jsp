<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
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
<title>Review Payment</title>
</head>
<body><%
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
	
	<div class="container justify-content-center d-flex">
		<div>
		<h1>Payment Details</h1>
		<h2>Please confirm your details before paying.</h2>
		
		<form action="<%=request.getContextPath()%>/ExecutePayment" method="POST">
		<input type="hidden" name="username" value="<%=name%>" />
		<div class="flex-fill">
			<div class="col">
	        <h4 class="d-flex justify-content-between align-items-center mb-3">
	          <span class="text-primary">Your cart</span>
	          <span class="badge bg-primary rounded-pill">1</span>
	        </h4>
	        
	        <input type="hidden" name="paymentId" value = "${param.paymentId}">
	        <input type="hidden" name="PayerID" value = "${param.PayerID}">
	        
	        <!-- start of array book to fill in -->
	        <ul class="list-group mb-3">
	       		<li><b>Description</b></li>
	        	 <li class="list-group-item d-flex justify-content-between">
	            <span>Sub Total (SGD)</span>
	            <strong >$ ${transaction.amount.details.subtotal}</strong>
	          </li>
	          <li class="list-group-item d-flex justify-content-between">
	            <span>Shipping (SGD)</span>
	            <strong>$ ${transaction.amount.details.shipping}</strong>
	          </li>
	           <li class="list-group-item d-flex justify-content-between">
	            <span>Tax (SGD)</span>
	            <strong >$ ${transaction.amount.details.tax}</strong>
	          </li>
	          <li class="list-group-item d-flex justify-content-between">
	            <span>Total (SGD)</span>
	            <strong >$ ${transaction.amount.total}</strong>
	          </li>
	        </ul>
				<ul>
				<li><b>Payer Information</b></li>
					<li class="list-group-item d-flex justify-content-between">
		            <span>First name:</span>
		            <strong>${payer.firstName}</strong>
		          </li>
		          <li class="list-group-item d-flex justify-content-between">
		            <span>Last name:</span>
		            <strong >${payer.lastName}</strong>
		          </li>
		          <li class="list-group-item d-flex justify-content-between">
		            <span>Email:</span>
		            <strong >${payer.email}</strong>
		          </li>
		           
				</ul>
	      </div>
	      <div class="btn-toolbar justify-content-center">
				<input class = "w-45 btn btn-primary btn-lg me-2" type="submit" name="submit" value="Make payment">
			</div>
		
		</div>
		
		</form>
		</div>
		
	</div>
	
	<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe"
	crossorigin="anonymous"></script>
</body>
</html>