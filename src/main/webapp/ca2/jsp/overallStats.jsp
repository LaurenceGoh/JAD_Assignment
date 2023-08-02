<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Overall Statistics Page</title>
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
</head>
<body>
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

<%
	String bookID = "", title = "";
	int quantity = 0, unitSold = 0;
	double price = 0.0;
	String tableCode = "";

	try {
		Class.forName("com.mysql.jdbc.Driver");
		String connURL = "jdbc:mysql://localhost/jad_bookstore_db?user=root&password=NZRong456&serverTimezone=UTC";
		Connection conn = DriverManager.getConnection(connURL);
	 	Statement stmt = conn.createStatement();
		String sqlStr = "SELECT * FROM jad_bookstore_db.books ORDER BY unitsSold DESC";
	    ResultSet rs = stmt.executeQuery(sqlStr);

		while (rs.next()){
			bookID = rs.getString("idbooks");
			title = rs.getString("title");
			quantity = rs.getInt("quantity");
			price = rs.getDouble("price");
			unitSold = rs.getInt("unitsSold");
			
			tableCode += "<tr><td>" + bookID + "</td>"
					+ "<td>" + title + "</td>"
					+ "<td>" + price + "</td>"
					+ "<td>" + quantity + "</td>"
					+ "<td>" + unitSold + "</td></tr>";
		}
		conn.close(); 
	}
	
	catch (Exception e) {
		out.println(e);
	}
%>

<section class="py-5 text-center container">
    <div class="row py-lg-5">
      <div class="col-lg-6 col-md-8 mx-auto">
        <h1 class="fw-light">Overall Statistics</h1>
        <p class="lead text-body-secondary">View book sales.</p>
        <p class="lead text-body-secondary">View out of stock books.</p>
      </div>
	</div>
</section>

<section class="py-5 text-center container">
    <div class="row py-lg-5">
      <div class="col-lg-6 col-md-8 mx-auto">
        <h3 class="fw-light">Book sales list</h3>
        <table style="border-style: solid">
        	<tr>
        		<td><b>Book ID</b></td>
        		<td><b>Title</b></td>
        		<td><b>Price</b></td>
        		<td><b>Quantity</b></td>
        		<td><b>Unit Sold</b></td>
        	</tr>
        	<%=tableCode %>
        </table>
      </div>
	</div>
</section>

<%
	String bookID2 = "", title2 = "";
	int quantity2 = 0;
	String tableCode2 = "";
	
	try {
		Class.forName("com.mysql.jdbc.Driver");
		String connURL = "jdbc:mysql://localhost/jad_bookstore_db?user=root&password=NZRong456&serverTimezone=UTC";
		Connection conn2 = DriverManager.getConnection(connURL);
	 	Statement stmt2 = conn2.createStatement();
		String sqlStr2 = "SELECT * FROM jad_bookstore_db.books WHERE quantity = 0";
	    ResultSet rs2 = stmt2.executeQuery(sqlStr2);

		while (rs2.next()){
			bookID2 = rs2.getString("idbooks");
			title2 = rs2.getString("title");
			quantity2 = rs2.getInt("quantity");
			
			tableCode2 += "<tr><td>" + bookID2 + "</td>"
					+ "<td>" + title2 + "</td>"
					+ "<td>" + quantity2 + "</td></tr>";
		}
		conn2.close(); 
	}
	
	catch (Exception e) {
		out.println(e);
	}
%>

<section class="py-5 text-center container">
    <div class="row py-lg-5">
      <div class="col-lg-6 col-md-8 mx-auto">
        <h3 class="fw-light">Out of stocks books</h3>
        <table style="border-style: solid">
        	<tr>
        		<td><b>Book ID</b></td>
        		<td><b>Title</b></td>
        		<td><b>Quantity</b></td>
        	</tr>
        	<%= tableCode2 %>
        </table>
      </div>
	</div>
</section>

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