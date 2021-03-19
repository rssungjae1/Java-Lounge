<%@page import="javax.servlet.jsp.tagext.TryCatchFinally"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.mail.Transport"%>
<%@ page import="javax.mail.Message"%>
<%@ page import="javax.mail.Address"%>
<%@ page import="javax.mail.internet.InternetAddress"%>
<%@ page import="javax.mail.internet.MimeMessage"%>
<%@ page import="javax.mail.Session"%>
<%@ page import="javax.mail.Authenticator"%>
<%@ page import="java.util.Properties"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="utill.SMTPAuthenticator"%>
<%@ page import="utill.SHA256"%>
<%@ page import="user.UserDAO"%>
<%
	UserDAO userDAO = new UserDAO();
String userID = null;
if (session.getAttribute("userID") != null) {
	userID = (String) session.getAttribute("userID");
}
if (userID == null) {
	PrintWriter script = response.getWriter();
	script.println("<script>;");
	script.println("alert('로그인을 해주세요.');");
	script.println("location.href = 'userLogin.jsp'");
	script.println("</script>");
	script.close();
	return;
}
request.setCharacterEncoding("UTF-8");
String reportTitle = null;
String reportContent = null;
if (request.getParameter("reportTitle") != null) {
	reportTitle = request.getParameter("reportTitle");
}
if (request.getParameter("reportContent") != null) {
	reportContent = request.getParameter("reportContent");
}
if (reportTitle == null || reportContent == null || reportTitle.equals("") || reportContent.equals("")) {
	PrintWriter script = response.getWriter();
	script.println("<script>;");
	script.println("alert('입력이 안된 사항이 있습니다.');");
	script.println("history.back()");
	script.println("</script>");
	script.close();
	return;
}

String host = "http://localhost:8080/Lecture_Evaluation/";
String from = "rssungjae.dev@gmail.com";
String to = "rssungjae.dev@gmail.com";
String subject = "강의평가에서 접수된 신고 메일입니다.";
String content = "신고자 : " + userID + "<br>제목: " + reportTitle + "<br>내용: " + reportContent;

Properties p = new Properties(); // SMTP 서버에 접속하기 위한 정보들
p.put("mail.smtp.user", from);
p.put("mail.smtp.host", "smtp.gmail.com"); // 이메일 발송을 처리해줄 STMP 서버
p.put("mail.smtp.port", "465"); // SMTP서버와 통신하는 포트,  gmail일 경우 465를 Naver의 경우 587
p.put("mail.smtp.starttls.enable", "true"); // 보안 관련 채널을 생성하여 인증서 확인
p.put("mail.smtp.auth", "true");
p.put("mail.smtp.debug", "true"); // 로그 확인
p.put("mail.smtp.socketFactory.port", "465");
p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
p.put("mail.smtp.socketFactory.fallback", "false");

try {
	Authenticator auth = new SMTPAuthenticator();
	Session ses = Session.getInstance(p, auth);

	ses.setDebug(true);

	MimeMessage msg = new MimeMessage(ses); // 메일의 내용을 담을 객체
	msg.setSubject(subject); // 제목

	Address fromAddr = new InternetAddress(from);
	msg.setFrom(fromAddr); // 보내는 사람

	Address toAddr = new InternetAddress(to);
	msg.addRecipient(Message.RecipientType.TO, toAddr); // 받는 사람

	msg.setContent(from + "님께서 " + content, "text/html;charset=UTF-8"); // 내용과 인코딩

	Transport.send(msg); // 전송
	PrintWriter script = response.getWriter();
	script.println("<script>;");
	script.println("alert('정상적으로 신고가 접수되었습니다.');");
	script.println("history.back()");
	script.println("</script>");
	script.close();
	return;
} catch (Exception e) {
	e.printStackTrace();
	PrintWriter script = response.getWriter();
	script.println("<script>;");
	script.println("alert('오류가 발생했습니다.');");
	script.println("history.back()");
	script.println("</script>");
	script.close();
	return;
}
%>