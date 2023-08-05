<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Cart Details</title>
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
<style><%@ include file="/ca2/css/cartDetails.css"%></style>
<%@page import = "book.Book" %>
<%@page import = "java.util.ArrayList" %>	
<%@page import="java.sql.*"%>
</head>
<body>

<!-- checkout template taken from https://mdbootstrap.com/docs/standard/extended/shopping-carts/ -->
<%
	ArrayList<Book> book = (ArrayList<Book>)session.getAttribute("book");
	double totalPrice = 0,shipping=0,gst=0;
	
	String bookList="";
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
	
	try {
		int bookButtonCounter=0;
		for (Book a:book){
			int bookCounter = 0;
	      	bookList += "<div class=\"row\">"
	                	+"<div class=\"col-lg-3 col-md-12 mb-4 mb-lg-0\">"
           				+"<div class=\"bg-image hover-overlay hover-zoom ripple rounded\" data-mdb-ripple-color=\"light\">"
             			+"<img src=\"../img/"+a.getImage()+"\"class=\"w-100\" alt=\"Book Image\" />"
              			+"<a href=\"#!\">"
                		+"<div class=\"mask\" style=\"background-color: rgba(251, 251, 251, 0.2)\"></div>"
              			+"</a></div></div>"
          				+"<div class=\"col-lg-5 col-md-6 mb-4 mb-lg-0\">"
            			+"<p><strong>"+a.getTitle()+"</strong></p></div>"
          				+"<div class=\"col-lg-4 col-md-6 mb-4 mb-lg-0\">"
            			+"<div class=\"d-flex mb-4\" style=\"max-width: 300px\">"
              			+"<button type=\"submit\" name=\"bookButton"+bookButtonCounter+"\" value=\"minus\" class=\"btn btn-primary px-3 me-2\">"
            		  	+"<i class=\"bi bi-dash\"></i></button>"
		               	+"<div class=\"form-outline\">"
		                +"<input id=\"form1\" min=\"0\" name=\"quantity\" value=\""+a.getBookCounter()+"\" type=\"number\" class=\"form-control\" disabled/>"
		                +"<label class=\"form-label\" for=\"form1\">Quantity</label></div>"
						+"<button type=\"submit\" name=\"bookButton"+bookButtonCounter+"\" value=\"add\" class=\"btn btn-primary px-3 ms-2\">"
			            +"<i class=\"bi bi-plus\"></i></button></div></button>"
			            +"<p class=\"text-start text-md-center\"><strong>$"+a.getPrice()+"</strong></p></div></div>";
		                System.out.println("Current bookCounter : " + bookCounter);
		               
           while (bookCounter<a.getBookCounter()){
        	   System.out.println(a.getBookCounter());
        	   totalPrice += a.getPrice();
        	   System.out.println("Subtotal price of " + a.getTitle() + " " + totalPrice);
        	   bookCounter++;	
           }
	      	
            bookButtonCounter++;		
            System.out.println(a.getBookCounter());
		}
		shipping += totalPrice*0.1;
		gst += totalPrice*0.08;
		session.setAttribute("divCounter",book.size());
		session.setAttribute("totalPrice", totalPrice);
		session.setAttribute("orderedItems",book);
	} catch(Exception e){
		System.out.println(e);
	}
	%>


	<nav class="navbar navbar-expand bg-black">
		<div class="container-fluid">
			<a class="navbar-brand text-white" href=""><%=navString%></a>
			<%
				if (role.equals("administrator")) {
					out.print("<a class=\"navbar-brand text-white\" href=\"admin.jsp\">Admin</a>");
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
						session.setAttribute("username", navString);
						%>
						</h4>
					</li>
				</ul>
			</div>
		</div>
	</nav>

<div class="container">

  
 
  <section class="h-100 gradient-custom">
  <div class="container py-5">
    <div class="row d-flex justify-content-center my-4">
      <div class="col-md-8">
        <div class="card mb-4">
          <div class="card-header py-3">
            <h5 class="mb-0">Cart - <%= book.size() %> items</h5>
          </div>
          <div class="card-body">
            <!-- Single item -->
            <div class="row">
           
           <% if (book.size()==0 || book == null){
            	out.println("<p class=\"text-center\">You have no books in your cart.</p>");
            	out.println("<div class=\"d-grid gap-2 d-md-flex justify-content-center\"><a href=\"index.jsp\" class=\"btn btn-primary btn-block\">Back to shopping</a></div>");
            }
            %>
          
			<form action="editCart.jsp" method="POST">
           
            <%= bookList %>
             </form>
            </div>
            
          </div>
        </div>
      
        <div class="card mb-4 mb-lg-0">
          <div class="card-body">
            <p><strong>We accept</strong></p>
            <img class="me-2" width="45px"
              src="https://mdbcdn.b-cdn.net/wp-content/plugins/woocommerce-gateway-stripe/assets/images/visa.svg"
              alt="Visa" />
            <img class="me-2" width="45px"
              src="https://mdbcdn.b-cdn.net/wp-content/plugins/woocommerce-gateway-stripe/assets/images/amex.svg"
              alt="American Express" />
            <img class="me-2" width="45px"
              src="https://mdbcdn.b-cdn.net/wp-content/plugins/woocommerce-gateway-stripe/assets/images/mastercard.svg"
              alt="Mastercard" />
            <img class="me-2" width="45px"
              src="https://mdbcdn.b-cdn.net/wp-content/plugins/woocommerce/includes/gateways/paypal/assets/images/paypal.webp"
              alt="PayPal acceptance mark" />
          </div>
        </div>
      </div>
      
      <div class="col-md-4">
        <div class="card mb-4">
          <div class="card-header py-3">
            <h5 class="mb-0">Summary</h5>
          </div>
          <div class="card-body">
            <ul class="list-group list-group-flush">
              <li
                class="list-group-item d-flex justify-content-between align-items-center border-0 px-0 pb-0">
                Products
                <span><% out.print(String.format("%.2f",totalPrice)); %></span>
              </li>
              <li class="list-group-item d-flex justify-content-between align-items-center px-0">
                Shipping
                <span><% out.print(String.format("%.2f",shipping)); %></span>
              </li>
               <li class="list-group-item d-flex justify-content-between align-items-center px-0">
                GST (8%)
                <span><% out.print(String.format("%.2f",gst)); %></span>
              </li>
              <li
                class="list-group-item d-flex justify-content-between align-items-center border-0 px-0 mb-3">
                <div>
                  <strong>Total amount (USD)</strong>
                </div>
                <span><strong>$<% out.print(String.format("%.2f",(shipping+totalPrice+gst))); %></strong></span>
              </li>
            </ul>
            
 			<form action="<%=request.getContextPath()%>/AuthorizePayment" method="POST">
 				<% if(book.size()==0){
 				  	out.print("<input type=\"submit\" disabled class=\"btn btn-primary btn-lg btn-block\" value=\"Go to checkout\">");
 				} else {
 					out.print("<input type=\"submit\" class=\"btn btn-primary btn-lg btn-block\" value=\"Go to checkout\">");
 				}
 				%>
			</form>
          </div>
        </div>
      </div>
    </div>
  </div>
  
  
  
</section>
  


  <footer class="my-5 pt-5 text-body-secondary text-center text-small">
    <p class="mb-1">© 2017–2023 Company Name</p>
    <ul class="list-inline">
      <li class="list-inline-item"><a href="#">Privacy</a></li>
      <li class="list-inline-item"><a href="#">Terms</a></li>
      <li class="list-inline-item"><a href="#">Support</a></li>
    </ul>
  </footer>
</div>
</body>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe"
	crossorigin="anonymous"></script>
</html>