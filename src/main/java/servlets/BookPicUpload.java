package servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

/**
 * Servlet implementation class BookPicUpload
 */
@WebServlet("/BookPicUpload")
@MultipartConfig(
		  fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
		  maxFileSize = 1024 * 1024 * 10,      // 10 MB
		  maxRequestSize = 1024 * 1024 * 100   // 100 MB
		)
public class BookPicUpload extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BookPicUpload() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		HttpSession session = request.getSession();
		String bookID = session.getAttribute("bookID").toString();
		boolean isUploaded = false;
		String fileName = "";

		try {
			Part filePart = request.getPart("bookPic");
			fileName = filePart.getSubmittedFileName();

			for (Part part : request.getParts()) {
//				part.write(getServletContext().getRealPath("") + "\\ca2\\img\\" + fileName);
				part.write("C:\\Users\\ngzhi\\git\\JAD_Assignment\\src\\main\\webapp\\ca2\\img\\" + fileName);
			}

			isUploaded = true;
		}
		
		catch (Exception f) {
			System.out.println("Error :" + f);
		}
		
		if (isUploaded) {
			try {
				Class.forName("com.mysql.jdbc.Driver");
				String connURL = "jdbc:mysql://localhost/jad_bookstore_db?user=root&password=NZRong456&serverTimezone=UTC";
				Connection conn = DriverManager.getConnection(connURL);
				String sqlStr = "UPDATE books SET image = ? WHERE idbooks = ?";
				PreparedStatement pstmt = conn.prepareStatement(sqlStr);
				pstmt.setString(1, fileName);
				pstmt.setString(2,  bookID);
				int rowInserted = pstmt.executeUpdate();
				
				System.out.println(rowInserted + " records edited");
				
				conn.close(); 
				response.sendRedirect("ca2/jsp/admin.jsp?code=userEditSuccess");
			}
			
			catch (Exception e){
				System.out.println("Error :" + e);
			}
		}
		
		else {
			response.sendRedirect("ca2/jsp/admin.jsp?code=picEditError");
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}
}
