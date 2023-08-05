<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Search user List Page</title>
</head>
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
	
	else {
		navString = "Public User";
	}
	
	String names = "", email = "", birthday="", address = "", sqlStr = "", sqlResults = "";
	String toSearch = (String) request.getParameter("userSearch");
	String searchBy = (String) request.getParameter("radio");
	
	try {
		// SQL search user
		Class.forName("com.mysql.jdbc.Driver");
		String connURL = "jdbc:mysql://localhost/jad_bookstore_db?user=root&password=NZRong456&serverTimezone=UTC";
		Connection conn = DriverManager.getConnection(connURL);
		
		if (searchBy.equals("name")) {
			sqlStr = "SELECT * FROM jad_bookstore_db.user WHERE name LIKE \"%" + toSearch + "%\"";
			//sqlStr = "SELECT * FROM jad_bookstore_db.user WHERE name LIKE = ?";
		}
		
		else if (searchBy.equals("address")) {
			sqlStr = "SELECT * FROM jad_bookstore_db.user WHERE address LIKE \"%" + toSearch + "%\"";
			//sqlStr = "SELECT * FROM jad_bookstore_db.user WHERE address LIKE %=?%";
		}
		
		Statement stmt = conn.createStatement();
		ResultSet rs = stmt.executeQuery(sqlStr);
		
		while (rs.next()) {
			names = rs.getString("name");
			email = rs.getString("email");
			birthday = rs.getString("birthday");
			address = rs.getString("address");
			
			sqlResults += "<div class='col'><div class='card shadow-sm'>"
					+ "<img src=\"../img/blankprofile.png\" alt=\"User cover\" height=\"100%\" width=\"100%\">"
					+ "<div class='card-body'>" + "<h4>" + names + "</h4>" + "<p class='card-text'>" + email
					+ "</p> <p class='card-text'>" + address + "</p>" + "<div class='d-flex justify-content-between align-items-center'>"
					+ "<small class='text-body-secondary'>Birthday: " + birthday + "</small></div>"
					+ "</div>" + "</div></div>";
		}
	}
	
	catch (Exception e) {
		response.sendRedirect("ca2/jsp/admin.jsp?code=userSearchError");
		System.out.println("Error :" + e);
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
        <h1 class="fw-light">User Database</h1>
        <p class="lead text-body-secondary">List of available users in the database according to your search.</p>
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
</body>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe"
	crossorigin="anonymous"></script>
</html>