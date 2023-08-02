package servlets;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.sql.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
/**
 * Servlet implementation class userDB
 */
@WebServlet("/UserDB")
public class UserDB extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UserDB() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// Declare variable
		HttpSession session = request.getSession();
		PrintWriter out = response.getWriter();

		String cancel = "";
		String save = "";
		String userFunction = "none";
		String sessionRole = session.getAttribute("Role").toString();

		cancel = request.getParameter("cancel");
		save = request.getParameter("save");
		userFunction = session.getAttribute("userFunction").toString();
		
		//Add function
		if (userFunction.equals("add")) {
			if (cancel != null && cancel.equals("Return to admin page")) {
				response.sendRedirect("ca2/jsp/admin.jsp");
			}
			
			else {
				//Get user variable
				boolean found = false;
				String name = (String) request.getParameter("name");
				String email = (String) request.getParameter("email");
				String password = (String) request.getParameter("pwd");
				String confirmPassword = (String) request.getParameter("pwdConfirm");
				String birthday = (String) request.getParameter("birthday");
				String address = (String) request.getParameter("address");
				String role = (String) request.getParameter("role");
				Pattern birthdayPattern = Pattern.compile("[0-9]{4}-[0-9]{2}-[0-9]{2}", Pattern.CASE_INSENSITIVE);
				Matcher matcher = birthdayPattern.matcher(birthday);
				boolean matchFound = matcher.find();
				
				// Check if both password input matches
				if (!password.equals(confirmPassword)) {
					response.sendRedirect("ca2/jsp/addUser.jsp?code=conflictPwd");
				}
				
				else {		
					// Check if date format is correct
					if (!matchFound) {
						response.sendRedirect("ca2/jsp/addUser.jsp?code=invalidDate");
					}
					
					else {
						try {
							// Check for email duplication
							Class.forName("com.mysql.jdbc.Driver");
							String connURL = "jdbc:mysql://localhost/jad_bookstore_db?user=root&password=NZRong456&serverTimezone=UTC";
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
							response.sendRedirect("ca2/jsp/addUser.jsp?code=emailExist");
						}
						
						else {
							if (!role.toLowerCase().equals("member") && !role.toLowerCase().equals("administrator") && !role.toLowerCase().equals("owner")) {
								response.sendRedirect("ca2/jsp/addUser.jsp?code=invalidRole");
							}
							
							else {
								try {
									// Add user account
									Class.forName("com.mysql.jdbc.Driver");
									String connURL = "jdbc:mysql://localhost/jad_bookstore_db?user=root&password=NZRong456&serverTimezone=UTC";
									Connection conn = DriverManager.getConnection(connURL);
									String sqlStr = "INSERT INTO jad_bookstore_db.user(name, password, birthday, email, address, role) values(?, ?, ?, ?, ?, ?)";
									PreparedStatement pstmt = conn.prepareStatement(sqlStr);
									pstmt.setString(1, name);
									pstmt.setString(2, password);
									pstmt.setDate(3, java.sql.Date.valueOf(birthday));
									pstmt.setString(4, email);
									pstmt.setString(5, address);
									pstmt.setString(6, role.toLowerCase());
									int rowInserted = pstmt.executeUpdate();
									
									System.out.println(rowInserted + " records inserted");
									response.sendRedirect("ca2/jsp/addUser.jsp?code=insertSuccess");
									
									conn.close(); 
								}
								
								catch (Exception e) {
									response.sendRedirect("ca2/jsp/addUser.jsp?code=insertError");
									System.out.println("Error :" + e);
								}
							}
						}
					}
				}
			}
		}
		
		// User edit function
		else if (userFunction.equals("edit")) {
			if (cancel != null && cancel.equals("Return")) {			
				if (sessionRole.equals("administrator") || sessionRole.equals("owner")) {
					response.sendRedirect("ca2/jsp/admin.jsp");
				}
				
				else if (sessionRole.equals("member")) {
					response.sendRedirect("ca2/jsp/index.jsp");
				}
			}
			
			else {
				// Get user variable
				String userID = request.getParameter("userID");
				String userName = request.getParameter("userName");
				String userPassword = request.getParameter("userPassword");
				String birthday = request.getParameter("birthday");
				String userRole = request.getParameter("userRole");
				String email = request.getParameter("email");
				String address = request.getParameter("homeAddress");
				
				try {
					// SQL update user details
					Class.forName("com.mysql.jdbc.Driver");
					String connURL = "jdbc:mysql://localhost/jad_bookstore_db?user=root&password=NZRong456&serverTimezone=UTC";
					Connection conn = DriverManager.getConnection(connURL);
					String sqlStr = "UPDATE user SET name = ?, password = ?, birthday = ?, email = ?, address = ?, role = ? "
							+ " WHERE iduser = ?";
					PreparedStatement pstmt = conn.prepareStatement(sqlStr);
					pstmt.setString(1, userName);
					pstmt.setString(2, userPassword);
					pstmt.setDate(3, java.sql.Date.valueOf(birthday));
					pstmt.setString(4, email);
					pstmt.setString(5, address);
					pstmt.setString(6, userRole);
					pstmt.setInt(7, Integer.parseInt(userID));
					int rowInserted = pstmt.executeUpdate();
					
					System.out.println(rowInserted + " records edited");
					
					if (sessionRole.equals("administrator") || sessionRole.equals("owner")) {
						response.sendRedirect("ca2/jsp/admin.jsp?code=userEditSuccess");
					}
					
					else if (sessionRole.equals("member")) {
						response.sendRedirect("ca2/jsp/editUser.jsp?code=editSuccess");
					}
					
					conn.close(); 
				}
				
				catch (Exception e) {
					if (sessionRole.equals("administrator") || sessionRole.equals("owner")) {
						response.sendRedirect("ca2/jsp/admin.jsp?code=userEditError");
					}
					
					else if (sessionRole.equals("member")) {
						response.sendRedirect("ca2/jsp/editUser.jsp?code=editError");
					}
					System.out.println("Error :" + e);
				}
				
			}
		}
		
		// User delete function
		else if (userFunction.equals("delete")) {
			if (cancel != null && cancel.equals("Return to admin page")) {
				response.sendRedirect("ca2/jsp/admin.jsp");
			}
			
			else {
				//Get user attribute
				String userID = request.getParameter("userID");
				
				try {
					// SQL delete user
					Class.forName("com.mysql.jdbc.Driver");
					String connURL = "jdbc:mysql://localhost/jad_bookstore_db?user=root&password=NZRong456&serverTimezone=UTC";
					Connection conn = DriverManager.getConnection(connURL);
					String sqlStr = "DELETE FROM jad_bookstore_db.user WHERE iduser = ?";
					PreparedStatement pstmt = conn.prepareStatement(sqlStr);
					pstmt.setString(1, userID);
					int rowInserted = pstmt.executeUpdate();
					
					System.out.println(rowInserted + " records deleted");
					response.sendRedirect("ca2/jsp/admin.jsp?code=userDeleteSuccess");
					
					conn.close(); 
				}
				
				catch (Exception e) {
					response.sendRedirect("ca2/jsp/admin.jsp?code=userDeleteError");
					System.out.println("Error :" + e);
				}
			}
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
