package com.game.action;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.game.util.DbUtil;

public class GetScore {
	public String[] getRank() throws Exception {
		String[] rank = new String[10];
		int i = 0;
		DbUtil dbUtil = new DbUtil();
		Connection con = null;
		try {
			con = dbUtil.getCon();
			String sql = "SELECT * FROM t_user  ORDER BY score DESC LIMIT 10";
			PreparedStatement pstmt = con.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				String s = rs.getString(1) + "," + rs.getString(3);
				rank[i] = s;
				i++;
			}
			return rank;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				dbUtil.closeCon(con);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
	}

}
