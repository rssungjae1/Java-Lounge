<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDTO"%>
<%@ page import="user.UserDAO"%>
<%@ page import="utill.SHA256"%>
<%@ page import="java.io.PrintWriter"%>
<%
	request.setCharacterEncoding("UTF-8");
	String userID = null;
	String userPassword = null;
	String userEmail = null;
	if (request.getParameter("userID") != null) {
		userID = request.getParameter("userID");
	}
	if (request.getParameter("userPassword") != null) {
		userPassword = request.getParameter("userPassword");
	}
	if (request.getParameter("userEmail") != null) {
		userEmail = request.getParameter("userEmail");
	}
	if (userID == null || userPassword == null || userEmail == null || userID.equals("") || userEmail.equals("")
			|| userPassword.equals("")) {
		PrintWriter script = response.getWriter();
		script.println("<script>;");
		script.println("alert('입력이 안 된 사항이 있습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	UserDAO userDAO = new UserDAO();
	int result = userDAO.joins(new UserDTO(userID, userPassword, userEmail, SHA256.getSHA256(userEmail), false));
	if (result == -1) {
		PrintWriter script = response.getWriter();
		script.println("<script>;");
		script.println("alert('userID"+userID+"');");
		script.println("alert('userPassword"+userPassword+"');");
		script.println("alert('userEmail"+userEmail+"');");
		script.println("alert('이미 존재하는 아이디입니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else {
		session.setAttribute("userID", userID);
		PrintWriter script = response.getWriter();
		script.println("<script>;");
		script.println("location.href = 'emailSendAction.jsp'");
		script.println("</script>");
		script.close();
		return;
	
	}
%>