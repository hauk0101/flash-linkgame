<%@page import="com.game.action.Login"%>
<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>


   <% 
   		String username = request.getParameter("username");
   		String password = request.getParameter("password");
   		Login login = new Login();
   		out.print(login.login(username, password));
   %>

