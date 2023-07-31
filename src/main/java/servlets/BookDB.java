package servlets;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class bookDB
 */
@WebServlet("/BookDB")
public class BookDB extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BookDB() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// Declare variables
		String cancel = "";
		String save = "";
		String bookFunction = "none";
		HttpSession session = request.getSession();
		
		cancel = request.getParameter("cancel");
		save = request.getParameter("save");
		bookFunction = session.getAttribute("bookFunction").toString();
		
		// Edit function
		if (bookFunction.equals("edit")) {
			if (cancel != null && cancel.equals("Return to admin page")) {
				response.sendRedirect("ca2/jsp/admin.jsp");
			}
			
			else if (save != null && save.equals("Save details")) {
				// Get variable from book
				String bookID = request.getParameter("bookID");
				String title = request.getParameter("title");
				String author = request.getParameter("author");
				String rating = request.getParameter("rating");
				String price = request.getParameter("price");
				String category = request.getParameter("category");
				String releaseDate = request.getParameter("releaseDate");
				String isbnStrNum = request.getParameter("isbnStrNum");
				String quantity = request.getParameter("quantity").toString();
				String publisher = request.getParameter("publisher");
				String description = request.getParameter("description");
				
				
				try {
					// Uodate SQL
					Class.forName("com.mysql.jdbc.Driver");
					String connURL = "jdbc:mysql://localhost/jad_bookstore_db?user=root&password=123456&serverTimezone=UTC";
					Connection conn = DriverManager.getConnection(connURL);
					String sqlStr = "UPDATE books SET title = ?, author = ?, rating = ?, price = ?, category = ?, releaseDate = ?, isbnNumber = ?, quantity = ?, publisher = ?, description = ? "
							+ " WHERE idbooks = ?";
					PreparedStatement pstmt = conn.prepareStatement(sqlStr);
					pstmt.setString(1, title);
					pstmt.setString(2, author);
					pstmt.setString(3, rating);
					pstmt.setDouble(4, Double.parseDouble(price));
					pstmt.setString(5, category);
					pstmt.setDate(6, java.sql.Date.valueOf(releaseDate));
					pstmt.setString(7, isbnStrNum);
					pstmt.setInt(8, Integer.parseInt(quantity));
					pstmt.setString(9, publisher);
					pstmt.setString(10, description);
					pstmt.setInt(11, Integer.parseInt(bookID));
					int rowInserted = pstmt.executeUpdate();
					
					System.out.println(rowInserted + " records edited");
					response.sendRedirect("ca2/jsp/admin.jsp?code=bookEditSuccess");
					
					conn.close(); 
				}
				
				catch (Exception e) {
					response.sendRedirect("ca2/jsp/admin.jsp?code=bookEditError");
					System.out.println("Error :" + e);
				}
			}
		}
		
		// Add function
		else if (bookFunction.equals("add")) {
			if (cancel != null && cancel.equals("Return to admin page")) {
				response.sendRedirect("ca2/jsp/admin.jsp");
			}
			
			else {
				// Get variable from book
				String bookID = request.getParameter("bookID");
				String title = request.getParameter("title");
				String author = request.getParameter("author");
				String rating = request.getParameter("rating");
				String price = request.getParameter("price");
				String category = request.getParameter("category");
				String releaseDate = request.getParameter("releaseDate");
				String isbnStrNum = request.getParameter("isbnStrNum");
				String quantity = request.getParameter("quantity").toString();
				String publisher = request.getParameter("publisher");
				String description = request.getParameter("description");
				
				try {
					// Insert SQL
					Class.forName("com.mysql.jdbc.Driver");
					String connURL = "jdbc:mysql://localhost/jad_bookstore_db?user=root&password=123456&serverTimezone=UTC";
					Connection conn = DriverManager.getConnection(connURL);
					String sqlStr = "INSERT INTO jad_bookstore_db.books(title, author, rating, price, category, releaseDate, isbnNumber, quantity, publisher, description) " + 
					"values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
					
					PreparedStatement pstmt = conn.prepareStatement(sqlStr);
					pstmt.setString(1, title);
					pstmt.setString(2, author);
					pstmt.setString(3, rating);
					pstmt.setDouble(4, Double.parseDouble(price));
					pstmt.setString(5, category);
					pstmt.setDate(6, java.sql.Date.valueOf(releaseDate));
					pstmt.setString(7, isbnStrNum);
					pstmt.setInt(8, Integer.parseInt(quantity));
					pstmt.setString(9, publisher);
					pstmt.setString(10, description);
					int rowInserted = pstmt.executeUpdate();
					
					System.out.println(rowInserted + " records inserted");
					response.sendRedirect("ca2/jsp/addBook.jsp?code=insertSuccess");
					
					conn.close(); 
				}
				
				catch (Exception e) {
					response.sendRedirect("ca2/jsp/addBook.jsp?code=insertError");
					System.out.println("Error :" + e);
				}
			}
		}
		
		// Delete function
		else if (bookFunction.equals("delete")) {
			if (cancel != null && cancel.equals("Return to admin page")) {
				response.sendRedirect("ca2/jsp/admin.jsp");
			}
			
			else {
				// Get variable from book
				String bookID = request.getParameter("bookID");
				
				try {
					// Delete SQL
					Class.forName("com.mysql.jdbc.Driver");
					String connURL = "jdbc:mysql://localhost/jad_bookstore_db?user=root&password=123456&serverTimezone=UTC";
					Connection conn = DriverManager.getConnection(connURL);
					String sqlStr = "DELETE FROM jad_bookstore_db.books WHERE idbooks = ?";
					PreparedStatement pstmt = conn.prepareStatement(sqlStr);
					pstmt.setString(1, bookID);
					int rowInserted = pstmt.executeUpdate();
					
					System.out.println(rowInserted + " records deleted");
					response.sendRedirect("ca2/jsp/addBook.jsp?code=bookDeleteSuccess");
					
					conn.close(); 
				}
				
				catch (Exception e) {
					response.sendRedirect("ca2/jsp/addBook.jsp?code=bookDeleteError");
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
