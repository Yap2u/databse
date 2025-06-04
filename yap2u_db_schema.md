# YAP2U Database Schema Design

## Overview
This document outlines the database schema for the YAP2U application using SQLite. The schema includes tables for Users, Customers, Staff, Admin, Appointments, Schedule, Calendar, and Plan Types.

## Entity Relationship Diagram

```
Users 1──┐
         │
         ├──n Appointments
         │
Staff 1──┘
         
Customers 1──n Appointments

Plan_Types 1──n Customers

Calendar 1──n Schedule

Schedule 1──n Appointments
```

## Tables

### Users
Stores basic user information for authentication and access control.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier |
| username | TEXT | NOT NULL UNIQUE | User login name |
| email | TEXT | NOT NULL UNIQUE | User email address |
| password_hash | TEXT | NOT NULL | Hashed password |
| role | TEXT | NOT NULL | User role (customer, staff, admin) |
| created_at | DATETIME | NOT NULL DEFAULT CURRENT_TIMESTAMP | Account creation date |
| updated_at | DATETIME | NOT NULL DEFAULT CURRENT_TIMESTAMP | Last update date |
| last_login | DATETIME | | Last login timestamp |
| status | TEXT | NOT NULL DEFAULT 'active' | Account status |

### Customers
Stores detailed information about customers.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier |
| user_id | INTEGER | NOT NULL REFERENCES Users(id) | Associated user account |
| first_name | TEXT | NOT NULL | Customer's first name |
| last_name | TEXT | NOT NULL | Customer's last name |
| phone | TEXT | | Customer's phone number |
| address | TEXT | | Customer's address |
| city | TEXT | | Customer's city |
| state | TEXT | | Customer's state/province |
| postal_code | TEXT | | Customer's postal/zip code |
| country | TEXT | | Customer's country |
| plan_type_id | INTEGER | REFERENCES Plan_Types(id) | Customer's subscription plan |
| notes | TEXT | | Additional notes |
| created_at | DATETIME | NOT NULL DEFAULT CURRENT_TIMESTAMP | Record creation date |
| updated_at | DATETIME | NOT NULL DEFAULT CURRENT_TIMESTAMP | Last update date |

### Staff
Stores information about staff members who provide services.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier |
| user_id | INTEGER | NOT NULL REFERENCES Users(id) | Associated user account |
| first_name | TEXT | NOT NULL | Staff member's first name |
| last_name | TEXT | NOT NULL | Staff member's last name |
| phone | TEXT | | Staff member's phone number |
| position | TEXT | | Staff member's position/title |
| bio | TEXT | | Staff member's biography |
| specialties | TEXT | | Staff member's specialties |
| availability | TEXT | | General availability information |
| created_at | DATETIME | NOT NULL DEFAULT CURRENT_TIMESTAMP | Record creation date |
| updated_at | DATETIME | NOT NULL DEFAULT CURRENT_TIMESTAMP | Last update date |

### Admin
Stores additional information specific to admin users.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier |
| user_id | INTEGER | NOT NULL UNIQUE REFERENCES Users(id) | Associated user account |
| access_level | INTEGER | NOT NULL DEFAULT 1 | Admin access level |
| department | TEXT | | Admin's department |
| created_at | DATETIME | NOT NULL DEFAULT CURRENT_TIMESTAMP | Record creation date |
| updated_at | DATETIME | NOT NULL DEFAULT CURRENT_TIMESTAMP | Last update date |

### Plan_Types
Stores information about different subscription plans.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier |
| name | TEXT | NOT NULL UNIQUE | Plan name (Basic, Special, etc.) |
| description | TEXT | | Plan description |
| price | REAL | NOT NULL | Plan price |
| duration_days | INTEGER | NOT NULL | Plan duration in days |
| features | TEXT | | JSON string of plan features |
| is_active | INTEGER | NOT NULL DEFAULT 1 | Whether plan is active (1) or not (0) |
| created_at | DATETIME | NOT NULL DEFAULT CURRENT_TIMESTAMP | Record creation date |
| updated_at | DATETIME | NOT NULL DEFAULT CURRENT_TIMESTAMP | Last update date |

### Calendar
Stores calendar information for scheduling.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier |
| name | TEXT | NOT NULL | Calendar name |
| description | TEXT | | Calendar description |
| color | TEXT | | Calendar color code |
| is_active | INTEGER | NOT NULL DEFAULT 1 | Whether calendar is active (1) or not (0) |
| created_at | DATETIME | NOT NULL DEFAULT CURRENT_TIMESTAMP | Record creation date |
| updated_at | DATETIME | NOT NULL DEFAULT CURRENT_TIMESTAMP | Last update date |

### Schedule
Stores schedule slots for appointments.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier |
| calendar_id | INTEGER | NOT NULL REFERENCES Calendar(id) | Associated calendar |
| staff_id | INTEGER | REFERENCES Staff(id) | Associated staff member |
| day_of_week | INTEGER | NOT NULL | Day of week (0-6, Sunday-Saturday) |
| start_time | TEXT | NOT NULL | Start time (HH:MM format) |
| end_time | TEXT | NOT NULL | End time (HH:MM format) |
| is_available | INTEGER | NOT NULL DEFAULT 1 | Whether slot is available (1) or not (0) |
| recurrence | TEXT | | Recurrence pattern (JSON) |
| created_at | DATETIME | NOT NULL DEFAULT CURRENT_TIMESTAMP | Record creation date |
| updated_at | DATETIME | NOT NULL DEFAULT CURRENT_TIMESTAMP | Last update date |

### Appointments
Stores appointment information.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier |
| customer_id | INTEGER | NOT NULL REFERENCES Customers(id) | Customer for appointment |
| staff_id | INTEGER | REFERENCES Staff(id) | Staff assigned to appointment |
| schedule_id | INTEGER | REFERENCES Schedule(id) | Associated schedule slot |
| title | TEXT | NOT NULL | Appointment title |
| description | TEXT | | Appointment description |
| start_datetime | DATETIME | NOT NULL | Start date and time |
| end_datetime | DATETIME | NOT NULL | End date and time |
| status | TEXT | NOT NULL DEFAULT 'scheduled' | Status (scheduled, completed, cancelled, etc.) |
| notes | TEXT | | Additional notes |
| created_at | DATETIME | NOT NULL DEFAULT CURRENT_TIMESTAMP | Record creation date |
| updated_at | DATETIME | NOT NULL DEFAULT CURRENT_TIMESTAMP | Last update date |

## Indexes

- Users: email, username, role
- Customers: user_id, plan_type_id, last_name
- Staff: user_id, last_name
- Appointments: customer_id, staff_id, schedule_id, start_datetime, status
- Schedule: calendar_id, staff_id, day_of_week
