package user;

public class User {
	private String name,lastname,email,address,postalCode="";
	
	public User(String name, String lastname,String email,String address,String postcode) {
		this.name = name;
		this.lastname = lastname;
		this.email= email;
		this.address = address;
		this.postalCode=postcode;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getLastname() {
		return lastname;
	}

	public void setLastname(String lastname) {
		this.lastname = lastname;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getPostcode() {
		return postalCode;
	}

	public void setPostcode(String postcode) {
		this.postalCode = postcode;
	}
	
	
}
