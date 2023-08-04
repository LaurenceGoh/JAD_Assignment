package order;


public class OrderDetail {
	private String bookName;
	private double orderPrice;
	private double tax;
	private double shipping;
	private double totalPrice;
	private int bookCounter;

	public OrderDetail(String bookName,String orderPrice,String shipping, String tax, String totalPrice, int bookCounter) {
		this.bookName = bookName;
		this.orderPrice = Double.parseDouble(orderPrice);
		this.shipping = Double.parseDouble(shipping);
		this.tax = Double.parseDouble(tax);
		this.totalPrice=Double.parseDouble(totalPrice);
		this.bookCounter=bookCounter;
	}
	
	public int getBookCounter() {
		return bookCounter;
	}

	public void setBookCounter(int bookCounter) {
		this.bookCounter = bookCounter;
	}

	public String getBookName() {
		return bookName;
	}

	public void setBookName(String bookName) {
		this.bookName = bookName;
	}

	public String getOrderPrice() {
		return String.format("%.2f",orderPrice);
	}

	public void setOrderPrice(double orderPrice) {
		this.orderPrice = orderPrice;
	}
	
	public String getTotalPrice() {
		return String.format("%.2f",totalPrice);
	}

	public void setTotalPrice(double totalPrice) {
		this.totalPrice = totalPrice;
	}
	
	public String getTax() {
		return String.format("%.2f",tax);
	}

	public void setTax(double tax) {
		this.tax = tax;
	}

	public String getShipping() {
		return String.format("%.2f",shipping);
	}

	public void setShipping(double shipping) {
		this.shipping = shipping;
	}
}
