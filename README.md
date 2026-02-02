# SQL Stored Procedures Practice
## Overview

This repository is created to practice and understand SQL Stored Procedures using real-world examples. It covers basic to advanced concepts such as parameters, control flow, error handling, and performance optimization.  

The scripts are designed mainly for **MySQL**

## Topics Covered
- Creating Stored Procedures
- Input (IN), Output (OUT), INOUT parameters
- Conditional logic (IF, CASE)
- Loops (WHILE, LOOP)
- Transactions (COMMIT, ROLLBACK)
- Error handling
- Performance optimization
- Reusable database logic

## Sample Stored Procedure
```python
DELIMITER \\
CREATE PROCEDURE GetEmployeeByDept (
    IN dept_id INT
)
BEGIN
    SELECT * 
    FROM employees
    WHERE department_id = dept_id;
END \\
DELIMITER ;
``` 
## How to Run
- Create a database:
- Run schema.sql to create tables
- Run sample_data.sql to insert data
- Execute procedure files one by one
- Call procedures using:
```python
  CALL GetEmployeeByDept(10);
```
## Learning Objective
- Understand how stored procedures improve performance
- Reduce code duplication
- Encapsulate business logic at the database level
- Prepare for Data Analyst / SQL Developer interviews
