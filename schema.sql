-- Hostel Complaint Portal Database Schema for PostgreSQL (Supabase)

-- Drop tables if they already exist to ensure a clean slate and reset auto-incrementing IDs
DROP TABLE IF EXISTS complaints CASCADE;
DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS admins CASCADE;
DROP TABLE IF EXISTS hostels CASCADE;

-- 1. Create the Hostels table
CREATE TABLE hostels (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Insert dummy data for Pakistan Hostels (Explicit IDs so Admin and Complaint references don't fail)
INSERT INTO hostels (id, name) VALUES 
(1, 'Jinnah Hall'),
(2, 'Iqbal Hall'),
(3, 'Sir Syed Hall'),
(4, 'Liaquat Hall');

-- Update the sequence so future inserts don't conflict with explicitly inserted IDs
ALTER SEQUENCE hostels_id_seq RESTART WITH 5;

-- 2. Create the Admins table
CREATE TABLE admins (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL, -- In a real app, hash passwords. Kept simple for student level.
    hostel_id INT REFERENCES hostels(id) ON DELETE CASCADE
);

-- Insert dummy admin data (Setting requested credentials for the main admin)
INSERT INTO admins (username, password, hostel_id) VALUES 
('Noor Enterprise', 'NoorEnterprise839', 1),
('admin_iqbal', 'NoorEnterprise839', 2),
('admin_sirsyed', 'NoorEnterprise839', 3),
('admin_liaquat', 'NoorEnterprise839', 4);

-- 3. Create the Students table
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    room_no VARCHAR(20) NOT NULL,
    hostel_id INT REFERENCES hostels(id) ON DELETE SET NULL
);

-- Insert dummy student data
INSERT INTO students (username, password, name, room_no, hostel_id) VALUES 
('student1', 'pass123', 'Ali Raza', '101A', 1),
('student2', 'pass123', 'Fatima Noor', '205B', 2);

-- 4. Create the Complaints table
CREATE TABLE complaints (
    id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(id) ON DELETE CASCADE,
    hostel_id INT REFERENCES hostels(id) ON DELETE CASCADE,
    room_no VARCHAR(20) NOT NULL,
    student_name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    urgency VARCHAR(20) DEFAULT 'Medium', -- Added urgency level
    admin_confirmed BOOLEAN DEFAULT FALSE,
    student_confirmed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP
);

-- Insert some dummy complaints for testing
INSERT INTO complaints (student_id, hostel_id, room_no, student_name, description) VALUES 
(1, 1, '101A', 'Ali Raza', 'Fan is not working in the room.'),
(2, 2, '205B', 'Fatima Noor', 'Water leakage in the attached washroom.');
