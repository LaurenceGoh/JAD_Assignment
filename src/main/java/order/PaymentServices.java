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
	public String authorizePayment(OrderDetail order) throws PayPalRESTException {
		
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
	
	private List<Transaction> getTransactionInformation(OrderDetail order){
//		System.out.println("Title of book in PaymentServices " + order.getBookName());
//		System.out.println("OrderPrice of the book in PaymentServices: " + order.getOrderPrice());
//		System.out.println("Shipping of the book in PaymentServices: " + order.getShipping());
//		System.out.println("Tax of the book in PaymentServices: " + order.getTax());
//		System.out.println("TotalPrice of the book in PaymentServices: " + order.getTotalPrice());
		
//
//		System.out.println(order.getTax());
//		System.out.println(order.getShipping());
//		System.out.println(order.getOrderPrice());
//		System.out.println(order.getTotalPrice());
		
		Details details = new Details();
		details.setShipping(order.getShipping());
		details.setSubtotal(order.getOrderPrice());
		details.setTax(order.getTax());
		
		Amount amount = new Amount();
		amount.setCurrency("USD");
		amount.setTotal(order.getTotalPrice());
		amount.setDetails(details);
				
		Transaction transaction = new Transaction();
		transaction.setAmount(amount);
		
		ItemList itemList = new ItemList();
		List<Item> items = new ArrayList<Item>();
		
		Item item = new Item();
		item.setCurrency("USD")
		.setName(order.getBookName())
		.setPrice(order.getOrderPrice())
		.setTax(order.getTax())
		.setQuantity("1");
		
		
		items.add(item);
		itemList.setItems(items);
		transaction.setItemList(itemList);
		
		List<Transaction> listTransaction = new ArrayList<>();
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
