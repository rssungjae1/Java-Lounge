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
boolean emailChecked = userDAO.getUserEmailChecked(userID);
if (emailChecked == true) {
	PrintWriter script = response.getWriter();
	script.println("<script>;");
	script.println("alert('이미 인증된 회원입니다.');");
	script.println("location.href = 'index.jsp'");
	script.println("</script>");
	script.close();
	return;
}

String host = "http://localhost:8080/Lecture_Evaluation/";
String from = "rssungjae.dev@gmail.com";
String to = userDAO.getUserEmail(userID);
String subject = "강의평가를 위한 이메일 인증 메일입니다.";
String content = "다음 링크에 접속하여 이메일 인증을 진행하세요." + "<a href='" + host + "emailCheckAction.jsp?code="
		+ new SHA256().getSHA256(to) + "'>이메일 인증하기</a>";

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

<!DOCTYPE html>
<html>
<head>
<!-- 
<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1">
 -->
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>강의평가 웹사이트</title>
<!-- bootstrap css 추가 -->
<link rel="stylesheet" href="./css/bootstrap.min.css">
<!-- custom css 추가 -->
<link rel="stylesheet" href="./css/custom.css">
</head>
<body>
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
		<a class="navbar-brand" href="index.jsp">강의평가 웹사이트</a>
		<button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbar">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div id="navbar" class="collapse navbar-collapse">
			<ul class="navbar-nav mr-auto">
				<li class="nav-item active"><a class="nav-link" href="index.jsp">메인</a></li>
				<li class="nav-item dropdown"><a class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown">회원관리</a>
					<div class="dropdown-menu" aria-labelledby="dropdown">
						<%
							if (userID == null) {
						%>
						<a class="dropdown-item" href="userLogin.jsp">로그인</a> <a class="dropdown-item" href="userJoin.jsp">회원가입</a>
						<%
							} else {
						%>
						<a class="dropdown-item" href="userLogout.jsp">로그아웃</a>
						<%
							}
						%>
					</div></li>
			</ul>
		</div>
		<div id="navbar" class="collapse navbar-collapse my-2 my-lg-0">
			<input class="form-control" type="search" placeholder="내용을 입력하세요." aria-label="Search">
			<button class="btn btn-outline-success my-2 my-sm-0" type="submit">검색</button>
		</div>
	</nav>
	<section class="container mt-3" style="max-width: 560px;">
		<div class="alert alert-successs mt-4" role="alert">이메일 주소 인증 메일이 전송되었습니다. 회원가입시 입력했던 이메일에 들어가셔서 인증해주세요.</div>
	</section>
	<footer class="bg-dark mt-4 p-5 text-center" style="color: #FFFFFF;"> Copyright &copy; 2019 송성재 All Rights Reserved. </footer>
	<script src="./js/jquery.min.js"></script>
	<script src="./js/popper.min.js"></script>
	<script src="./js/bootstrap.min.js"></script>
</body>
</html>