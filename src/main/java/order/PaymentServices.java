package order;

import java.util.*;
import com.paypal.api.payments.*;
import com.paypal.base.rest.*;

import book.Book;
import user.User;
public class PaymentServices {
	private static final String CLIENT_ID = "AV9MqXB0H2TNDSf-hNjfQFgs316-vy1wMo6BM8DXTsqWECEBY24mvFX5L3Er34CrW9jMQVCuK7UjTZ36";
	private static final String CLIENT_SECRET = "EHVACwZfBNVSj-14qfoUsHb01a0TSMk_P5uSoTk04xbmcKDie2Lnad87IJGD7G3riGttmVysnKljKwDf";
	private static final String MODE = "sandbox";
	
	public PaymentServices() {
		
	}
	//multiple orders
	
public String authorizePayment(ArrayList<OrderDetail> order, User userDetails) throws PayPalRESTException {
		
		Payer payer = getPayerInformation(userDetails);
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
		
		
		double subtotal = 0, shipping=0, tax=0, total=0 ;
		
		for (OrderDetail books : order) {
			int bookCounter = 0,count=0;
			double sameBookPrice=0,sameBookTax=0;
			bookCounter = books.getBookCounter();
			
			Item item = new Item();
			amount.setCurrency("USD");
			item.setCurrency("USD")
			.setName(books.getBookName())
			.setQuantity(Integer.toString(bookCounter));
			// if booklist contains multiple book of the same bookname
			while (count<bookCounter) {
				
				//for item object
				sameBookPrice =  Double.parseDouble(books.getOrderPrice());
				sameBookTax = Double.parseDouble(books.getTax());
				
				//for amount object
				subtotal += Double.parseDouble(books.getOrderPrice());
				shipping += Double.parseDouble(books.getShipping());
				tax += Double.parseDouble(books.getTax());
				total += Double.parseDouble(books.getTotalPrice());		
				
				count++;
			}
			item.setPrice(Double.toString(sameBookPrice))
			.setTax(Double.toString(sameBookTax));

			items.add(item);			
			// for whole booklist
				
		}
		Details details = new Details();
		details.setShipping(String.format("%.2f", shipping));
		details.setSubtotal(String.format("%.2f", subtotal));
		details.setTax(String.format("%.2f", tax));
		amount.setDetails(details);
		amount.setTotal(String.format("%.2f", total));
		 
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
	
	private Payer getPayerInformation(User userDetails) {
		
		Payer payer = new Payer();
		payer.setPaymentMethod("paypal");
		
		Address userAddress = new Address();
		userAddress.setLine1(userDetails.getAddress());
		userAddress.setPostalCode(userDetails.getPostcode());
		userAddress.setCountryCode("SG");
		
		PayerInfo payerInfo = new PayerInfo();
		payerInfo
		.setFirstName(userDetails.getName())
		.setLastName(userDetails.getLastname())
		.setEmail(userDetails.getEmail())
		.setBillingAddress(userAddress);

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
