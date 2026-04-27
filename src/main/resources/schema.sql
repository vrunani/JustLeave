-- ============================================================
--  Leave Management Application — Database Schema
--  Run this file in MySQL to set up the full database
--  Command: mysql -u root -p < schema.sql
-- ============================================================

-- Step 1: Create and select the database
CREATE DATABASE IF NOT EXISTS leavemanagement;
USE leavemanagement;

-- ============================================================
--  TABLE: users
--  Stores both admin and regular user accounts
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    user_id    INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(100)          NOT NULL,
    email      VARCHAR(100)          NOT NULL UNIQUE,
    password   VARCHAR(255)          NOT NULL,
    role       ENUM('admin','user')  NOT NULL DEFAULT 'user',
    total_leaves INT                 NOT NULL DEFAULT 20,
    created_at TIMESTAMP             NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
--  TABLE: leaves
--  Stores all leave requests submitted by users
-- ============================================================
CREATE TABLE IF NOT EXISTS leaves (
    leave_id    INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT          NOT NULL,
    reason      VARCHAR(255) NOT NULL,
    description TEXT,
    start_date  DATE         NOT NULL,
    end_date    DATE         NOT NULL,
    status      ENUM('pending','approved','rejected','cancelled')
                             NOT NULL DEFAULT 'pending',
    applied_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
                             ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_leaves_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE
);

-- ============================================================
--  TABLE: notifications
--  Stores notifications sent to users (approve/reject/holiday)
-- ============================================================
CREATE TABLE IF NOT EXISTS notifications (
    notif_id   INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT          NOT NULL,
    message    TEXT         NOT NULL,
    is_read    BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_notif_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE
);

-- ============================================================
--  SAMPLE DATA: Default admin + 2 test users
--  Password is plain text for now — will be hashed later in Java
-- ============================================================
INSERT INTO users (name, email, password, role, total_leaves) VALUES
('Admin User',  'admin@leave.com', 'admin123', 'admin', 0),
('John Doe',    'john@leave.com',  'user123',  'user',  20),
('Jane Smith',  'jane@leave.com',  'user123',  'user',  20);

-- ============================================================
--  SAMPLE DATA: A few test leave requests
-- ============================================================
INSERT INTO leaves (user_id, reason, description, start_date, end_date, status) VALUES
(2, 'Medical',  'Doctor appointment',        '2026-05-01', '2026-05-02', 'pending'),
(2, 'Personal', 'Family function',           '2026-05-10', '2026-05-11', 'approved'),
(3, 'Sick',     'Fever and cold',            '2026-05-05', '2026-05-06', 'rejected'),
(3, 'Vacation', 'Annual family trip',        '2026-06-01', '2026-06-05', 'pending');

-- ============================================================
--  SAMPLE DATA: Test notifications
-- ============================================================
INSERT INTO notifications (user_id, message, is_read) VALUES
(2, 'Your leave request from May 10 has been approved.', FALSE),
(3, 'Your leave request from May 5 has been rejected.', FALSE),
(2, 'Holiday notice: Office closed on May 15 (Buddha Purnima).', FALSE);

-- ============================================================
--  Verify everything was created correctly
-- ============================================================
SHOW TABLES;
SELECT * FROM users;
SELECT * FROM leaves;
SELECT * FROM notifications;