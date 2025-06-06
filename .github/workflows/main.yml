#!/usr/bin/env python3

import os
import sqlite3
import json

# Configuration
DB_PATH = os.path.join(os.path.dirname(__file__), 'database', 'yap2u.sqlite')
DB_DIR = os.path.dirname(DB_PATH)

def ensure_db_directory():
    """Ensure the database directory exists"""
    if not os.path.exists(DB_DIR):
        os.makedirs(DB_DIR)
        print(f"Created database directory: {DB_DIR}")

def create_database():
    """Create the SQLite database and tables"""
    ensure_db_directory()
    
    # Check if database already exists
    if os.path.exists(DB_PATH):
        print(f"Database already exists at {DB_PATH}")
        return
    
    # Read SQL script
    sql_script_path = os.path.join(os.path.dirname(__file__), 'yap2u_database.sql')
    with open(sql_script_path, 'r') as f:
        sql_script = f.read()
    
    # Create database and execute script
    conn = sqlite3.connect(DB_PATH)
    conn.executescript(sql_script)
    conn.commit()
    
    # Insert sample data
    insert_sample_data(conn)
    
    conn.close()
    print(f"Database created successfully at {DB_PATH}")

def insert_sample_data(conn):
    """Insert sample data into the database"""
    # Sample admin user
    conn.execute("""
    INSERT INTO Users (username, email, password_hash, role)
    VALUES ('admin', 'admin@yap2u.page', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin')
    """)
    
    # Get the admin user ID
    admin_id = conn.execute("SELECT id FROM Users WHERE username = 'admin'").fetchone()[0]
    
    # Create admin record
    conn.execute("""
    INSERT INTO Admin (user_id, access_level, department)
    VALUES (?, 1, 'Management')
    """, (admin_id,))
    
    # Sample staff users
    staff_data = [
        ('jsmith', 'john.smith@yap2u.page', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'staff', 'John', 'Smith', '555-123-4567', 'Senior Consultant'),
        ('mjohnson', 'mary.johnson@yap2u.page', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'staff', 'Mary', 'Johnson', '555-234-5678', 'Consultant')
    ]
    
    for staff in staff_data:
        conn.execute("""
        INSERT INTO Users (username, email, password_hash, role)
        VALUES (?, ?, ?, ?)
        """, staff[:4])
        
        user_id = conn.execute("SELECT id FROM Users WHERE username = ?", (staff[0],)).fetchone()[0]
        
        conn.execute("""
        INSERT INTO Staff (user_id, first_name, last_name, phone, position)
        VALUES (?, ?, ?, ?, ?)
        """, (user_id, staff[4], staff[5], staff[6], staff[7]))
    
    # Sample customers
    customer_data = [
        ('rwilson', 'robert.wilson@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'customer', 'Robert', 'Wilson', '555-345-6789', '123 Main St', 'New York', 'NY', '10001', 'USA', 1),
        ('jdoe', 'jane.doe@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'customer', 'Jane', 'Doe', '555-456-7890', '456 Oak Ave', 'Los Angeles', 'CA', '90001', 'USA', 2)
    ]
    
    for customer in customer_data:
        conn.execute("""
        INSERT INTO Users (username, email, password_hash, role)
        VALUES (?, ?, ?, ?)
        """, customer[:4])
        
        user_id = conn.execute("SELECT id FROM Users WHERE username = ?", (customer[0],)).fetchone()[0]
        
        conn.execute("""
        INSERT INTO Customers (user_id, first_name, last_name, phone, address, city, state, postal_code, country, plan_type_id)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (user_id, customer[4], customer[5], customer[6], customer[7], customer[8], customer[9], customer[10], customer[11], customer[12]))
    
    # Sample calendar
    conn.execute("""
    INSERT INTO Calendar (name, description, color)
    VALUES ('Main Calendar', 'Primary scheduling calendar', '#3aa3fd')
    """)
    
    calendar_id = conn.execute("SELECT id FROM Calendar WHERE name = 'Main Calendar'").fetchone()[0]
    
    # Sample schedules
    staff_ids = conn.execute("SELECT id FROM Staff").fetchall()
    
    for staff_id in staff_ids:
        for day in range(1, 6):  # Monday to Friday
            conn.execute("""
            INSERT INTO Schedule (calendar_id, staff_id, day_of_week, start_time, end_time)
            VALUES (?, ?, ?, '09:00', '17:00')
            """, (calendar_id, staff_id[0], day))
    
    # Sample appointments
    customer_ids = conn.execute("SELECT id FROM Customers").fetchall()
    schedule_ids = conn.execute("SELECT id FROM Schedule").fetchall()
    
    # Create a few appointments
    appointment_data = [
        (customer_ids[0][0], staff_ids[0][0], schedule_ids[0][0], 'Initial Consultation', 'First meeting to discuss requirements', '2025-06-10 10:00:00', '2025-06-10 11:00:00', 'scheduled'),
        (customer_ids[1][0], staff_ids[1][0], schedule_ids[5][0], 'Follow-up Meeting', 'Review progress and next steps', '2025-06-12 14:00:00', '2025-06-12 15:00:00', 'scheduled')
    ]
    
    for appointment in appointment_data:
        conn.execute("""
        INSERT INTO Appointments (customer_id, staff_id, schedule_id, title, description, start_datetime, end_datetime, status)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """, appointment)
    
    conn.commit()
    print("Sample data inserted successfully")

def check_database():
    """Check if the database exists and has tables"""
    if not os.path.exists(DB_PATH):
        print(f"Database does not exist at {DB_PATH}")
        return False
    
    try:
        conn = sqlite3.connect(DB_PATH)
        cursor = conn.cursor()
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table'")
        tables = cursor.fetchall()
        conn.close()
        
        if not tables:
            print("Database exists but contains no tables")
            return False
        
        print(f"Database exists with {len(tables)} tables:")
        for table in tables:
            print(f"- {table[0]}")
        return True
    except sqlite3.Error as e:
        print(f"Error checking database: {e}")
        return False

if __name__ == "__main__":
    print("YAP2U Database Setup Utility")
    print("============================")
    
    if check_database():
        print("\nDatabase is already set up.")
    else:
        print("\nSetting up database...")
        create_database()
        print("\nDatabase setup complete.")
    
    print("\nDefault login credentials:")
    print("Admin: admin@yap2u.page / password")
    print("Staff: john.smith@yap2u.page / password")
    print("Customer: robert.wilson@example.com / password")
