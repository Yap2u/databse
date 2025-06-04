-- YAP2U SQLite Database Creation Script

-- Enable foreign key constraints
PRAGMA foreign_keys = ON;

-- Users table
CREATE TABLE IF NOT EXISTS Users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    role TEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_login DATETIME,
    status TEXT NOT NULL DEFAULT 'active'
);

-- Create indexes for Users table
CREATE INDEX IF NOT EXISTS idx_users_email ON Users(email);
CREATE INDEX IF NOT EXISTS idx_users_username ON Users(username);
CREATE INDEX IF NOT EXISTS idx_users_role ON Users(role);

-- Plan_Types table
CREATE TABLE IF NOT EXISTS Plan_Types (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    price REAL NOT NULL,
    duration_days INTEGER NOT NULL,
    features TEXT,
    is_active INTEGER NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Customers table
CREATE TABLE IF NOT EXISTS Customers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    phone TEXT,
    address TEXT,
    city TEXT,
    state TEXT,
    postal_code TEXT,
    country TEXT,
    plan_type_id INTEGER,
    notes TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY (plan_type_id) REFERENCES Plan_Types(id) ON DELETE SET NULL
);

-- Create indexes for Customers table
CREATE INDEX IF NOT EXISTS idx_customers_user_id ON Customers(user_id);
CREATE INDEX IF NOT EXISTS idx_customers_plan_type_id ON Customers(plan_type_id);
CREATE INDEX IF NOT EXISTS idx_customers_last_name ON Customers(last_name);

-- Staff table
CREATE TABLE IF NOT EXISTS Staff (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    phone TEXT,
    position TEXT,
    bio TEXT,
    specialties TEXT,
    availability TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE
);

-- Create indexes for Staff table
CREATE INDEX IF NOT EXISTS idx_staff_user_id ON Staff(user_id);
CREATE INDEX IF NOT EXISTS idx_staff_last_name ON Staff(last_name);

-- Admin table
CREATE TABLE IF NOT EXISTS Admin (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL UNIQUE,
    access_level INTEGER NOT NULL DEFAULT 1,
    department TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE
);

-- Calendar table
CREATE TABLE IF NOT EXISTS Calendar (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    color TEXT,
    is_active INTEGER NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Schedule table
CREATE TABLE IF NOT EXISTS Schedule (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    calendar_id INTEGER NOT NULL,
    staff_id INTEGER,
    day_of_week INTEGER NOT NULL, -- 0-6 (Sunday-Saturday)
    start_time TEXT NOT NULL,     -- HH:MM format
    end_time TEXT NOT NULL,       -- HH:MM format
    is_available INTEGER NOT NULL DEFAULT 1,
    recurrence TEXT,              -- JSON string for recurrence pattern
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (calendar_id) REFERENCES Calendar(id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES Staff(id) ON DELETE SET NULL
);

-- Create indexes for Schedule table
CREATE INDEX IF NOT EXISTS idx_schedule_calendar_id ON Schedule(calendar_id);
CREATE INDEX IF NOT EXISTS idx_schedule_staff_id ON Schedule(staff_id);
CREATE INDEX IF NOT EXISTS idx_schedule_day_of_week ON Schedule(day_of_week);

-- Appointments table
CREATE TABLE IF NOT EXISTS Appointments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER NOT NULL,
    staff_id INTEGER,
    schedule_id INTEGER,
    title TEXT NOT NULL,
    description TEXT,
    start_datetime DATETIME NOT NULL,
    end_datetime DATETIME NOT NULL,
    status TEXT NOT NULL DEFAULT 'scheduled',
    notes TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES Staff(id) ON DELETE SET NULL,
    FOREIGN KEY (schedule_id) REFERENCES Schedule(id) ON DELETE SET NULL
);

-- Create indexes for Appointments table
CREATE INDEX IF NOT EXISTS idx_appointments_customer_id ON Appointments(customer_id);
CREATE INDEX IF NOT EXISTS idx_appointments_staff_id ON Appointments(staff_id);
CREATE INDEX IF NOT EXISTS idx_appointments_schedule_id ON Appointments(schedule_id);
CREATE INDEX IF NOT EXISTS idx_appointments_start_datetime ON Appointments(start_datetime);
CREATE INDEX IF NOT EXISTS idx_appointments_status ON Appointments(status);

-- Insert sample data for Plan_Types
INSERT INTO Plan_Types (name, description, price, duration_days, features, is_active)
VALUES 
('Basic', 'Basic plan with essential features', 9.99, 30, '{"appointments": 5, "staff_access": false, "reports": false}', 1),
('Special', 'Special plan with advanced features', 19.99, 30, '{"appointments": 20, "staff_access": true, "reports": true}', 1);

-- Trigger to update the updated_at timestamp when a record is modified
CREATE TRIGGER IF NOT EXISTS update_users_timestamp AFTER UPDATE ON Users
BEGIN
    UPDATE Users SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS update_customers_timestamp AFTER UPDATE ON Customers
BEGIN
    UPDATE Customers SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS update_staff_timestamp AFTER UPDATE ON Staff
BEGIN
    UPDATE Staff SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS update_admin_timestamp AFTER UPDATE ON Admin
BEGIN
    UPDATE Admin SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS update_plan_types_timestamp AFTER UPDATE ON Plan_Types
BEGIN
    UPDATE Plan_Types SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS update_calendar_timestamp AFTER UPDATE ON Calendar
BEGIN
    UPDATE Calendar SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS update_schedule_timestamp AFTER UPDATE ON Schedule
BEGIN
    UPDATE Schedule SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS update_appointments_timestamp AFTER UPDATE ON Appointments
BEGIN
    UPDATE Appointments SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
