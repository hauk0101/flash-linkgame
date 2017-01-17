<%@page import="com.game.action.GetScore"%>
<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<%
	GetScore getscore = new GetScore();
	String[] result = getscore.getRank();
	String str = "";
	for (int i = 0;i < result.length;i++)
	{
		str += result[i] + ";";
	}
	out.print(str);
%>