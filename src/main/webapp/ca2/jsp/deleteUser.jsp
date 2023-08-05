<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Delete User Page</title>
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
	if (session.getAttribute("Name") != null && session.getAttribute("Role") != null && session.getAttribute("loginStatus") != null) {
		name = session.getAttribute("Name").toString();
		role = session.getAttribute("Role").toString();
		loginStatus = session.getAttribute("loginStatus").toString();
	}
	
	if (!role.equals("administrator") && !role.equals("owner")) {
		response.sendRedirect("login.jsp");
	}
	
	//Get user attributes
	String userStr = request.getParameter("userId");
	String userID = "", userName = "", userPassword = "", birthday = "", email = "", userRole = "";
	
	// Set user delete function
	session.setAttribute("userFunction", "delete");
	
	try {

		// Step 1: Load JDBC Driver
				Class.forName("com.mysql.jdbc.Driver");

				// Step 2: Define Connection URL
				String connURL = "jdbc:mysql://localhost/jad_bookstore_db?user=root&password=NZRong456&serverTimezone=UTC";

				// Step 3: Establish connection to URL
				Connection conn = DriverManager.getConnection(connURL);

				// Step 5: Execute SQL Command
				String sqlStr = "SELECT * FROM jad_bookstore_db.user WHERE iduser = ?";
				PreparedStatement pstmt = conn.prepareStatement(sqlStr);
				pstmt.setString(1,userStr);

				ResultSet rs = pstmt.executeQuery();

				if (rs.next()) {
					userID = rs.getString("iduser");
					userName = rs.getString("name");
					userPassword = rs.getString("password");
					birthday = rs.getString("birthday");
					email = rs.getString("email");
					userRole = rs.getString("role");
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
							<a class="nav-link text-white" href="login.jsp">Logout</a>
						</h4>
					</li>
				</ul>
			</div>
		</div>
	</nav>
	<div class="content mx-auto">
<main>
    <div class="py-5 text-center">
      <img class="d-block mx-auto mb-4" src="../img/blankprofile.png" alt="" width="72" height="57">
      <h2><%= userName %></h2>
      <p class="lead">Details about <%= userName %></p>
    </div>
	
    <div class=" d-flex justify-content-center">
      
      <div class="col-md-7 col-lg-8">
      <h4 class="mb-3">Delete User Details</h4>
        <form class="needs-validation" action="<%=request.getContextPath()%>/UserDB" method="POST">
          <div class="row g-3">
          
            <div class="col-sm-6">
              <label for="firstName" class="form-label">Name</label>
              <input type="text" class="form-control" name="userName" placeholder="" value="<%= userName %>" disabled>
              <div class="invalid-feedback">
                Valid name is required.
              </div>
            </div>

            <div class="col-sm-6">
              <label for="lastName" class="form-label">Password</label>
              <input type="text" class="form-control" name="userPassword" placeholder="" value="<%= userPassword %>" disabled>
              <div class="invalid-feedback">
                Valid password is required.
              </div>
            </div>
            
            <div class="col-sm-6">
              <label for="lastName" class="form-label">Birthday</label>
              <input type="text" class="form-control" name="birthday" placeholder="" value="<%= birthday %>" disabled>
              <div class="invalid-feedback">
                Valid birthday is required.
              </div>
            </div>

			<div class="col-sm-6">
              <label for="lastName" class="form-label">Role</label>
              <input type="text" class="form-control" name=userRole placeholder="" value="<%= userRole %>" disabled>
              <div class="invalid-feedback">
                Valid role is required.
              </div>
            </div>

			<div class="col-12">
              <label for="lastName" class="form-label">Email</label>
              <input type="text" class="form-control" name="email" placeholder="" value="<%= email %>" disabled>
              <div class="invalid-feedback">
                Valid email is required.
              </div>
            </div>
            </div>
            <input type="text" class="form-control" name="userID" placeholder="" value="<%= userID %>" hidden>

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
</body>
</html>