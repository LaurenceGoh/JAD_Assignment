<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Book Detail Page</title>
<!-- Bootstrap link -->
<link rel="canonical"
	href="https://getbootstrap.com/docs/5.3/examples/sign-in/">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ"
	crossorigin="anonymous">
<style>

<%@ include file="/ca2/css/searchResult.css"%>

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
	
<%
String bookID = "", title = "", category = "", image = "", author = "", releaseDate = "", publisher = "", description = "", isbnStr = "",
results = "", rating = "";
int quantity = 0;
double price = 0.0;

	try {
		String bookStr = request.getParameter("bookId");
	
	// Step 1: Load JDBC Driver
		Class.forName("com.mysql.jdbc.Driver");

		// Step 2: Define Connection URL
		String connURL = "jdbc:mysql://localhost/jad_bookstore_db?user=root&password=NZRong456&serverTimezone=UTC";

		// Step 3: Establish connection to URL
		Connection conn = DriverManager.getConnection(connURL);

		// Step 5: Execute SQL Command
		String sqlStr = "SELECT * FROM jad_bookstore_db.books WHERE idbooks = ?";
		PreparedStatement pstmt = conn.prepareStatement(sqlStr);
		pstmt.setString(1,bookStr);

		ResultSet rs = pstmt.executeQuery();

		if (rs.next()) {
			bookID = rs.getString("idbooks");
			title = rs.getString("title");
			category = rs.getString("category");
			image = rs.getString("image");
			author = rs.getString("author");
			releaseDate = rs.getString("releaseDate");
			isbnStr = rs.getString("isbnNumber");
			publisher = rs.getString("publisher");
			description = rs.getString("description");
			quantity = rs.getInt("quantity");
			price = rs.getDouble("price");
			rating = rs.getString("rating");
		}

		else {
			// do nothing
			System.out.println("Record not found!");
		}

		conn.close();
		session.setAttribute("bookId",bookStr);
	} catch (Exception e){
		out.println(e);
	}
%>

<!-- Main HTML code -->

<div class="container col-xxl-8 px-4 py-5">
    <div class="row flex-lg-row-reverse align-items-center g-5 py-5">
      <div class="col-10 col-sm-8 col-lg-6">
        <img src="../img/<%=image %>" class="d-block mx-lg-auto img-fluid" alt="Bootstrap Themes" width="700" height="500" loading="lazy">
      </div>
      <div class="col-lg-6">
        <h1 class="display-5 fw-bold lh-1 mb-3"><%= title %></h1>
        <p class="h4">Author: <%=author %> </p>
        <p class="lead"><%= description %></p>
		<p>Book Category: <%= category %></p>
        <p>Publisher: <%= publisher %></p>
        <p>Release Date: <%= releaseDate %></p>
        <p>ISBN Number: <%= isbnStr %></p>
        <p>Rating: <%= rating %>/5 Stars</p>
        <p>Price: $<%= price %></p>
        <div class="d-grid gap-2 d-md-flex justify-content-md-start">
        <form action="addCart.jsp" method="POST" >
        	 <%
        	if (quantity >= 1) {
        		out.print("<input type=\"submit\" class=\"btn btn-primary btn-lg px-4 me-md-2\" value=\"Add to cart\">");
        	}
        
        	else {
        		out.print("<input type=\"submit\" class=\"btn btn-primary btn-lg px-4 me-md-2\" value=\"Sold out\" disabled>");
        	}
        %>
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