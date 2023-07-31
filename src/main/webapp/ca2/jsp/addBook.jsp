<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Add Book Page</title>
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
	<style>
	<%@ include file = "../css/editBook.css" %>
</style>
</head>
<body>
<%@page import="java.sql.*"%>
<%
	//If user has already logged in, 
	String loginStatus = "false";
	String name = "public";
	String role = "public";
	
	if (session.getAttribute("Name") != null && session.getAttribute("Role") != null && session.getAttribute("loginStatus") != null) {
		name = session.getAttribute("Name").toString();
		role = session.getAttribute("Role").toString();
		loginStatus = session.getAttribute("loginStatus").toString();
	}
	
	if (!role.equals("administrator") && !role.equals("owner")) {
		response.sendRedirect("login.jsp");
	}
	
	// Set attribute for function
	session.setAttribute("bookFunction", "add");
	
	String message = request.getParameter("code");
	if (message != null && message.equals("insertError")) {
		out.print("Error.. <br><h2>Please try again!</h2>");
	}
	
	else if (message != null && message.equals("insertSuccess")) {
			out.print("<br><h2>Book successfully added!</h2>");
	}
	
	
	String navString = "";
		
	if (loginStatus.equals("true")) {
		navString = name;
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
<div class="content mx-auto">
<main>
<div class="row d-flex justify-content-center mt-5">
      <div class="col-md-7 col-lg-8">
        <h4 class="mb-3">New Book Details</h4>
        	<!-- change to getcontextpath  --> 
        <form class="needs-validation" novalidate="" action="<%=request.getContextPath()%>/BookDB" method="POST">
          <div class="row g-3">
            <div class="col-sm-6">
              <label for="firstName" class="form-label">Title</label>
              <input type="text" class="form-control" name="title" placeholder="eg. Demon Slayer" required>
              <div class="invalid-feedback">
                Valid title is required.
              </div>
            </div>

            <div class="col-sm-6">
              <label for="lastName" class="form-label">Author</label>
              <input type="text" class="form-control" name="author" placeholder="eg. Veronica Roth" required>
              <div class="invalid-feedback">
                Valid last name is required.
              </div>
            </div>
            
            <div class="col-sm-6">
              <label for="lastName" class="form-label">Rating</label>
              <input type="text" class="form-control" name="rating" placeholder="eg. 4.5" required>
              <div class="invalid-feedback">
                Valid last name is required.
              </div>
            </div>
            
            <div class="col-sm-6">
              <label for="lastName" class="form-label">Price</label>
              <input type="text" class="form-control" name="price" placeholder="eg. 12.99" required>
              <div class="invalid-feedback">
                Valid last name is required.
              </div>
            </div>

			<div class="col-sm-6">
              <label for="lastName" class="form-label">Category</label>
              <input type="text" class="form-control" name=category placeholder="eg. Fantasy" required>
              <div class="invalid-feedback">
                Valid category is required.
              </div>
            </div>
            
            <div class="col-sm-6">
              <label for="lastName" class="form-label">Release Date</label>
              <input type="text" class="form-control" name="releaseDate" placeholder="eg. YYYY-MM-DD" required>
              <div class="invalid-feedback">
                Valid release date is required.
              </div>
            </div>
	
            <div class="col-10">
              <label for="username" class="form-label">isbnStr Number</label>
              <div class="input-group has-validation">
                <input type="text" class="form-control" name="isbnStrNum" placeholder="rg. 0000000000000" required>
              <div class="invalid-feedback">
                  isbnStr is required.
                </div>
              </div>
            </div>

            <div class="col-2">
              <label for="number" class="form-label">Quantity</label>
              <input type="number" class="form-control" name="quantity" placeholder="0" required>
              <div class="invalid-feedback">
                Please enter a valid number.
              </div>
            </div>

            <div class="col-12">
              <label for="publisher" class="form-label">Publisher</label>
              <input type="text" class="form-control" name="publisher" placeholder="" required>
              <div class="invalid-feedback">
                Please enter a valid publisher.
              </div>
            </div>

            <div class="col-12">
              <div class="form-floating">
			  <textarea class="form-control" placeholder="This book is about..." name="description"  style="height: 400px"></textarea>
			  <label for="floatingTextarea2">Description</label>
			</div>
            </div>
		</div>
          <hr class="my-4">

		  <div class="container">
		   <div class="row">
		  	<div class="col">
		  		<input class="btn btn-success btn-block form-control" type="submit" name="save" value="Add book">
		  	</div>
		  	<div class="col">
		  	 	<input class="btn btn-primary btn-block form-control" type="submit" name="cancel" value="Return to admin page">
		  	</div>
		  </div>
          </div>         
        </form>
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