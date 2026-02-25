-- Database schema for the project management app
-- Run these statements in MySQL to create the database and tables.

CREATE DATABASE IF NOT EXISTS gestao_projects CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE gestao_projects;


CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) DEFAULT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role VARCHAR(50) NOT NULL DEFAULT 'user',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS projects (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  year INT NOT NULL,
  course VARCHAR(120),
  type VARCHAR(120),
  advisor VARCHAR(255),
  summary TEXT,
  description TEXT,
  pdf_path VARCHAR(255),
  created_by INT DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);

-- Example: create an admin user (generate the password hash first)
-- Use PHP CLI to generate a bcrypt hash:
-- php -r "echo password_hash('ChangeMe123!', PASSWORD_DEFAULT) . PHP_EOL;"
-- Then run (replace <hash_here> with the output):
-- INSERT INTO users (name, email, password_hash, role) VALUES ('Admin', 'admin@example.com', '<hash_here>', 'admin');

-- Notes:
-- - Edit backend/db.php to point to the new database and credentials.
-- - For local visual testing (before PHP backend is active) you can simulate admin in the browser:
--     localStorage.setItem('isAdmin', 'true');
--   then open admindashboard.html to see admin UI.

-- End of schema
