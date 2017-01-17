<%@page import="com.game.action.SetScore"%>
<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<% 
   		String username = request.getParameter("username");
   		String scorestr = request.getParameter("score");
   		int score = 0;
   		if((scorestr != null) && (scorestr != ""))
   		{
   			 score = Integer.parseInt(scorestr);
   		}
   		
   		
   		SetScore setscore = new SetScore();
    	out.print(setscore.setScore(username, score));
   %>