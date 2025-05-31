# smss_sql_practice
quick guide for sql practice on ssms
# 🧠 SQL Practice Workbook

This repository contains a comprehensive SQL script designed to help beginners and intermediates practice and understand key relational database concepts using Microsoft SQL Server.

## 📁 Database Overview

This SQL script works mainly on a custom database (e.g., `db4virtual`) and includes the following tables:

- `Students`
- `Kurs`
- `Instruktor`
- `Departman`
- `Produkter` (renamed to `Varer`)
- `Category`
- `Orders`
- `OrderLines`
- `Movies`
- `Actors`
- `MovieActor`

## ✅ Features & Concepts Practiced

- Database and table creation
- Constraints: `PRIMARY KEY`, `UNIQUE`, `FOREIGN KEY`, `CHECK`
- `INSERT`, `UPDATE`, `DELETE`, `SELECT` operations
- `JOIN` operations (`INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`)
- Column manipulation: add, drop, rename
- Table manipulation: drop, rename, alter
- Handling duplicates and nulls
- `GROUP BY`, `HAVING`, and aggregates like `COUNT`
- Many-to-many relationships via mapping tables
- Querying metadata via `INFORMATION_SCHEMA` and `sp_help`

## 🧩 Schema Relations

### Students – Kurs (One-to-Many)
- A student can take multiple courses.
- Each course is linked to one student via `studentId`.

### Kurs – Instruktor – Departman (Multi-table JOIN)
- Courses are taught by instructors.
- Each instructor belongs to a department.

### Produkter – Category (One-to-Many)
- Products belong to a category via a `categoryName` key.

### Orders – OrderLines – Produkter (Many-to-Many)
- Orders contain multiple products through the `orderlines` mapping table.

### Movies – MovieActor – Actors (Many-to-Many)
- A movie can have many actors and vice versa, connected via `MovieActor`.

## 🛠 Getting Started

1. Use **SQL Server Management Studio (SSMS)**.
2. Create a database (e.g., `CREATE DATABASE db4virtual`).
3. Paste and run the full script inside a query window.
4. Use `SELECT * FROM tablename` to explore data.

## ⚠ Notes

- Some `ALTER` statements depend on whether previous constraints exist.
- Certain insertions may fail if constraints are not temporarily dropped.
- Rename operations (`sp_rename`) change names at the schema level.

## 📌 Tips

- For experimenting, use `DROP TABLE` cautiously.
- Always review constraints before adding or dropping columns.
- Use `sp_help tablename` to inspect a table’s schema and constraints.

## 💡 Example Queries

```sql
-- Show students with their courses and instructors
SELECT 
    s.FullName AS StudentName,
    c.CourseName,
    i.FullName AS InstructorName
FROM Students s
JOIN kurs c ON s.Id = c.StudentId
JOIN instruktor i ON c.instruktorId = i.Id;

-- Count duplicate emails (if any)
SELECT Email, COUNT(*) AS emailCount
FROM Students
GROUP BY Email
HAVING COUNT(*) > 1;
