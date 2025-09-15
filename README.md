# SQL Projects — Employee Management & Recipe Analytics

Two SQL/data-modeling projects demonstrating database design, analytical queries, and ETL-style reporting.

## Projects
### 1. Employee Management System
- Schema: `employees`, `departments`, `dept_emp`, `dept_manager`, `salaries`, `titles`
- Includes ERD: `ERD.png`
- Key queries:
  - List employees per department with names, `emp_no`, `dept_no` & `dept_name`.
  - Highest salaried employee per department.
  - Employees hired prior to their manager.
- Files: `query1.sql`

### 2. Recipe Analytics System
- Schema: `recipes`, `users`, `recipe_applications`, `recipe_categories`, `business_objects`
- Analytical queries:
  - Active users using applications A/B/C/D
  - % cloned vs original recipes
  - Growth of recipes by category (monthly)
  - Distribution by number of applications used
- Files: `query2.sql`

## How to run
1. Create database and tables from the .sql files (MySQL example):
   ```bash
   mysql -u root -p < query1.sql
   mysql -u root -p < query2.sql
