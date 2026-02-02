# SQL Stored Procedures Practice

## Introduction 
### What is a Stored Procedure?
A stored procedure is a set of SQL statements that you save in the database. Think of it like a recipe:
- You write the recipe once
- You can use it many times
- You just need to "call" it when needed

## Why Use Stored Procedures?
- ✅ Reusability - Write once, use many times
- ✅ Performance - Faster execution (pre-compiled)
- ✅ Security - Control who can do what
- ✅ Maintainability - Update in one place
- ✅ Reduce Network Traffic - Send less data over the network

## Basic Syntax Structure
```python
DELIMITER //
CREATE PROCEDURE procedure_name()
BEGIN
-- Your SQL and NON SQL statements go here
END //
DELIMITER ;
```
## Understanding DELIMITER:
- MySQL normally uses ; to end statements
- Inside procedures, we need ; for multiple statements
- We temporarily change the delimiter to // so MySQL knows when the procedure ends
- After creating the procedure, we change it back to ;

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

## Learning Objective
- Understand how stored procedures improve performance
- Reduce code duplication
- Encapsulate business logic at the database level
- Prepare for Data Analyst / SQL Developer interviews
