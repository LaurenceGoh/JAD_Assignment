package order;

import java.util.*;
import com.paypal.api.payments.*;
import com.paypal.base.rest.*;

import book.Book;

public class PaymentServices {
	private static final String CLIENT_ID = "AV9MqXB0H2TNDSf-hNjfQFgs316-vy1wMo6BM8DXTsqWECEBY24mvFX5L3Er34CrW9jMQVCuK7UjTZ36";
	private static final String CLIENT_SECRET = "EHVACwZfBNVSj-14qfoUsHb01a0TSMk_P5uSoTk04xbmcKDie2Lnad87IJGD7G3riGttmVysnKljKwDf";
	private static final String MODE = "sandbox";
	
	public PaymentServices() {
		
	}
	//Single order
//	public String authorizePayment(OrderDetail order) throws PayPalRESTException {
//		
//		Payer payer = getPayerInformation();
//        RedirectUrls redirectUrls = getRedirectUrls();
//        List<Transaction> listTransaction = getTransactionInformation(order);
//         
//        Payment requestPayment = new Payment();
//        requestPayment.setTransactions(listTransaction);
//        requestPayment.setRedirectUrls(redirectUrls);
//        requestPayment.setPayer(payer);
//        requestPayment.setIntent("authorize");
//        
//        System.out.println(requestPayment);
//        APIContext apiContext = new APIContext(CLIENT_ID, CLIENT_SECRET, MODE);
//        Payment approvedPayment = requestPayment.create(apiContext);
//        return getApprovalLink(approvedPayment);
//	}
	// for 1 singular order
//	private List<Transaction> getTransactionInformation(OrderDetail order){
//		
//		Details details = new Details();
//		details.setShipping(order.getShipping());
//		details.setSubtotal(order.getOrderPrice());
//		details.setTax(order.getTax());
//		
//		Amount amount = new Amount();
//		amount.setCurrency("USD");
//		amount.setTotal(order.getTotalPrice());
//		amount.setDetails(details);
//				
//		Transaction transaction = new Transaction();
//		transaction.setAmount(amount);
//		
//		ItemList itemList = new ItemList();
//		List<Item> items = new ArrayList<Item>();
//		
//		Item item = new Item();
//		item.setCurrency("USD")
//		.setName(order.getBookName())
//		.setPrice(order.getOrderPrice())
//		.setTax(order.getTax())
//		.setQuantity("1");
//		
//		
//		items.add(item);
//		itemList.setItems(items);
//		transaction.setItemList(itemList);
//		
//		List<Transaction> listTransaction = new ArrayList<>();
//		listTransaction.add(transaction);
//		
//		return listTransaction;
//	}
	//multiple orders
	
public String authorizePayment(ArrayList<OrderDetail> order) throws PayPalRESTException {
		
		Payer payer = getPayerInformation();
        RedirectUrls redirectUrls = getRedirectUrls();
        List<Transaction> listTransaction = getTransactionInformation(order);
         
        Payment requestPayment = new Payment();
        requestPayment.setTransactions(listTransaction);
        requestPayment.setRedirectUrls(redirectUrls);
        requestPayment.setPayer(payer);
        requestPayment.setIntent("authorize");
        
        System.out.println(requestPayment);
        APIContext apiContext = new APIContext(CLIENT_ID, CLIENT_SECRET, MODE);
        Payment approvedPayment = requestPayment.create(apiContext);
        return getApprovalLink(approvedPayment);
	}
	
	private List<Transaction> getTransactionInformation(ArrayList<OrderDetail> order){
		List<Transaction> listTransaction = new ArrayList<>();
		Transaction transaction = new Transaction();
		ItemList itemList = new ItemList();
		List<Item> items = new ArrayList<Item>();
		Amount amount = new Amount();
		
		
		double subtotal = 0, shipping=0, tax=0, total=0;
		for (OrderDetail books : order) {
			Item item = new Item();
			amount.setCurrency("USD");
			item.setCurrency("USD")
			.setName(books.getBookName())
			.setPrice(books.getOrderPrice())
			.setTax(books.getTax())
			.setQuantity("1");
			items.add(item);			
			subtotal += Double.parseDouble(books.getOrderPrice());
			shipping += Double.parseDouble(books.getShipping());
			tax += Double.parseDouble(books.getTax());
			total += Double.parseDouble(books.getTotalPrice());			
		}
		Details details = new Details();
		details.setShipping(Double.toString(shipping));
		details.setSubtotal(Double.toString(subtotal));
		details.setTax(Double.toString(tax));
		amount.setDetails(details);
		amount.setTotal(Double.toString(total));
		 
		itemList.setItems(items);
		transaction.setAmount(amount);
		
		transaction.setItemList(itemList);
		
		listTransaction.add(transaction);
		
		return listTransaction;
	}
	private RedirectUrls getRedirectUrls() {
		RedirectUrls redirectUrls = new RedirectUrls();
		redirectUrls.setCancelUrl("http://localhost:8080/JAD_CA2/ca2/jsp/index.jsp");
		redirectUrls.setReturnUrl("http://localhost:8080/JAD_CA2/ReviewPayment");
		
		return redirectUrls;
	}
	
	public Payment getPaymentDetails(String paymentId) throws PayPalRESTException {
		APIContext apiContext = new APIContext(CLIENT_ID,CLIENT_SECRET,MODE);
		return Payment.get(apiContext, paymentId);
	}
	
	public Payment executePayment(String paymentId, String payerId) throws PayPalRESTException {
		PaymentExecution paymentExecution = new PaymentExecution();
		paymentExecution.setPayerId(payerId);
		
		Payment payment = new Payment().setId(paymentId);
		
		APIContext apiContext = new APIContext(CLIENT_ID,CLIENT_SECRET,MODE);
		return payment.execute(apiContext, paymentExecution);
	}
	
	private Payer getPayerInformation() {
		Payer payer = new Payer();
		payer.setPaymentMethod("paypal");
		
		PayerInfo payerInfo = new PayerInfo();
		payerInfo.setFirstName("John").setLastName("Tan").setEmail("johntan@gmail.com");
//		payerInfo.setFirstName(firstName).setLastName(lastName).setEmail(email);
//		sql statement to get current user's details

		payer.setPayerInfo(payerInfo);
		
		return payer;
	}
	
	private String getApprovalLink(Payment approvedPayment) {
	    List<Links> links = approvedPayment.getLinks();
	    String approvalLink = null;
	     
	    for (Links link : links) {
	        if (link.getRel().equalsIgnoreCase("approval_url")) {
	            approvalLink = link.getHref();
	            break;
	        }
	    }      
	     
	    return approvalLink;
	}
}
