package servlets;

import java.io.IOException;
import java.sql.*;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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
		
		HttpSession session = request.getSession();

		
		System.out.println(payerId);
		System.out.println(paymentId);
		
		String username = request.getParameter("username");
		
		int bookId = 0, userId = 0, orderId = 0, userOrderNo=0;
		double price=0;
		Timestamp orderDate=null;
		try {
			PaymentServices paymentServices = new PaymentServices();
			Payment payment = paymentServices.executePayment(paymentId, payerId);
			
			PayerInfo payerInfo = payment.getPayer().getPayerInfo();
			Transaction transaction = payment.getTransactions().get(0);
			
			
			Class.forName("com.mysql.jdbc.Driver");
			String connURL = "jdbc:mysql://localhost/jad_bookstore_db?user=root&password=NZRong456&serverTimezone=UTC";
			Connection conn = DriverManager.getConnection(connURL);
			
			//getting user's order number
			String findUserOrderNo = "SELECT orderNo from jad_bookstore_db.user WHERE name = ?";
			PreparedStatement pstmt = conn.prepareStatement(findUserOrderNo);
			pstmt.setString(1,username);
			ResultSet rs = pstmt.executeQuery();
			if (rs.next()) {
				userOrderNo = rs.getInt("orderNo");
				//increment order number 
				userOrderNo +=1;
			}
			System.out.println(userOrderNo);
			// to get the list of items to be added to sql
			List <Item> items = (List<Item>) transaction.getItemList().getItems();
			System.out.println(items);
			for (int a=0;a<items.size();a++) {
				String bookName = items.get(a).getName();
				int quantity = Integer.parseInt(items.get(a).getQuantity());
				int booksQuantity = 0;
				System.out.println("Book name : " + bookName);
				System.out.println("Quantity : " + quantity);
				
//				Retrieving the book Id purchased
				String findBookId = "SELECT idbooks,price,quantity FROM jad_bookstore_db.books where title = ?";
				pstmt = conn.prepareStatement(findBookId);
				pstmt.setString(1,bookName);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					bookId = rs.getInt("idbooks");
					price = rs.getDouble("price");
					booksQuantity = rs.getInt("quantity");
				}
				int newQuantityValue =  booksQuantity-quantity;
//				Update item Quantity in books table
				String updateBookQuantity = "UPDATE jad_bookstore_db.books SET quantity = ? , unitsSold = ? WHERE title = ?";
				pstmt = conn.prepareStatement(updateBookQuantity);
				pstmt.setInt(1,newQuantityValue);
				pstmt.setInt(2, quantity);
				pstmt.setString(3, bookName);
				int updatedQuantity = pstmt.executeUpdate();
				System.out.println("Updated books rows :" + updatedQuantity);
				
				
//				Inserting book to orderlist table
				String insertBookIdToList = "INSERT INTO jad_bookstore_db.orderlist (idbooks,price,orderNo,bookquantity) VALUES (?,?,?,?)";
				pstmt = conn.prepareStatement(insertBookIdToList, Statement.RETURN_GENERATED_KEYS);
				pstmt.setInt(1, bookId);
				pstmt.setDouble(2, price);
				pstmt.setInt(3, userOrderNo);
				pstmt.setInt(4, quantity);
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
				
//				getting current date;
				String getOrderedDate = "SELECT CURRENT_TIMESTAMP";
				pstmt = conn.prepareStatement(getOrderedDate);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					orderDate=rs.getTimestamp("CURRENT_TIMESTAMP");
					System.out.println(orderDate.toString());
				}
				
//				Inserting orderlist Id & customer's Id to order table
				String insertOrder = "INSERT INTO jad_bookstore_db.order (iduser,idorder,orderNo,dateOrder) VALUES (?,?,?,?)";
				pstmt = conn.prepareStatement(insertOrder, Statement.RETURN_GENERATED_KEYS);
				pstmt.setInt(1, userId);
				pstmt.setInt(2, orderId);
				pstmt.setInt(3, userOrderNo);
				pstmt.setTimestamp(4, orderDate);
				updatedRows = pstmt.executeUpdate();
				
				rs = pstmt.getGeneratedKeys();
				if (rs.next()) {
					System.out.println("New order table with Id of " + rs.getInt(1));
				}
			 	
			}
			
			// update user table's orderNo
			String updateOrderNo = "UPDATE jad_bookstore_db.user SET orderNo = ? WHERE name = ?";
			pstmt = conn.prepareStatement(updateOrderNo);
			pstmt.setInt(1,userOrderNo);
			pstmt.setString(2, username);
			int updatedUserTableRows = pstmt.executeUpdate();
			System.out.println("Number of rows updated in user table : " + updatedUserTableRows);
			
			conn.close();
			session.setAttribute("payer",payerInfo);
			session.setAttribute("transaction", transaction);

//			request.getRequestDispatcher("ca2/jsp/receipt.jsp").forward(request,response);
			response.sendRedirect("ca2/jsp/receipt.jsp");
			
		} catch (PayPalRESTException e) {
			session.setAttribute("errorMessage", e.getMessage());
            System.out.println("error in executePayment!");
            e.printStackTrace();
            response.sendRedirect("ca2/jsp/error.jsp");
//            request.getRequestDispatcher("ca2/jsp/error.jsp").forward(request, response);
		} catch (ClassNotFoundException e) {
			session.setAttribute("errorMessage", e.getMessage());
            System.out.println("error in executePayment!");
            e.printStackTrace();
            response.sendRedirect("ca2/jsp/error.jsp");
//            request.getRequestDispatcher("ca2/jsp/error.jsp").forward(request, response);
		} catch (SQLException e) {
			session.setAttribute("errorMessage", e.getMessage());
            System.out.println("error in executePayment!");
            e.printStackTrace();
            response.sendRedirect("ca2/jsp/error.jsp");
//            request.getRequestDispatcher("ca2/jsp/error.jsp").forward(request, response);
		}
	}

}
