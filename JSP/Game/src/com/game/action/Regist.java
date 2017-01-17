package com.game.action;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.game.util.DbUtil;

public class Regist {
	public int regist(String userName,String password) throws Exception {
		DbUtil dbUtil = new DbUtil();
		Connection con = null;
		try {
			con = dbUtil.getCon();
			String sql = "select * from t_user where userName=?";
			PreparedStatement pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userName);
			
			ResultSet rs = pstmt.executeQuery();
			if (rs.next()) {
				return 0;
			} else{
			    String s ="insert into t_user values(?,?,0)";
			    PreparedStatement pstm=con.prepareStatement(s);
			    pstm.setString(1, userName);
			    pstm.setString(2, password);
			    int rs2=pstm.executeUpdate();
			    if (rs2>0) {
					return 1;
				}else{
					System.out.println("fail");
					return 0;
				}
			    
			}
		} catch (Exception e) {

		} finally {
			try {
				dbUtil.closeCon(con);
			} catch (Exception e) {
				e.printStackTrace();
			}

		}
		return 0;

	}
}
