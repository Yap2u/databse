# Database Connection Configuration for YAP2U

This file provides configuration examples for connecting to the SQLite database from different environments.

## PHP Configuration Example

```php
<?php
// config/database.php

return [
    'default' => 'sqlite',
    'connections' => [
        'sqlite' => [
            'driver' => 'sqlite',
            'database' => __DIR__ . '/../database/yap2u.sqlite',
            'prefix' => '',
            'foreign_key_constraints' => true,
        ],
    ],
];
```

## Python Configuration Example

```python
# config/database.py

import os

DATABASE_CONFIG = {
    'default': 'sqlite',
    'connections': {
        'sqlite': {
            'driver': 'sqlite',
            'database': os.path.join(os.path.dirname(__file__), '..', 'database', 'yap2u.sqlite'),
            'foreign_keys': True,
        }
    }
}

# Example connection using SQLite3
import sqlite3

def get_db_connection():
    conn = sqlite3.connect(DATABASE_CONFIG['connections']['sqlite']['database'])
    conn.row_factory = sqlite3.Row
    # Enable foreign key constraints
    conn.execute('PRAGMA foreign_keys = ON')
    return conn

# Example connection using SQLAlchemy
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

DATABASE_URL = f"sqlite:///{DATABASE_CONFIG['connections']['sqlite']['database']}"
engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

def get_sqlalchemy_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
```

## JavaScript/Node.js Configuration Example

```javascript
// config/database.js

const path = require('path');

const dbConfig = {
  default: 'sqlite',
  connections: {
    sqlite: {
      client: 'sqlite3',
      connection: {
        filename: path.join(__dirname, '..', 'database', 'yap2u.sqlite')
      },
      useNullAsDefault: true,
      // Enable foreign keys
      pool: {
        afterCreate: (conn, cb) => {
          conn.run('PRAGMA foreign_keys = ON', cb);
        }
      }
    }
  }
};

module.exports = dbConfig;

// Example connection using better-sqlite3
const Database = require('better-sqlite3');

function getDbConnection() {
  const db = new Database(dbConfig.connections.sqlite.connection.filename);
  db.pragma('foreign_keys = ON');
  return db;
}

// Example connection using Knex.js
const knex = require('knex')({
  client: 'sqlite3',
  connection: {
    filename: dbConfig.connections.sqlite.connection.filename
  },
  useNullAsDefault: true,
  pool: {
    afterCreate: (conn, cb) => {
      conn.run('PRAGMA foreign_keys = ON', cb);
    }
  }
});

module.exports = {
  dbConfig,
  getDbConnection,
  knex
};
```

## Creating and Initializing the Database

To create and initialize the database:

1. Create a directory for the database file:
   ```
   mkdir -p database
   ```

2. Run the SQL script to create the database:
   ```
   sqlite3 database/yap2u.sqlite < yap2u_database.sql
   ```

3. Verify the database was created successfully:
   ```
   sqlite3 database/yap2u.sqlite ".tables"
   ```

## Database Maintenance

- **Backup**: 
  ```
  sqlite3 database/yap2u.sqlite ".backup database/yap2u_backup.sqlite"
  ```

- **Optimize**: 
  ```
  sqlite3 database/yap2u.sqlite "VACUUM;"
  ```

- **Check Integrity**: 
  ```
  sqlite3 database/yap2u.sqlite "PRAGMA integrity_check;"
  ```
