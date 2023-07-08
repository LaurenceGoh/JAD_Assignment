<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Verify User Page</title>
<%@page import="java.sql.*"%>
</head>
<body>
 
<%
	// Declare variable
	boolean found = false;
	String name = "";
	String role = "";
	String email = (String) request.getParameter("email");
	String password = (String) request.getParameter("pwd");	

	try {
		// SQL select check for existing account
		Class.forName("com.mysql.jdbc.Driver");
		String connURL = "jdbc:mysql://localhost/jad_bookstore_db?user=root&password=123456&serverTimezone=UTC";
		Connection conn = DriverManager.getConnection(connURL);
		String sqlStr = "SELECT * FROM jad_bookstore_db.user WHERE email = ? AND password = ?";
		PreparedStatement pstmt = conn.prepareStatement(sqlStr);
		pstmt.setString(1, email);
		pstmt.setString(2, password);
		ResultSet rs = pstmt.executeQuery();
		
		if (rs.next()) {
	  	  	found = true;
	  		name = rs.getString("name");
	  		role = rs.getString("role");
	    }
	    
	    else {
	  	  	System.out.print("Record not found.");
	    }
		
		conn.close();
	}

	catch (Exception e) {
		out.println("Error :" + e);
		System.out.println("Error :" + e);		
	}

	if (found) {
		// Set attribute on account detail
		session.setAttribute("Name", name);
		session.setAttribute("Role", role);
		session.setAttribute("loginStatus", found);
		session.setMaxInactiveInterval(15 * 60);
		response.sendRedirect("index.jsp");
	}
	
	else {
		response.sendRedirect("login.jsp?errCode=invalidLogin");
	}
%>

<form method="post" action="displayMember.jsp">
	<input type="hidden" name="Name" value="<%=name%>">
	<input type="hidden" name="Role" value="<%=role%>">
	<input type="hidden" name=loginStatus value="<%=found%>">
</form>

</body>
</html>