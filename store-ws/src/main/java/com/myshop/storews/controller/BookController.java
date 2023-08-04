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
	
	@RequestMapping(path = "/updateBookStock/{bid}", consumes = "application/json", method = RequestMethod.PUT)
	public int updateBookStock(@PathVariable String bid, @RequestBody Book book) {
		int rec = 0;
		
		try {
			BookDAO db = new BookDAO();
			int uQuantity = book.getQuantity();
			rec = db.updateBookStock(bid, uQuantity);
			System.out.println("...in BookController-done update book.." + rec);
		}
		
		catch (Exception e) {
			System.out.println(e.toString());
		}
		
		return rec;
	}
	
	@RequestMapping(path = "/deleteBook/{bid}", method = RequestMethod.DELETE)
	public int deleteBook(@PathVariable String bid) {
		int rec = 0;
		
		try {
			BookDAO db = new BookDAO();
			rec = db.deleteBook(bid);
			System.out.println("...in BookController-done deleting book.." + rec);
		}
		
		catch (Exception e) {
			System.out.println(e.toString());
		}
		
		return rec;
	}
	
	@RequestMapping(path="/createBook", consumes="application/json", method = RequestMethod.POST)
	public int createBook(@RequestBody Book book) {
		int rec = 0;
		
		try {
			BookDAO db = new BookDAO();
			String uTitle = book.getTitle();
			String uCategory = book.getCategory();
			int uQuantity = book.getQuantity();
			String uRating = book.getRating();
			double uPrice = book.getPrice();
			String uAuthor = book.getAuthor();
			String uReleaseDate = book.getReleaseDate();
			String uIsbnNum = book.getIsbnNum();
			String uPublisher = book.getPublisher();
			String uDescription = book.getDescription();
			rec = db.insertBook(uTitle, uCategory, uQuantity, uRating, uPrice, uAuthor, uReleaseDate, uIsbnNum, uPublisher, uDescription);
		}
		
		catch (Exception e) {
			System.out.println(e.toString());
			e.printStackTrace();
		}
		
		return rec;
	}
}