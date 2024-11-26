-- Database Creation
CREATE DATABASE school_attendance_system;
USE school_attendance_system;

-- Users Table
CREATE TABLE users (
    id BINARY(16) PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID())),
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    role ENUM('admin', 'teacher', 'parent') NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL
);

-- Students Table
CREATE TABLE students (
    id BINARY(16) PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID())),
    student_number VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    grade VARCHAR(10) NOT NULL,
    class VARCHAR(50) NOT NULL,
    gender ENUM('male', 'female', 'other') NOT NULL,
    cultural_considerations VARCHAR(255) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Face Data Table
CREATE TABLE face_data (
    id BINARY(16) PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID())),
    student_id BINARY(16) NOT NULL,
    encoded_data LONGBLOB NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valid_until DATETIME NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

-- Attendance Table
CREATE TABLE attendance (
    id BINARY(16) PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID())),
    student_id BINARY(16) NOT NULL,
    check_in_time DATETIME NOT NULL,
    check_out_time DATETIME NULL,
    status ENUM('present', 'absent', 'late', 'excused') NOT NULL DEFAULT 'absent',
    is_late BOOLEAN DEFAULT FALSE,
    late_slip_ref VARCHAR(100) NULL,
    location VARCHAR(100) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

-- Consents Table
CREATE TABLE consents (
    id BINARY(16) PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID())),
    student_id BINARY(16) NOT NULL,
    face_recognition BOOLEAN NOT NULL DEFAULT FALSE,
    notifications BOOLEAN NOT NULL DEFAULT FALSE,
    valid_from DATETIME NOT NULL,
    valid_until DATETIME NOT NULL,
    guardian_signature VARCHAR(255) NULL,
    guardian_name VARCHAR(255) NOT NULL,
    relationship ENUM('parent', 'legal guardian') NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

-- Indexes for Performance
CREATE INDEX idx_student_attendance ON attendance(student_id, check_in_time);
CREATE INDEX idx_face_data_student ON face_data(student_id);
CREATE INDEX idx_user_email ON users(email);

-- User Management
CREATE USER 'attendance_system'@'localhost' IDENTIFIED BY 'strong_password_here';
GRANT SELECT, INSERT, UPDATE, DELETE ON school_attendance_system.* TO 'attendance_system'@'localhost';

-- Stored Procedure for Student Check-In
DELIMITER //
CREATE PROCEDURE student_check_in(
    IN p_student_id BINARY(16), 
    IN p_location VARCHAR(100)
)
BEGIN
    INSERT INTO attendance (student_id, check_in_time, status, location)
    VALUES (p_student_id, CURRENT_TIMESTAMP, 
        CASE 
            WHEN TIME(CURRENT_TIMESTAMP) > '08:15:00' THEN 'late'
            ELSE 'present'
        END, 
        p_location);
END //
DELIMITER ;

-- Stored Procedure for Student Check-Out
DELIMITER //
CREATE PROCEDURE student_check_out(
    IN p_student_id BINARY(16)
)
BEGIN
    UPDATE attendance 
    SET check_out_time = CURRENT_TIMESTAMP 
    WHERE student_id = p_student_id 
    AND check_out_time IS NULL 
    ORDER BY check_in_time DESC 
    LIMIT 1;
END //
DELIMITER ;