package com.myshop.storews.dbaccess;
import java.sql.*;
import java.util.ArrayList;

public class BookDAO {
	Book uBean = null;
	Connection conn = null;
	
	public ArrayList<Book> listOOSBooks() throws SQLException {
		String bookID;
		String title;
		int quantity;
		
		ArrayList<Book> bookList = new ArrayList<Book>();
		
		try {
			conn = DBConnection.getConnection();
			Statement stmt = conn.createStatement();
			String sqlStr = "SELECT * FROM jad_bookstore_db.books WHERE quantity = 0";
			ResultSet rs = stmt.executeQuery(sqlStr);
			
			while (rs.next()) {
				uBean = new Book();
				uBean.setBookID(rs.getString("idbooks"));
				uBean.setQuantity(rs.getInt("quantity"));
				uBean.setTitle(rs.getString("title"));	
				uBean.setCategory(rs.getString("category"));
				uBean.setRating(rs.getString("rating"));
				uBean.setImage(rs.getString("image"));
				uBean.setAuthor(rs.getString("author"));
				uBean.setReleaseDate(rs.getDate("releaseDate").toString());
				uBean.setPublisher(rs.getString("publisher"));
				uBean.setDescription(rs.getString("description"));
				uBean.setIsbnNum(rs.getString("isbnNumber"));
				uBean.setUnitSold(rs.getInt("unitsSold"));
				bookList.add(uBean);
			}
		}
		
		catch (Exception e) {
			System.out.println(". . . . . . . . . . . . . .Error:" + e);
		}
		return bookList;
	}
	
	public int updateBookStock(String bookID, int quantity) throws SQLException, ClassNotFoundException {
		Connection conn = null;
		int nrow = 0;
		
		try {
			conn = DBConnection.getConnection();
			String sqlStr = "UPDATE books SET quantity = ? WHERE idbooks = ?";
			PreparedStatement pstmt = conn.prepareStatement(sqlStr);
			pstmt.setInt(1, quantity);
			pstmt.setString(2, bookID);
			nrow = pstmt.executeUpdate();
		}
		
		catch (SQLException e) {
			e.printStackTrace();
		}
		
		return nrow;
	}
	
	public int deleteBook(String bid) throws SQLException {
		Connection conn = null;
		int nrow = 0;
		
		try {
			conn = DBConnection.getConnection();
			String sqlStr = "DELETE FROM books WHERE idbooks = ?";
			PreparedStatement pstmt = conn.prepareStatement(sqlStr);
			pstmt.setString(1, bid);
			nrow = pstmt.executeUpdate();
		}
		
		catch (SQLException e) {
			e.printStackTrace();
		}
		
		return nrow;
	}
	
	public int insertBook(String title, String category, int quantity, String rating, double price, String author, String releaseDate, String isbnNum, String publisher, String description) throws SQLException, ClassNotFoundException {
		Connection conn = null;
		int nrow = 0;
		
		try {
			conn = DBConnection.getConnection();
			String sqlStr = "INSERT INTO books (title, category, quantity, rating, price, author, releaseDate, isbnNumber, publisher, description)"
					+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			PreparedStatement pstmt = conn.prepareStatement(sqlStr);
			pstmt.setString(1, title);
			pstmt.setString(2, category);
			pstmt.setInt(3, quantity);
			pstmt.setString(4, rating);
			pstmt.setDouble(5, price);
			pstmt.setString(6, author);
			pstmt.setDate(7, java.sql.Date.valueOf(releaseDate));
			pstmt.setString(8, isbnNum);
			pstmt.setString(9, publisher);
			pstmt.setString(10, description);
			nrow = pstmt.executeUpdate();
		}
		
		catch (SQLException e) {
			e.printStackTrace();
		}
		
		return nrow;
	}
}