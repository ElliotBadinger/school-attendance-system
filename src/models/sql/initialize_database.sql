-- initialize_database.sql

-- Drop existing tables if needed (optional for development environments)
DROP TABLE IF EXISTS CONSENTS, FACE_DATA, CLASS_ATTENDANCE, SCHOOL_ENTRY_LOGS, STUDENTS;

-- STUDENTS Table
CREATE TABLE STUDENTS (
    student_id BINARY(16) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    grade INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- SCHOOL_ENTRY_LOGS Table
CREATE TABLE SCHOOL_ENTRY_LOGS (
    log_id BINARY(16) PRIMARY KEY,
    student_id BINARY(16) NOT NULL,
    entry_timestamp DATETIME NOT NULL,
    exit_timestamp DATETIME,
    is_authorized BOOLEAN NOT NULL,
    FOREIGN KEY (student_id) REFERENCES STUDENTS(student_id) ON DELETE CASCADE
);

-- CLASS_ATTENDANCE Table
CREATE TABLE CLASS_ATTENDANCE (
    attendance_id BINARY(16) PRIMARY KEY,
    student_id BINARY(16) NOT NULL,
    room_number VARCHAR(10) NOT NULL,
    class_timestamp DATETIME NOT NULL,
    instructor VARCHAR(100) NOT NULL,
    is_present BOOLEAN NOT NULL,
    FOREIGN KEY (student_id) REFERENCES STUDENTS(student_id) ON DELETE CASCADE
);

-- FACE_DATA Table
CREATE TABLE FACE_DATA (
    face_id BINARY(16) PRIMARY KEY,
    student_id BINARY(16) NOT NULL,
    encoded_data LONGBLOB NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    valid_until DATETIME,
    is_active BOOLEAN NOT NULL,
    FOREIGN KEY (student_id) REFERENCES STUDENTS(student_id) ON DELETE CASCADE
);

-- CONSENTS Table
CREATE TABLE CONSENTS (
    consent_id BINARY(16) PRIMARY KEY,
    student_id BINARY(16) NOT NULL,
    face_recognition BOOLEAN NOT NULL,
    notifications BOOLEAN NOT NULL,
    valid_until DATETIME NOT NULL,
    guardian_signature VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES STUDENTS(student_id) ON DELETE CASCADE
);

-- Sample Data
INSERT INTO STUDENTS (student_id, name, surname, grade) VALUES
(UUID_TO_BIN(UUID()), 'John', 'Doe', 10),
(UUID_TO_BIN(UUID()), 'Jane', 'Smith', 10);
