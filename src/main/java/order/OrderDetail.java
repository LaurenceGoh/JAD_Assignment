package order;


public class OrderDetail {
	private String bookName;
	private double orderPrice;
	private double tax;
	private double shipping;
	private double totalPrice;

	public OrderDetail(String bookName,String orderPrice,String shipping, String tax, String totalPrice) {
		this.bookName = bookName;
		this.orderPrice = Double.parseDouble(orderPrice);
		this.shipping = Double.parseDouble(shipping);
		this.tax = Double.parseDouble(tax);
		this.totalPrice=Double.parseDouble(totalPrice);
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
