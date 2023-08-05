<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<%@ page import="java.util.*, book.Book" %>
<body>
	<%
		ArrayList<Book> book = (ArrayList<Book>)session.getAttribute("book");
		
		int divCounter = (int) session.getAttribute("divCounter");
		System.out.println(divCounter);
		for (int a=0;a<divCounter;a++){
			String buttonClicked = request.getParameter("bookButton" + a);
			if (buttonClicked!= null){
				System.out.println("button clicked " + buttonClicked);
				if (buttonClicked.equals("minus")){
					book.get(a).setBookCounter(book.get(a).getBookCounter()-1);
					int newBookIndexCounter = book.get(a).getBookCounter();
					if (newBookIndexCounter == 0){
						book.remove(book.get(a));
					}
				}
				else if (buttonClicked.equals("add")){
					book.get(a).setBookCounter(book.get(a).getBookCounter()+1);
				}
			}
		}
		response.sendRedirect("cartDetails.jsp");
	%>
	
</body>
</html>