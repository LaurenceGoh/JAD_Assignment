package servlets;

import java.io.IOException;


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
		
		try {
			PaymentServices paymentServices = new PaymentServices();
			Payment payment = paymentServices.executePayment(paymentId, payerId);
			
			System.out.println(payment);
			
			PayerInfo payerInfo = payment.getPayer().getPayerInfo();
			Transaction transaction = payment.getTransactions().get(0);
			
			request.setAttribute("payer",payerInfo);
			request.setAttribute("transaction", transaction);

			request.getRequestDispatcher("ca2/jsp/receipt.jsp").forward(request,response);
		} catch (PayPalRESTException e) {
			request.setAttribute("errorMessage", e.getMessage());
            System.out.println("error in executePayment!");
            e.printStackTrace();
            request.getRequestDispatcher("ca2/jsp/error.jsp").forward(request, response);
		}
	}

}
