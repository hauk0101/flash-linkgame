package com.game.action;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.game.util.DbUtil;

public class Login {
	public int login(String userName,String password)throws Exception{
		DbUtil dbUtil=new DbUtil();
		Connection con=null;
		try {
			con=dbUtil.getCon();
			String sql="select * from t_user where userName=? and password=?";
			PreparedStatement pstmt=con.prepareStatement(sql);
			pstmt.setString(1, userName);
			pstmt.setString(2, password);
			ResultSet rs=pstmt.executeQuery();
			if(rs.next()){
						
				//返回1为登录成功
				return 1;
								
			}
			else{
		         return 0;
			}
		} catch (Exception e) {
			// TODO: handle exception
		}finally{
			try {
				  dbUtil.closeCon(con);
			} catch (Exception e) {
					  e.printStackTrace();
		    }
		}
		return 0;
		
	}

}
