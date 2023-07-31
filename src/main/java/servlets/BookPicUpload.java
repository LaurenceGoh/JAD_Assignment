package servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

/**
 * Servlet implementation class BookPicUpload
 */
@WebServlet(name = "BookPicUpload", urlPatterns = { "/fileuploadservlet" })
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
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//doGet(request, response);

		String bookID = request.getParameter("bookID");
		boolean isUploaded = false;

		Part filePart = request.getPart("file");
		String fileName = filePart.getSubmittedFileName();

		for (Part part : request.getParts()) {
			part.write("ca2/img/" + fileName);
		}

		response.getWriter().print("The file uploaded sucessfully.");
		isUploaded = true;

		if (isUploaded) {
			try {
				Class.forName("com.mysql.jdbc.Driver");
				String connURL = "jdbc:mysql://localhost/jad_bookstore_db?user=root&password=123456&serverTimezone=UTC";
				Connection conn = DriverManager.getConnection(connURL);
				String sqlStr = "UPDATE books SET image = ? WHERE idbooks = ?";
				PreparedStatement pstmt = conn.prepareStatement(sqlStr);
				pstmt.setString(1, fileName);
				int rowInserted = pstmt.executeUpdate();
				
				System.out.println(rowInserted + " records edited");
				response.sendRedirect("ca2/jsp/editBookPic.jsp?code=bookEditSuccess");
				
				conn.close(); 
			}
			
			catch (Exception e){
				response.sendRedirect("ca2/jsp/editBookPic.jsp?code=picEditError");
				System.out.println("Error :" + e);
			}
		}
		
		else {
			
		}
	}
}
