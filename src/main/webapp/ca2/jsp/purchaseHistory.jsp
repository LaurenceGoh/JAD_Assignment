<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Purchase History Page</title>
<!-- Bootstrap link -->
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
<%@page import="java.sql.*, java.util.*,java.text.*, book.Book"%>
</head>
<body>

<!-- Order history template taken from https://codescandy.com/geeks-bootstrap-5/pages/dashboard/ecommerce/order-history.html -->
<%
	//If user has already logged in, 
	String loginStatus = "false";
	String name = "public";
	String role = "public";
	ArrayList<ArrayList<Book>> orderList = (ArrayList<ArrayList<Book>>) session.getAttribute("purchasedBookList");
	ArrayList<Integer> orderNumber = (ArrayList<Integer>) session.getAttribute("orderNumber");
	Timestamp orderDate = (Timestamp) session.getAttribute("orderedDate");
	int counter = 0;
	
	if (session.getAttribute("Name") != null && session.getAttribute("Role") != null && session.getAttribute("loginStatus") != null) {
		name = session.getAttribute("Name").toString();
		role = session.getAttribute("Role").toString();
		loginStatus = session.getAttribute("loginStatus").toString();
	}
	
	if (!role.equals("administrator") && !role.equals("owner") && !role.equals("member")) {
		response.sendRedirect("login.jsp");
	}
	String navString = "";
	
	if (loginStatus.equals("true")) {
		navString = name;
	} 
	System.out.println(orderNumber);
	String orderedContent = "";
	for (ArrayList<Book> bookList : orderList){
		String formattedDate = new SimpleDateFormat("dd/MM/yyyy").format(bookList.get(0).getOrderDate());
// date formatting taken from https://stackoverflow.com/questions/35170620/format-java-sql-timestamp-into-a-string
		orderedContent += "<div class=\"mb-8\">"
                +"<div class=\"border-bottom mb-3 pb-3 d-lg-flex align-items-center justify-content-between \">"
                +"<div class=\"d-flex align-items-center justify-content-between\">"
                +"<h5 class=\"mb-0\">Order #" + orderNumber.get(counter) + "</h5>"
				+" <span class=\"ms-4\">Ordered on  "+ formattedDate +"</span></div></div>";
				
				for (Book bookItem : bookList){
					orderedContent += "<div class=\"row justify-content-between align-items-center\">"
		                    +"<div class=\"col-lg-8 col-12\">"
		                    +"<div class=\"d-md-flex\"><div>"
		                    +"<img src=\"../img/" + bookItem.getImage() +  "\" alt=\"\" class=\"img-4by3-xl rounded mb-3 \"  width=\"100\" height=\"130\"></div>"
		                    +"<div class=\"ms-md-4 mt-2 mt-lg-0\">"
							+"<h5 class=\"mb-1\">" + bookItem.getTitle() +"</h5>"
							+"<span>" + bookItem.getAuthor()+"</span>"     
		                    +" <div class=\"mt-3\">"
							+"<h4>$"+String.format("%.2f",bookItem.getPrice()*1.18)+" </h4>USD</div></div></div></div></div>";
				}
				orderedContent +=" <hr class=\"my-3\">";
				counter++;
	}
		orderedContent += " </div>";
	
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
					<%
						if (role.equals("member")) {
							out.print("<li class=\"nav-item\"><h4><form action=\""+ request.getContextPath()+"/GetPurchaseHistory\" method=\"POST\">"
									+"<input type=\"submit\" class=\"nav-link text-white\" value=\"Purchase History\"></form></h4>"
									+"</li>");
						}
					session.setAttribute("username",name);
					%>
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
	
	<div class="d-flex justify-content-center">
		<section class="container-fluid p-4">
        <div class="row ">
          <div class="col-lg-12 col-md-12 col-12">
            <!-- Page header -->
            <div class="border-bottom pb-3 mb-3 ">
              <div class="mb-2 mb-lg-0">
                <h1 class="mb-0 h2 fw-bold">Order History </h1>
              </div>
            </div>
          </div>
        </div>
        <!-- row -->
        <div class="row">
          <div class="col-xxl-8 col-12">
            <!-- card -->
            <div class="card">
              <!-- card body-->
              <div class="card-body">
                <div class="mb-6">
                  <h4 class="mb-0">Your Order</h4>
                  <p>Check your past orders.</p>
                </div>   
                  <hr class="my-3">
                  	<% out.println(orderedContent);	 %>
                </div>
                
            
           
	        </div>
	        </div>
        </div>
      </section>
	</div>
	
	

</body>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe"
	crossorigin="anonymous"></script>
</html>