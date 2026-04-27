package com.leavemanagement.model;

public class User {
    private int userId;
    private String name;
    private String email;
    private String password;
    private String role;
    private int totalLeaves;

    public User() {}

    public User(int userId, String name, String email, String role, int totalLeaves) {
        this.userId      = userId;
        this.name        = name;
        this.email       = email;
        this.role        = role;
        this.totalLeaves = totalLeaves;
    }

    public int getUserId()           { return userId; }
    public void setUserId(int id)    { this.userId = id; }

    public String getName()              { return name; }
    public void setName(String name)     { this.name = name; }

    public String getEmail()             { return email; }
    public void setEmail(String email)   { this.email = email; }

    public String getPassword()              { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRole()              { return role; }
    public void setRole(String role)     { this.role = role; }

    public int getTotalLeaves()              { return totalLeaves; }
    public void setTotalLeaves(int leaves)   { this.totalLeaves = leaves; }
}