<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%> 
<!DOCTYPE html>  
<html>
<head>
<meta charset="ISO-8859-1">
<title>Admin Page</title>
<!-- Bootstrap link -->
<link rel="canonical"
	href="https://getbootstrap.com/docs/5.3/examples/sign-in/">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ"
	crossorigin="anonymous">
<style>
<%@ include file="/ca2/css/admin.css"%>
</style>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"></script>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
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
	
	else {
		navString = "Public User";
	}
	
	//Reset sttribute for function
	session.setAttribute("bookFunction", "none");
	session.setAttribute("userFunction", "none");
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

<div class="px-4 py-5 my-5 text-center">
    <h1 class="display-5 fw-bold text-body-emphasis">Welcome to the admin page</h1>
    <div class="col-lg-6 mx-auto">
      <p class="lead mb-4">Remember to log out once done!</p>
     <%
     	// Messages from code
		String message = request.getParameter("code");
    	if (message != null && message.equals("bookEditError")) {
			out.print("Error.. <br><h2>Please try again!</h2>");
		}
		
		else if (message != null && message.equals("bookEditSuccess")) {
				out.print("<br><h2>Book successfully edited!</h2>");
		}
    	
		else if (message != null && message.equals("bookDeleteError")) {
			out.print("Error.. <br><h2>Please try again!</h2>");
		}
    	
		else if (message != null && message.equals("bookDeleteSuccess")) {
			out.print("<br><h2>Book successfully deleted!</h2>");
		}
    	
		else if (message != null && message.equals("userDeleteError")) {
			out.print("Error.. <br><h2>Please try again!</h2>");
		}
    	
		else if (message != null && message.equals("userDeleteSuccess")) {
			out.print("<br><h2>User successfully deleted!</h2>");
		}
    	
		else if (message != null && message.equals("userEditError")) {
			out.print("Error.. <br><h2>Please try again!</h2>");
		}
    	
		else if (message != null && message.equals("userEditSuccess")) {
			out.print("<br><h2>User successfully edited!</h2>");
		}
    	
		else if (message != null && message.equals("picEditError")) {
			out.print("Error.. <br><h2>Please try again!</h2>");
		}
	 %>
    </div>
  </div>
<div class="container px-4 py-5" id="hanging-icons">

    <h2 class="pb-2 border-bottom">Book Database</h2>
    <div class="row g-4 py-5 row-cols-1 row-cols-lg-3">
    	<div class="col d-flex align-items-start">
        <div class="icon-square text-body-emphasis bg-body-secondary d-inline-flex align-items-center justify-content-center fs-4 flex-shrink-0 me-3">
          <img src="../img/p101.png" width="40px" height="40px">
        </div>
        <div>
          <h3 class="fs-2 text-body-emphasis">View</h3>
          <p>View all books available from the database.</p>
          <a href="bookList.jsp" class="btn btn-primary">
            View
          </a>
        </div>
      </div>
    
    
      <div class="col d-flex align-items-start">
        <div class="icon-square text-body-emphasis bg-body-secondary d-inline-flex align-items-center justify-content-center fs-4 flex-shrink-0 me-3">
          <img src="../img/p101.png" width="40px" height="40px">
        </div>
        <div>
          <h3 class="fs-2 text-body-emphasis">Add new book</h3>
          <p>Add a new book to the database.</p>
          <a href="addBook.jsp" class="btn btn-primary">
            Add
          </a>
        </div>
      </div>
      
      
      <div class="col d-flex align-items-start">
        <div class="icon-square text-body-emphasis bg-body-secondary d-inline-flex align-items-center justify-content-center fs-4 flex-shrink-0 me-3">
          <img src="../img/p101.png" width="40px" height="40px">
        </div>
        <div>
          <h3 class="fs-2 text-body-emphasis">Edit book</h3>
          <p>Edit a book from the database.</p>
          <a href="selectBook.jsp?code=edit" class="btn btn-primary">
            Edit
          </a>
        </div>
      </div>
      
      <div class="col d-flex align-items-start">
        <div class="icon-square text-body-emphasis bg-body-secondary d-inline-flex align-items-center justify-content-center fs-4 flex-shrink-0 me-3">
          <img src="../img/p101.png" width="40px" height="40px">
        </div>
        <div>
          <h3 class="fs-2 text-body-emphasis">Delete book</h3>
          <p>Delete a book from the database.</p>
          <a href="selectBook.jsp?code=delete" class="btn btn-primary">
            Delete
          </a>
        </div>
      </div>
    </div>
  </div>	

<div class="container px-4 py-5" id="hanging-icons">

    <h2 class="pb-2 border-bottom">User Database</h2>
    <div class="row g-4 py-5 row-cols-1 row-cols-lg-3">
    	<div class="col d-flex align-items-start">
        <div class="icon-square text-body-emphasis bg-body-secondary d-inline-flex align-items-center justify-content-center fs-4 flex-shrink-0 me-3">
          <img src="../img/blankprofile.png" width="40px" height="40px">
        </div>
        <div>
          <h3 class="fs-2 text-body-emphasis">View</h3>
          <p>View all available users from the database.</p>
          <a href="userList.jsp" class="btn btn-primary">
            View
          </a>
        </div>
      </div>
      
      <div class="col d-flex align-items-start">
        <div class="icon-square text-body-emphasis bg-body-secondary d-inline-flex align-items-center justify-content-center fs-4 flex-shrink-0 me-3">
          <img src="../img/blankprofile.png" width="40px" height="40px">
        </div>
        <div>
          <h3 class="fs-2 text-body-emphasis">Search user</h3>
          <p>Search a user from the database.</p>
          <a href="searchUser.jsp" class="btn btn-primary">
            Search
          </a>
        </div>
      </div>
    
    
      <div class="col d-flex align-items-start">
        <div class="icon-square text-body-emphasis bg-body-secondary d-inline-flex align-items-center justify-content-center fs-4 flex-shrink-0 me-3">
          <img src="../img/blankprofile.png" width="40px" height="40px">
        </div>
        <div>
          <h3 class="fs-2 text-body-emphasis">Add new user</h3>
          <p>Add a new user to the database.</p>
          <a href="addUser.jsp" class="btn btn-primary">
            Add
          </a>
        </div>
      </div>
      
      
      <div class="col d-flex align-items-start">
        <div class="icon-square text-body-emphasis bg-body-secondary d-inline-flex align-items-center justify-content-center fs-4 flex-shrink-0 me-3">
          <img src="../img/blankprofile.png" width="40px" height="40px">
        </div>
        <div>
          <h3 class="fs-2 text-body-emphasis">Edit user</h3>
          <p>Edit a user's details from the database.</p>
          <a href="selectUser.jsp?code=edit" class="btn btn-primary">
            Edit
          </a>
        </div> 
      </div>
      
      <div class="col d-flex align-items-start">
        <div class="icon-square text-body-emphasis bg-body-secondary d-inline-flex align-items-center justify-content-center fs-4 flex-shrink-0 me-3">
          <img src="../img/blankprofile.png" width="40px" height="40px">
        </div>
        <div>
          <h3 class="fs-2 text-body-emphasis">Delete user</h3>
          <p>Delete a user from the database.</p>
          <a href="selectUser.jsp?code=delete" class="btn btn-primary">
            Delete
          </a>
        </div>
      </div>
    </div>
  </div>	
  
<div class="container px-4 py-5" id="hanging-icons">
	<h2 class="pb-2 border-bottom">Sales database</h2>
    <div class="row g-4 py-5 row-cols-1 row-cols-lg-3">
    <div class="col d-flex align-items-start">
        <div class="icon-square text-body-emphasis bg-body-secondary d-inline-flex align-items-center justify-content-center fs-4 flex-shrink-0 me-3">
          <img src="../img/sales.jpg" width="40px" height="40px">
        </div>
        <div>
          <h3 class="fs-2 text-body-emphasis">Overall Stats</h3>
          <p>Overall statistics.</p>
          <a href="overallStats.jsp" class="btn btn-primary">
            View
          </a>
        </div>
      </div>
    
    	<div class="col d-flex align-items-start">
        <div class="icon-square text-body-emphasis bg-body-secondary d-inline-flex align-items-center justify-content-center fs-4 flex-shrink-0 me-3">
          <img src="../img/sales.jpg" width="40px" height="40px">
        </div>
        <div>
          <h3 class="fs-2 text-body-emphasis">Book Stats</h3>
          <p>Statistics on individual books.</p>
          <a href="salesBookSelect.jsp" class="btn btn-primary">
            View
          </a>
        </div>
      </div>
</div>



    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" crossorigin="anonymous"></script>
</body>
</html>