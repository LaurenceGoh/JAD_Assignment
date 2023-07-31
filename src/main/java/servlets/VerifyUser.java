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
/**
 * Servlet implementation class verifyUser
 */
@WebServlet("/VerifyUser")
public class VerifyUser extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public VerifyUser() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Declare variable
		boolean found = false;
		String name = "";
		String role = "";
		String email = (String) request.getParameter("email");
		String password = (String) request.getParameter("pwd");	
		HttpSession session = request.getSession();
		PrintWriter out = response.getWriter();

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
			response.sendRedirect("ca2/jsp/index.jsp");
		}
		
		else {
			response.sendRedirect("ca2/jsp/login.jsp?errCode=invalidLogin");
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
