package servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import order.PaymentServices;
import com.paypal.api.payments.*;
import com.paypal.base.rest.PayPalRESTException;

/**
 * Servlet implementation class ReviewPayment
 */
@WebServlet("/ReviewPayment")
public class ReviewPaymentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ReviewPaymentServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String paymentID = request.getParameter("paymentId");
		String payerID = request.getParameter("PayerID");
		
		
		try {
			PaymentServices paymentServices = new PaymentServices();
			Payment payment = paymentServices.getPaymentDetails(paymentID);
			
			PayerInfo payerInfo = payment.getPayer().getPayerInfo();
			System.out.println(payment.getTransactions());
			Transaction transaction = payment.getTransactions().get(0);
			ShippingAddress shippingAddress = transaction.getItemList().getShippingAddress();
			
			request.setAttribute("payer",payerInfo);
			request.setAttribute("transaction", transaction);
			request.setAttribute("shippingAddress",shippingAddress);
			
			String url = "ca2/jsp/review.jsp?paymentId=" + paymentID + "&PayerID=" + payerID;
			request.getRequestDispatcher(url).forward(request, response);
			
		} catch (PayPalRESTException e) {
			request.setAttribute("errorMessage", "Unable to get payment details.");
	        System.out.println("error in reviewPayment!!");
	        e.printStackTrace();
	        request.getRequestDispatcher("ca2/jsp/error.jsp").forward(request, response);
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
