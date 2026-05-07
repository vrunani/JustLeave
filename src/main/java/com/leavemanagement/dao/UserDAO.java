package com.leavemanagement.dao;

import com.leavemanagement.model.User;
import com.leavemanagement.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
public User login(String email, String password) {

    System.out.println("DAO: login() called");

    try (Connection conn = DBConnection.getConnection()) {

        if (conn == null) {
            System.out.println("DB NOT CONNECTED ❌");
            return null;
        }

        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, email);
        ps.setString(2, password);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {

            User user = new User();
            user.setUserId(rs.getInt("user_id"));
            user.setName(rs.getString("name"));
            user.setEmail(rs.getString("email"));
            user.setRole(rs.getString("role"));
            user.setTotalLeaves(rs.getInt("total_leaves"));

            return user;
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return null;
}
public String loginDebug(String email, String password) {

    System.out.println("DAO: loginDebug called");

    try (Connection conn = DBConnection.getConnection()) {

        if (conn == null) {
            return "DB_NOT_CONNECTED";
        }

        System.out.println("DAO: DB CONNECTED ✔");

        // STEP 1: check email only
        String sql1 = "SELECT * FROM users WHERE email = ?";
        PreparedStatement ps1 = conn.prepareStatement(sql1);
        ps1.setString(1, email);

        ResultSet rs1 = ps1.executeQuery();

        if (!rs1.next()) {
            return "EMAIL_NOT_FOUND";
        }

        // STEP 2: check password
        String dbPassword = rs1.getString("password");

        if (!dbPassword.equals(password)) {
            return "WRONG_PASSWORD";
        }

        return "SUCCESS";

    } catch (Exception e) {
        e.printStackTrace();
        return "SQL_ERROR";
    }
}
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = 'user'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setTotalLeaves(rs.getInt("total_leaves"));
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public boolean createUser(User user) {
        String sql = "INSERT INTO users (name, email, password, role, total_leaves) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getRole());
            ps.setInt(5, user.getTotalLeaves());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public User getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setTotalLeaves(rs.getInt("total_leaves"));
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}