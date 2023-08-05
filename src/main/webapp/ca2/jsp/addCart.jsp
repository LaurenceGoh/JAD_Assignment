<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%@page import = "java.util.ArrayList" %>
<%@page import = "java.sql.*" %>
<%@page import = "book.Book" %>
<%
	String buttonStatus = request.getParameter("bookButton");
	try {
		String loginStatus =  session.getAttribute("loginStatus").toString();
		if (loginStatus.equals("false")){
			response.sendRedirect("login.jsp");
		}
		else {
			String bookID = "", title = "", category = "", image = "", author = "", releaseDate = "", publisher = "", description = "", isbnStr = "",
			results = "", rating = "";
			int quantity=0;
			double price = 0.0;
			ArrayList<Book> bookList;
			
			if (session.getAttribute("book")==null){
				bookList = new ArrayList<Book>();
			} else {
				bookList = (ArrayList<Book>)session.getAttribute("book");
			}
			
				String bookStr = (String) session.getAttribute("bookId");
			
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
					
					Book newBook = new Book(title,category,quantity,Double.parseDouble(rating),price,image,author,releaseDate,isbnStr,publisher,description,1,null);
					bookList.add(newBook);
					session.setAttribute("book",bookList);
					}
		
				else {
					// do nothing
					System.out.println("Record not found!");
				}
		
				conn.close();	
			}
			response.sendRedirect("cartDetails.jsp");
			
		} catch (Exception e){
			out.println(e);
			response.sendRedirect("login.jsp");
		}
	
%>

</body>
</html>