package book;

public class Book {
	
	
	private double rating;
	private String author;
	private String title;
	private int quantity;
	private double price;
	private String image;
	private String releaseDate;
	private String isbnStrNumber;
	private String publisher;
	private String description;
	private String category;

	
	public Book(String title,String category, int quantity, double rating, double price, String image, String author, String releaseDate, String isbnStrNumber, String publisher, String description) {
		this.title = title;
		this.category = category;
		this.quantity = quantity;
		this.rating = rating;
		this.price = price;
		this.image = image;
		this.author = author;
		this.releaseDate = releaseDate;
		this.isbnStrNumber = isbnStrNumber;
		this.publisher = publisher;
		this.description = description;
	}
	
	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public double getRating() {
		return rating;
	}

	public void setRating(double rating) {
		this.rating = rating;
	}

	public String getAuthor() {
		return author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public String getReleaseDate() {
		return releaseDate;
	}

	public void setReleaseDate(String releaseDate) {
		this.releaseDate = releaseDate;
	}

	public String getisbnStrNumber() {
		return isbnStrNumber;
	}

	public void setisbnStrNumber(String isbnStrNumber) {
		this.isbnStrNumber = isbnStrNumber;
	}

	public String getPublisher() {
		return publisher;
	}

	public void setPublisher(String publisher) {
		this.publisher = publisher;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}
	
	
}
