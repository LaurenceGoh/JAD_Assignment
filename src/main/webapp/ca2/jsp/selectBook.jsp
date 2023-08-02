<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Select Book List Page</title>
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
	// Get book attribute
	String bookID = "", title = "", category = "", image = "", author = "", releaseDate = "", publisher = "", description = "", isbnStr = "",
	sqlResults = "";
	
	String messages = request.getParameter("code");
	
	// Step 1
	Class.forName("com.mysql.jdbc.Driver");
	
	// Step 2: Define Connection URL (change password)
	String connURL = "jdbc:mysql://localhost/jad_bookstore_db?user=root&password=NZRong456&serverTimezone=UTC";
	
	// Step 3: Establish connection to URL
	Connection conn = DriverManager.getConnection(connURL);
    Statement stmt = conn.createStatement();

	String sqlStr = "SELECT * FROM jad_bookstore_db.books";
	
    ResultSet rs = stmt.executeQuery(sqlStr);

	while (rs.next()){
		bookID = rs.getString("idbooks");
		title = rs.getString("title");
		category = rs.getString("category");
		image = rs.getString("image");
		author = rs.getString("author");
		releaseDate = rs.getString("releaseDate");
		isbnStr = rs.getString("isbnNumber");
		publisher = rs.getString("publisher");
		description = rs.getString("description");

		sqlResults += "<div class='col'><div class='card shadow-sm'>"
				+ "<img src=\"../img/" + image + "\" alt=\"Book cover\" height=\"100%\" width=\"100%\">"
				+ "<div class='card-body'>" + "<h4>" + title + "</h4>" + "<p class='card-text'>" + description
				+ "</p>" + "<div class='d-flex justify-content-between align-items-center'>"
				+ "<div class='btn-group'>";
				
		if (messages.equals("edit")) {
			sqlResults += "<form action=\"editBook.jsp\" method = \"post\">"
					+ "<button type='submit' class='btn btn-sm btn-outline-secondary' name='bookId' value='" + bookID + "'>Edit</button>" + " </form></div>";
		}
			
		else if (messages.equals("delete")) {
			sqlResults += "<form action=\"deleteBook.jsp\" method = \"post\">"
					+ "<button type='submit' class='btn btn-sm btn-outline-secondary' name='bookId' value='" + bookID + "'>Delete</button>" + " </form></div>";
		}
				
		sqlResults += "<small class='text-body-secondary'>Author: " + author + "</small>"
				+ "<small class='text-body-secondary'>Release Date: " + releaseDate + "</small>" + " </div>"
				+ "</div>" + "</div></div>";
	}
	conn.close(); 
%>


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

	<section class="py-5 text-center container">
    <div class="row py-lg-5">
      <div class="col-lg-6 col-md-8 mx-auto">
        <h1 class="fw-light">Books Database</h1>
        <p class="lead text-body-secondary">List of available books in the database.</p>
      </div>
    </div>
  </section>

<div class="album py-5 bg-body-tertiary">
		<div class="container">
			<!-- Start of each card content -->
			<div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-3">
				<%=sqlResults%>
			</div>
		</div>
	</div>

<div class="container my-3 bg-light">
        <div class="col-md-12 text-center">
            <form action="admin.jsp" method="POST">
            	<button type="submit" class="btn btn-primary">Return to Admin menu</button>
        	</form>
        </div>
    </div>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe"
	crossorigin="anonymous"></script>
</html>