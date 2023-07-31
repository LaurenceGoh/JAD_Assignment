<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Select User Page</title>
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

	// Get user attribute
	String userID = "", userName = "", userPassword = "", birthday = "", email = "", address = "", userRole = "", sqlResults = "";
	String messages = request.getParameter("code");
		
	try {
		// SQL to select all user
		Class.forName("com.mysql.jdbc.Driver");
		String connURL = "jdbc:mysql://localhost/jad_bookstore_db?user=root&password=123456&serverTimezone=UTC";
		Connection conn = DriverManager.getConnection(connURL);
	    Statement stmt = conn.createStatement();
		String sqlStr = "SELECT * FROM jad_bookstore_db.user";
	    ResultSet rs = stmt.executeQuery(sqlStr);
	    
		while (rs.next()){
			userID = rs.getString("iduser");
			userName = rs.getString("name");
			userPassword = rs.getString("password");
			birthday = rs.getString("birthday");
			email = rs.getString("email");
			address = rs.getString("address");
			userRole = rs.getString("role");

			sqlResults += "<div class='col'><div class='card shadow-sm'>"
					+ "<img src=\"../img/blankprofile.png" + "\" alt=\"Book cover\" height=\"100%\" width=\"100%\">"
					+ "<div class='card-body'>" + "<h4>" + userName + "</h4>" + "<p>Password: " + userPassword
					+ "</p>" + "<p>Email: " + email + "</p>" + "<p>Birthday: " + birthday + "</p>" + "<p>Home Address: " + address 
					+ "<p>Role: " + userRole + "</p>"
					+ "<div class='d-flex justify-content-between align-items-center'>"
					+ "<div class='btn-group'>";
					
			if (messages.equals("edit")) {
				sqlResults += "<form action=\"editUser.jsp\" method = \"post\">"
						+ "<button type='submit' class='btn btn-sm btn-outline-secondary' name='userId' value='" + userID + "'>Edit</button>" + " </form></div>";
			}
				
			else if (messages.equals("delete")) {
				sqlResults += "<form action=\"deleteUser.jsp\" method = \"post\">"
						+ "<button type='submit' class='btn btn-sm btn-outline-secondary' name='userId' value='" + userID + "'>Delete</button>" + " </form></div>";
			}
					
			sqlResults += " </div>"
					+ "</div>" + "</div></div>";
		}
		
	if (session.getAttribute("Name") != null && session.getAttribute("Role") != null && session.getAttribute("loginStatus") != null) {
		name = session.getAttribute("Name").toString();
		role = session.getAttribute("Role").toString();
		loginStatus = session.getAttribute("loginStatus").toString();
	}
	
	if (!role.equals("administrator") && !role.equals("owner")) {
		response.sendRedirect("login.jsp");
	}
	
	if (loginStatus.equals("true")) {
		navString = name;
	} 
	
	} catch(Exception e){
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
<section class="py-5 text-center container">
    <div class="row py-lg-5">
      <div class="col-lg-6 col-md-8 mx-auto">
        <h1 class="fw-light">User Database</h1>
        <p class="lead text-body-secondary">List of users in the database.</p>
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
</html>