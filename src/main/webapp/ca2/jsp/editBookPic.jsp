<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Edit Boom Image Page</title>
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
	<%@ include file = "../css/editBookPic.css" %>
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
	

	// Get book variable
	String bookStr = request.getParameter("bookId");
	String bookID = "", title = "", category = "", image = "", author = "", releaseDate = "", publisher = "", description = "", isbnStr = "",
	results = "", rating = "";	
	double price = 0.0;
	int quantity = 0;
	
	//Set book edit function
	session.setAttribute("bookFunction", "editPic");
	
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
			} catch (Exception e){
				out.println(e);
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
    <div class="row d-flex justify-content-center">
      
      <div class="col-md-7 col-lg-8">
        <h4 class="mb-3">Edit Book Picture</h4>
        <form class="needs-validation" action="<%=request.getContextPath()%>/BookPicUpload" method="POST" enctype="multipart/form-data">
          <div class="row g-3">
            <div class="col-sm-6">
              <label for="firstName" class="form-label">Title</label>
              <input type="text" class="form-control" name="title" placeholder="" value="<%= title %>" readonly>
              <div class="invalid-feedback">
              </div>
            </div>

            <div class="col-sm-6">
              <label for="lastName" class="form-label">Book Picture</label>
              <input type="file" class="form-control" name="file">
            </div>          
            
            <input type="text" class="form-control" name="bookID" placeholder="" value="<%= bookID %>" hidden>

          <hr class="my-4">

		  <div class="container">
		   <div class="row">
		  	<div class="col">
		  		<input class="btn btn-success btn-block form-control" type="submit" name="upload" value="Save picture">
		  	</div>
		  </div>
          </div>         
        </form>
        <form action="admin.jsp" method="POST">
        	<div class="row g-3">
        		<div class="container">
        			<div class="col">
        				<input class="btn btn-primary btn-block form-control" type="submit" name="cancel" value="Return">
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