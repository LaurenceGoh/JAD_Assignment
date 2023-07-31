<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Delete Book Page</title>
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
	String navString = "";	

	if (session.getAttribute("Name") != null && session.getAttribute("Role") != null && session.getAttribute("loginStatus") != null) {
		name = session.getAttribute("Name").toString();
		role = session.getAttribute("Role").toString();
		loginStatus = session.getAttribute("loginStatus").toString();
	}
	
	if (!role.equals("administrator") && !role.equals("owner")) {
		response.sendRedirect("login.jsp");
	}

	// Get book variable	
	String bookStr = request.getParameter("bookId");
	String bookID = "", title = "", category = "", image = "", author = "", releaseDate = "", publisher = "", description = "", isbnStr = "",
	results = "", rating = "";	
	double price = 0.0;
	int quantity = 0;
	
	// Set delete book function
	session.setAttribute("bookFunction", "delete");
	
	try {
	
	// Step 1: Load JDBC Driver
			Class.forName("com.mysql.jdbc.Driver");
	
			// Step 2: Define Connection URL
			String connURL = "jdbc:mysql://localhost/jad_bookstore_db?user=root&password=123456&serverTimezone=UTC";
	
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
				rating = rs.getString("rating");
				price = rs.getDouble("price");
			}
	
			else {
				// do nothing
				System.out.println("Record not found!");
			}
	
			conn.close();
			if (loginStatus.equals("true")) {
				navString = name;
			} 
			} catch (Exception e){
				out.println(e);
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
<div class="content mx-auto">
<main>
    <div class="py-5 text-center">
      <img class="d-block mx-auto mb-4" src="../img/<%= image %>" alt="" width="72" height="57">
      <h2><%= title %></h2>
      <p class="lead">Details about <%= title %></p>
    </div>
	
    <div class="row d-flex justify-content-center">
      
      <div class="col-md-7 col-lg-8">
        <form class="needs-validation" novalidate="" action="<%=request.getContextPath()%>/BookDB" method="POST">
          <div class="row g-3">
            <div class="col-sm-6">
              <label for="firstName" class="form-label">Title</label>
              <input type="text" class="form-control" name="title" placeholder="" value="<%= title %>" disabled>
              <div class="invalid-feedback">
                Valid title is required.
              </div>
            </div>

            <div class="col-sm-6">
              <label for="lastName" class="form-label">Author</label>
              <input type="text" class="form-control" name="author" placeholder="" value="<%= author %>" disabled>
              <div class="invalid-feedback">
                Valid author is required.
              </div>
            </div>
            
            <div class="col-sm-6">
              <label for="lastName" class="form-label">Rating</label>
              <input type="text" class="form-control" name="rating" placeholder="" value="<%= rating %>" disabled>
              <div class="invalid-feedback">
                Valid rating is required.
              </div>
            </div>
            
            <div class="col-sm-6">
              <label for="lastName" class="form-label">Price</label>
              <input type="text" class="form-control" name="price" placeholder="" value="<%= price %>" disabled>
              <div class="invalid-feedback">
                Valid price is required.
              </div>
            </div>

			<div class="col-sm-6">
              <label for="lastName" class="form-label">Category</label>
              <input type="text" class="form-control" name=category placeholder="" value="<%= category %>" disabled>
              <div class="invalid-feedback">
                Valid category is required.
              </div>
            </div>
            
            <div class="col-sm-6">
              <label for="lastName" class="form-label">Release Date</label>
              <input type="text" class="form-control" name="releaseDate" placeholder="" value="<%= releaseDate %>" disabled>
              <div class="invalid-feedback">
                Valid release date is required.
              </div>
            </div>
	
            <div class="col-10">
              <label for="username" class="form-label">isbnStr Number</label>
              <div class="input-group has-validation">
                <input type="text" class="form-control" name="isbnStrNum" placeholder="" value=<%= isbnStr %> disabled>
              <div class="invalid-feedback">
                  isbnStr is required.
                </div>
              </div>
            </div>

            <div class="col-2">
              <label for="number" class="form-label">Quantity</label>
              <input type="number" class="form-control" name="quantity" placeholder="you@example.com" value="<%=quantity%>" disabled>
              <div class="invalid-feedback">
                Please enter a valid number.
              </div>
            </div>

            <div class="col-12">
              <label for="publisher" class="form-label">Publisher</label>
              <input type="text" class="form-control" name="publisher" placeholder="" value="<%= publisher %>" disabled>
              <div class="invalid-feedback">
                Please enter a valid publisher.
              </div>
            </div>

            <div class="col-12">
              <div class="form-floating">
			  <textarea class="form-control" placeholder="Leave a comment here" name="description"  style="height: 400px" disabled><%= description %></textarea>
			  <label for="floatingTextarea2">Description</label>
			</div>
            </div>
            
            <input type="text" class="form-control" name="bookID" placeholder="" value="<%= bookID %>" hidden>

          <hr class="my-4">

		  <div class="container">
		   <div class="row">
		  	<div class="col">
		  		<input class="btn btn-success btn-block form-control" type="submit" name="delete" value="Delete">
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