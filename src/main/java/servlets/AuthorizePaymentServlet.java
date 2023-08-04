package servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import book.Book;
import order.OrderDetail;
import user.User;
import com.paypal.base.rest.*;
import com.paypal.api.payments.*;
import order.PaymentServices;
/**
 * Servlet implementation class CheckPaymentDetails
 */
@WebServlet("/AuthorizePayment")
public class AuthorizePaymentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AuthorizePaymentServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		OrderDetail order = null;
		ArrayList<OrderDetail> books = new ArrayList<OrderDetail>();
		@SuppressWarnings("unchecked")
		ArrayList<Book> orderedItems = (ArrayList<Book>) session.getAttribute("orderedItems");
//		retrieving book details to store in orderDetail arraylist
		for (Book bookName : orderedItems) {
			double bookPrice = bookName.getPrice();
			String bookTitle = bookName.getTitle();
			int bookCounter = bookName.getBookCounter();
			order = new OrderDetail(bookTitle,Double.toString(bookPrice),Double.toString(bookPrice*0.10),Double.toString(bookPrice*0.08),String.format("%.2f",bookPrice*1.18),bookCounter);
			books.add(order);
		}
		
		// retrieving user's details to store in User object
		String username = (String) session.getAttribute("username");
		User userDetails = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			String connURL = "jdbc:mysql://localhost/jad_bookstore_db?user=root&password=123456&serverTimezone=UTC";
			Connection conn = DriverManager.getConnection(connURL);
			String sqlStr = "SELECT * FROM jad_bookstore_db.user WHERE name=?";
			PreparedStatement pstmt = conn.prepareStatement(sqlStr);
			pstmt.setString(1, username);
			ResultSet rs = pstmt.executeQuery();
			if (rs.next()) {
				userDetails = new User(rs.getString("name"),rs.getString("lastname"),rs.getString("email"),rs.getString("address"),rs.getString("postcode"));
			}
		} catch(Exception e) {
            request.setAttribute("errorMessage", e.getMessage());
			request.getRequestDispatcher("ca2/jsp/error.jsp").forward(request, response);
		}
		try {
			 PaymentServices paymentServices = new PaymentServices();
	         String approvalLink = paymentServices.authorizePayment(books,userDetails);
	         response.sendRedirect(approvalLink);
             
        } catch (PayPalRESTException ex) {
            request.setAttribute("errorMessage", ex.getMessage());
            System.out.println("error in authorizePayment!");
            ex.printStackTrace();
            request.getRequestDispatcher("ca2/jsp/error.jsp").forward(request, response);
        }

		
//		ArrayList<Book> orderedItems = new ArrayList<Book>();
//		orderedItems.add(new Book("John", "Test", 0, totalPrice, totalPrice, "Image", "Author", "ReleaseDate", "Description", "ISBN", "Publisher"));
		
		
		
//		try {
//			 PaymentServices paymentServices = new PaymentServices();
//	         String approvalLink = paymentServices.authorizePayment(order);
//	         response.sendRedirect(approvalLink);
//             
//        } catch (PayPalRESTException ex) {
//            request.setAttribute("errorMessage", ex.getMessage());
//            System.out.println("error!");
//            ex.printStackTrace();
//            request.getRequestDispatcher("ca2/jsp/error.jsp").forward(request, response);
//        }
		
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
