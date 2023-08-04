package com.myshop.storews.controller;

import java.util.ArrayList;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.myshop.storews.dbaccess.Book;
import com.myshop.storews.dbaccess.BookDAO;

@RestController

public class BookController {
	
	@RequestMapping(method=RequestMethod.GET, path="/getOOSBooks")
	public ArrayList<Book> getOOSBooks() {
		ArrayList<Book> OOSBookList = new ArrayList<Book>();
		
		try {
			BookDAO db = new BookDAO();
			OOSBookList = db.listOOSBooks();
		}
		
		catch (Exception e) {
			System.out.println("Error: " + e);
		}
		
		return OOSBookList;
	}
}