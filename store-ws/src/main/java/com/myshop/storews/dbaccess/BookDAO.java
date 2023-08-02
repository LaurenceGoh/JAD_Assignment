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
				bookList.add(uBean);
			}
		}
		
		catch (Exception e) {
			System.out.println(". . . . . . . . . . . . . .Error:" + e);
		}
		return bookList;
	}
}