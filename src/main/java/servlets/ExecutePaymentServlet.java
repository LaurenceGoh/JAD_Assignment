package servlets;

import java.io.IOException;
import java.sql.*;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.paypal.base.rest.*;
import com.paypal.api.payments.*;
import order.PaymentServices;
/**
 * Servlet implementation class ExecutePayment
 */
@WebServlet("/ExecutePayment")
public class ExecutePaymentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ExecutePaymentServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String paymentId = request.getParameter("paymentId");
		String payerId = request.getParameter("PayerID");
		
		System.out.println(payerId);
		System.out.println(paymentId);
		
		String username = request.getParameter("username");
		
		int bookId = 0, userId = 0, orderId = 0;
		double price=0;
		try {
			PaymentServices paymentServices = new PaymentServices();
			Payment payment = paymentServices.executePayment(paymentId, payerId);
			
			PayerInfo payerInfo = payment.getPayer().getPayerInfo();
			Transaction transaction = payment.getTransactions().get(0);
			
			// to get the list of items to be added to sql
			List <Item> items = (List<Item>) transaction.getItemList().getItems();
			System.out.println(items);
			for (int a=0;a<items.size();a++) {
				String bookName = items.get(a).getName();
				System.out.println("Book name : " + bookName);
				
				Class.forName("com.mysql.jdbc.Driver");
				String connURL = "jdbc:mysql://localhost/jad_bookstore_db?user=root&password=NZRong456&serverTimezone=UTC";
				Connection conn = DriverManager.getConnection(connURL);
				
//				Retrieving the book Id purchased
				String findBookId = "SELECT idbooks,price FROM jad_bookstore_db.books where title = ?";
				PreparedStatement pstmt = conn.prepareStatement(findBookId);
				pstmt.setString(1,bookName);
				ResultSet rs = pstmt.executeQuery();
				if (rs.next()) {
					bookId = rs.getInt("idbooks");
					price = rs.getDouble("price");
				}
				
//				Inserting book to orderlist table
				String insertBookIdToList = "INSERT INTO jad_bookstore_db.orderlist (idbooks,price) VALUES (?,?)";
				pstmt = conn.prepareStatement(insertBookIdToList, Statement.RETURN_GENERATED_KEYS);
				pstmt.setInt(1, bookId);
				pstmt.setDouble(2, price);
				int updatedRows = pstmt.executeUpdate();
				System.out.println("Number of rows added to orderlist table : " + updatedRows);
				
//				Retrieving new orderlist table id
				rs = pstmt.getGeneratedKeys();
				if (rs.next()) {
					orderId = rs.getInt(1);		
					System.out.println("New orderlist table with Id of " + orderId);
				}
				
//				Retrieving customer's id
				String findCustomerId = "SELECT iduser FROM jad_bookstore_db.user WHERE name = ?";
				pstmt = conn.prepareStatement(findCustomerId);
				pstmt.setString(1,username);
				rs = pstmt.executeQuery();
				if (rs.next()){
					userId = rs.getInt("iduser");
					System.out.println("Retrieved userId of " + userId);
				}
//				Inserting orderlist Id & customer's Id to order table
				String insertOrder = "INSERT INTO jad_bookstore_db.order (iduser,idorder) VALUES (?,?)";
				pstmt = conn.prepareStatement(insertOrder, Statement.RETURN_GENERATED_KEYS);
				pstmt.setInt(1, userId);
				pstmt.setInt(2, orderId);
				updatedRows = pstmt.executeUpdate();
				
				rs = pstmt.getGeneratedKeys();
				if (rs.next()) {
					System.out.println("New order table with Id of " + rs.getInt(1));
				}
			 	
			}
			
			request.setAttribute("payer",payerInfo);
			request.setAttribute("transaction", transaction);

			request.getRequestDispatcher("ca2/jsp/receipt.jsp").forward(request,response);
		} catch (PayPalRESTException e) {
			request.setAttribute("errorMessage", e.getMessage());
            System.out.println("error in executePayment!");
            e.printStackTrace();
            request.getRequestDispatcher("ca2/jsp/error.jsp").forward(request, response);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
