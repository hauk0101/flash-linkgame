package com.game.action;

import java.sql.Connection;
import java.sql.PreparedStatement;

import com.game.util.DbUtil;

public class SetScore {
	public int setScore(String userName, int score) throws Exception {

		DbUtil dbUtil = new DbUtil();
		Connection con = null;
		try {
			con = dbUtil.getCon();
			String sql = "update t_user set score=? where userName=?";
			PreparedStatement pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, score);
			pstmt.setString(2, userName);
			int flag = pstmt.executeUpdate();
			if (flag > 0) {
				return 1;
			} else {
				return 0;
			}
		} catch (Exception e) {
			e.printStackTrace();
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
