package servlets;

import java.sql.*;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dbaccess.Book;

import java.util.*;
/**
 * Servlet implementation class GetPurchaseHistory
 */
@WebServlet("/GetPurchaseHistory")
public class GetPurchaseHistory extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetPurchaseHistory() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		
		
		String username = (String) session.getAttribute("username");
		String bookName ="", author = "", image="";
		int orderNum = 0,orderCount=1, userId = 0, bookId = 0, bookQuantity =0, previousOrderId=0;
		double purchasedPrice =0;
		
		ArrayList<ArrayList<Book>> orderList = new ArrayList<ArrayList<Book>>();
		ArrayList<Integer> orderNumber = new ArrayList<Integer>();
		Timestamp orderDate = null;
		
		
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			String connURL = "jdbc:mysql://localhost/jad_bookstore_db?user=root&password=NZRong456&serverTimezone=UTC";
			Connection conn = DriverManager.getConnection(connURL);
			
			// get user id & order count
			String getUser = "SELECT orderNo,iduser FROM jad_bookstore_db.user WHERE name = ?";
			PreparedStatement pstmt = conn.prepareStatement(getUser);
			pstmt.setString(1, username);
			ResultSet rs = pstmt.executeQuery();
			
			if (rs.next()) {
				orderNum = rs.getInt("orderNo");
				userId = rs.getInt("iduser");
			}
		
			// get id order based on user id
			// loop through each order number (orderNo 5 will be in 1 arraylist of book datatype, & stored in orderList)
			while (orderCount <= orderNum) {
				
				ArrayList<Book> purchasedBooks = new ArrayList<Book>();
				
				System.out.println("Current order Counter: " + orderCount + "\n");
				orderNumber.add(orderCount);
				String getOrderId = "SELECT * FROM jad_bookstore_db.order INNER JOIN jad_bookstore_db.orderlist ON jad_bookstore_db.order.idorder = jad_bookstore_db.orderlist.idorder WHERE jad_bookstore_db.order.iduser = ? AND jad_bookstore_db.order.orderNo = ?";
				pstmt = conn.prepareStatement(getOrderId);
				pstmt.setInt(1,userId);
				pstmt.setInt(2, orderCount);
				rs = pstmt.executeQuery();
				previousOrderId = orderCount;
				while (rs.next()) {
					
					
					int bookQuantityCounter=0;
					bookId = rs.getInt("idbooks");
					purchasedPrice = rs.getDouble("price");
					orderDate = rs.getTimestamp("dateOrder");
					bookQuantity = rs.getInt("bookquantity");
					int orderNo = rs.getInt("orderNo");
					System.out.println(orderNo);
					
					// getting book details
					String getBookName = "SELECT * from jad_bookstore_db.books where idbooks = ?";
					PreparedStatement titleStmt = conn.prepareStatement(getBookName);
					titleStmt.setInt(1, bookId);
					ResultSet titleResult = titleStmt.executeQuery();
					if (titleResult.next()) {
						bookName = titleResult.getString("title");
						
						System.out.println("Retrieved book of title " + bookName);

						author = titleResult.getString("author");
						image = titleResult.getString("image");
					}
					
					Book purchasedBook = new Book(bookName,"",0,0,purchasedPrice,image,author,"","","","",bookQuantity,orderDate);
					// For books that have more than 1 quantity
					System.out.println("Current book quantity counter: " + bookQuantityCounter);

					System.out.println("Current book quantity: " + bookQuantity);
					
					while (bookQuantityCounter < bookQuantity) {
						purchasedBooks.add(purchasedBook);
						bookQuantityCounter++;
					}
					
					
					System.out.println("Contents in purchasedBook : " + purchasedBooks + "\n");
					
					
				}
				orderList.add(purchasedBooks);
				
				System.out.println("Contents in orderList : " + orderList + "\n");
				orderCount++;
				
				
			}
			// if any arraylist is empty
			orderList.removeIf(ArrayList::isEmpty);
			session.setAttribute("orderNumber", orderNumber);
			session.setAttribute("purchasedBookList",orderList);
			response.sendRedirect("ca2/jsp/purchaseHistory.jsp");
			
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
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
