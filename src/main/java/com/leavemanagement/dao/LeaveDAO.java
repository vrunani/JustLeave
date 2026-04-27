package com.leavemanagement.dao;

import com.leavemanagement.model.Leave;
import com.leavemanagement.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LeaveDAO {

    public boolean applyLeave(Leave leave) {
        String sql = "INSERT INTO leaves (user_id, reason, description, start_date, end_date) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, leave.getUserId());
            ps.setString(2, leave.getReason());
            ps.setString(3, leave.getDescription());
            ps.setDate(4, leave.getStartDate());
            ps.setDate(5, leave.getEndDate());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Leave> getLeavesByUser(int userId) {
        List<Leave> leaves = new ArrayList<>();
        String sql = "SELECT * FROM leaves WHERE user_id = ? ORDER BY applied_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Leave leave = mapLeave(rs);
                leaves.add(leave);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return leaves;
    }

    public List<Leave> getAllLeaves() {
        List<Leave> leaves = new ArrayList<>();
        String sql = "SELECT l.*, u.name AS user_name FROM leaves l " +
                     "JOIN users u ON l.user_id = u.user_id ORDER BY l.applied_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Leave leave = mapLeave(rs);
                leave.setUserName(rs.getString("user_name"));
                leaves.add(leave);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return leaves;
    }

    public boolean updateLeaveStatus(int leaveId, String status) {
        String sql = "UPDATE leaves SET status = ? WHERE leave_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, leaveId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean cancelLeave(int leaveId, int userId) {
        String sql = "UPDATE leaves SET status = 'cancelled' WHERE leave_id = ? AND user_id = ? AND status = 'pending'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, leaveId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countByStatus(int userId, String status) {
        String sql = "SELECT COUNT(*) FROM leaves WHERE user_id = ? AND status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Leave mapLeave(ResultSet rs) throws SQLException {
        Leave leave = new Leave();
        leave.setLeaveId(rs.getInt("leave_id"));
        leave.setUserId(rs.getInt("user_id"));
        leave.setReason(rs.getString("reason"));
        leave.setDescription(rs.getString("description"));
        leave.setStartDate(rs.getDate("start_date"));
        leave.setEndDate(rs.getDate("end_date"));
        leave.setStatus(rs.getString("status"));
        leave.setAppliedAt(rs.getTimestamp("applied_at"));
        return leave;
    }
}