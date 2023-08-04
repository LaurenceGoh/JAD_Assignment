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
 * Servlet implementation class registerUser
 */
@WebServlet("/RegisterUser")
public class RegisterUser extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RegisterUser() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//get variable and regex for data validation
		boolean found = false;
		String name = (String) request.getParameter("name");
		String email = (String) request.getParameter("email");
		String password = (String) request.getParameter("pwd");
		String confirmPassword = (String) request.getParameter("pwdConfirm");
		String birthday = (String) request.getParameter("birthday");
		String address = (String) request.getParameter("address");
		Pattern birthdayPattern = Pattern.compile("[0-9]{4}-[0-9]{2}-[0-9]{2}", Pattern.CASE_INSENSITIVE);
		Matcher matcher = birthdayPattern.matcher(birthday);
		boolean matchFound = matcher.find();
		HttpSession session = request.getSession();
		PrintWriter out = response.getWriter();
		// Check if both password input matches
		if (!password.equals(confirmPassword)) {
			response.sendRedirect("ca2/jsp/register.jsp?code=conflictPwd");
		}
		
		else {		
			// Check if date format is correct
			if (!matchFound) {
				response.sendRedirect("ca2/jsp/register.jsp?code=invalidDate");
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
						String sqlStr = "INSERT INTO jad_bookstore_db.user(name, password, birthday, email, address, role) values(?, ?, ?, ?, ?, 'member')";
						PreparedStatement pstmt = conn.prepareStatement(sqlStr);
						pstmt.setString(1, name);
						pstmt.setString(2, password);
						pstmt.setDate(3, java.sql.Date.valueOf(birthday));
						pstmt.setString(4, email);
						pstmt.setString(5, address);
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
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
