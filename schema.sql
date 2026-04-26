-- Hostel Complaint Portal Database Schema for PostgreSQL (Supabase)

-- 0. Create the Database tables (Safe version - does not drop data)

-- 1. Create the Hostels table
CREATE TABLE IF NOT EXISTS hostels (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Insert dummy data for Pakistan Hostels (Explicit IDs so Admin and Complaint references don't fail)
-- INSERT INTO hostels (id, name) VALUES 
-- (1, 'Jinnah Hall'),
-- (2, 'Iqbal Hall'),
-- (3, 'Sir Syed Hall'),
-- (4, 'Liaquat Hall')
-- ON CONFLICT (id) DO NOTHING;

-- Update the sequence so future inserts don't conflict with explicitly inserted IDs
ALTER SEQUENCE hostels_id_seq RESTART WITH 5;

-- 2. Create the Admins table
CREATE TABLE IF NOT EXISTS admins (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL, -- In a real app, hash passwords. Kept simple for student level.
    hostel_id INT REFERENCES hostels(id) ON DELETE CASCADE
);

-- Insert dummy admin data (Setting requested credentials for the main admin)
-- INSERT INTO admins (username, password, hostel_id) VALUES 
-- ('Noor Hostels', 'NoorEnterprise839', 1),
-- ('admin_iqbal', 'NoorEnterprise839', 2),
-- ('admin_sirsyed', 'NoorEnterprise839', 3),
-- ('admin_liaquat', 'NoorEnterprise839', 4)
-- ON CONFLICT (username) DO NOTHING;

-- 3. Create the Students table
CREATE TABLE IF NOT EXISTS students (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    room_no VARCHAR(20) NOT NULL,
    hostel_id INT REFERENCES hostels(id) ON DELETE SET NULL
);

-- Insert dummy student data
-- INSERT INTO students (username, password, name, room_no, hostel_id) VALUES 
-- ('student1', 'pass123', 'Ali Raza', '101A', 1),
-- ('student2', 'pass123', 'Fatima Noor', '205B', 2)
-- ON CONFLICT (username) DO NOTHING;

-- 4. Create the Complaints table
CREATE TABLE IF NOT EXISTS complaints (
    id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(id) ON DELETE CASCADE,
    hostel_id INT REFERENCES hostels(id) ON DELETE CASCADE,
    room_no VARCHAR(20) NOT NULL,
    student_name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    urgency VARCHAR(20) DEFAULT 'Medium',
    admin_confirmed BOOLEAN DEFAULT FALSE,
    student_confirmed BOOLEAN DEFAULT FALSE,
    admin_comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP
);

-- Insert some dummy complaints for testing
-- Insert dummy complaints only if needed
-- INSERT INTO complaints (student_id, hostel_id, room_no, student_name, description) VALUES 
-- (1, 1, '101A', 'Ali Raza', 'Fan is not working in the room.'),
-- (2, 2, '205B', 'Fatima Noor', 'Water leakage in the attached washroom.');
-- 5. Create the deletion_logs table
CREATE TABLE IF NOT EXISTS deletion_logs (
    id SERIAL PRIMARY KEY,
    complaint_id INT,
    admin_name VARCHAR(100),
    student_name VARCHAR(100),
    room_no VARCHAR(20),
    description TEXT,
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- Safe way to add column if it doesn't exist
DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='complaints' AND column_name='admin_comment') THEN 
        ALTER TABLE complaints ADD COLUMN admin_comment TEXT;
    END IF;
END $$;

