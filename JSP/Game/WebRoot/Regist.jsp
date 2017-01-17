<%@page import="com.game.action.Regist"%>
<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

 <% 
   		String username = request.getParameter("username");
   		String password = request.getParameter("password");
   		
   		Regist regist = new Regist();
   		
   		out.print(regist.regist(username, password));
   %>