# Learnings of SQL
## Basic Learnings
### Identity Columns
* While creating a column we could specify the Identity of that column by **IDENTITY(SEED,INCREMENT)**
* So our columns value should be inserted based on seed value and the increment value, if we delete any one of the record from the table and then insert the new record, sql will insert that record with the new value not that deleted value.
* So if we want to fill that Gap then we could temporarily stop the indentity increment by `IDENTITY_INSERT` statement.
```SQL
SET IDENTITY_INSERT tableName ON

INSERT INTO TABLE (column1, coulmn2) VALUES(7,[Name])
--In this case we should explicitly specify the column's name in the insert statement
```
* Then we could insert that deleted column value and after complete we should **Turn OFF** this temporary arrangement.
* And if we delete all the records from the table and try to insert a new record, sql will insert the record with the increment of the old record value (if already 5 records, then it will insert as 6th record), not from the 1st record.
* To achieve this,
```SQL
DBCC CHECKIDENT(tableName,RESEED,0)
-- then sql will insert the record from the value 1.
````