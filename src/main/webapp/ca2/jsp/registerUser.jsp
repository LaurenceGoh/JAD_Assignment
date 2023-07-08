<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Register User Page</title>
<%@page import="java.sql.*" import="java.util.regex.Matcher" import="java.util.regex.Pattern"%>
</head>
<body>

<%
	//get variable and regex for data validation
	boolean found = false;
	String name = (String) request.getParameter("name");
	String email = (String) request.getParameter("email");
	String password = (String) request.getParameter("pwd");
	String confirmPassword = (String) request.getParameter("pwdConfirm");
	String birthday = (String) request.getParameter("birthday");
	Pattern birthdayPattern = Pattern.compile("[0-9]{4}-[0-9]{2}-[0-9]{2}", Pattern.CASE_INSENSITIVE);
	Matcher matcher = birthdayPattern.matcher(birthday);
	boolean matchFound = matcher.find();
	
	// Check if both password input matches
	if (!password.equals(confirmPassword)) {
		response.sendRedirect("register.jsp?code=conflictPwd");
	}
	
	else {		
		// Check if date format is correct
		if (!matchFound) {
			response.sendRedirect("register.jsp?code=invalidDate");
		}
		
		else {
			try {
				
				// Select SQL to check for email duplication
				Class.forName("com.mysql.jdbc.Driver");
				String connURL = "jdbc:mysql://localhost/jad_bookstore_db?user=root&password=123456&serverTimezone=UTC";
				Connection conn = DriverManager.getConnection(connURL);
				String sqlStr = "SELECT * FROM jad_bookstore_db.user WHERE email = ?";
				PreparedStatement pstmt = conn.prepareStatement(sqlStr);
				pstmt.setString(1, email);
				ResultSet rs = pstmt.executeQuery();

				if (rs.next()) {
			  	  	found = true;
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
				response.sendRedirect("ca2/jsp/register.jsp?code=emailExist");
			}
			
			else {
				try {
					// SQL to insert new account
					Class.forName("com.mysql.jdbc.Driver");
					String connURL = "jdbc:mysql://localhost/jad_bookstore_db?user=root&password=123456&serverTimezone=UTC";
					Connection conn = DriverManager.getConnection(connURL);
					String sqlStr = "INSERT INTO jad_bookstore_db.user(name, password, birthday, email, role) values(?, ?, ?, ?, 'member')";
					PreparedStatement pstmt = conn.prepareStatement(sqlStr);
					pstmt.setString(1, name);
					pstmt.setString(2, password);
					pstmt.setDate(3, java.sql.Date.valueOf(birthday));
					pstmt.setString(4, email);
					int rowInserted = pstmt.executeUpdate();
					
					System.out.println(rowInserted + " records inserted");
					response.sendRedirect("ca2/jsp/register.jsp?code=insertSuccess");
					
					conn.close(); 
				}
				
				catch (Exception e) {
					response.sendRedirect("ca2/jsp/register.jsp?code=insertError");
					System.out.println("Error :" + e);
				}
			}
		}
	}
%>

</body>
</html>