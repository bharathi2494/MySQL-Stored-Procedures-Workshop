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
CREATE PROCEDURE GetEmployeeByDept (
    IN dept_id INT
)
BEGIN
    SELECT * 
    FROM employees
    WHERE department_id = dept_id;
END;
``` 
