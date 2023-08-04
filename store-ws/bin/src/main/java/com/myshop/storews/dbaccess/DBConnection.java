package com.myshop.storews.dbaccess;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
	public static Connection getConnection() {
		String dbUrl = "jdbc:mysql://localhost/jad_bookstore_db";
		String dbUser = "root";
		String dbPassword = "NZRong456";
		String dbClass = "com.mysql.cj.jdbc.Driver";
		
		Connection connection = null;
		
		try {
			Class.forName(dbClass);
		}
		
		catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		
		try {
			connection = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
		}
		
		catch (SQLException e) {
			e.printStackTrace();
		}
		return connection;
	}
}