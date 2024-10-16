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

## Views
* It is a `saved query` and acts like a `virtual table`.
* We could execute this view's like a table **(Select * from ViewName)**.
* Why we are using the view is, if a external user wants to see one particular combinational output, but we don't want to provide him the full access to our database right?
* So we as a developer, create the query and <i>wrap it as a view</i> and add that user to our database and give the permission to only that view.
* Then he can execute the view and able to see the output.

> Is it possible to Manipulate the view (insert or delete or update)
* Yes, because it's a virtual table we could do the manipulation and also view will update the **underlying table (Original table)'s** record too.
* But there is one disadvantage in the updation of View.

```SQL
    -- If we join two or more tables and try to update, view will update wrongly

    --View
    CREATE VIEW EventAndCategory
    AS
    SELECT EventID, EventName, CategoryName FROM tblEvent E
    INNER JOIN tblCategory C ON C.CategoryID = E.CategoryID

    --Executinthe view
    SELECT * F
    ROM EventAndCategory
```
![View Result](https://github.com/user-attachments/assets/d2f67c2e-4120-437b-bb5f-e1fc4109ecbd)

```SQL
    -- Update the view
    UPDATE EventAndCategory SET CategoryName = 'General' WHERE EventID = 344
    -- And then all Education record will changes into General not only the EventID with 344
    -- Because SQL will update the original table record and another table have that reference so, it will affect all the rows that have that reference.
```

* We could add index also to the view, it is called as **Indexed Views**. In oracle it will be called as **Materialized Views**.
### Limitations of Views
* We could not use `Rules and Defaults` on Views.
* We could not use `Order By` while creating the Views, unless we are using **Top** or For XML.
* Could not able to create View with `Temporary tables`.

### Key Advantage of Stored Procedure
* At first time, the stored procedure was executed it will create the `Execution Plan` and store that plan in the `Cache Memory`.
* Execution Plan means, how the SQL engine will execute the order of the query that we wrote and from which table it would start like that, there are lot of combinatins are there for the SQL Engine.
* So after the next time, SQL will take the **precompiled execution plan** from the cache and saves the time for **recompile**.
* Hence Stored Procedure is the great to execute the set of query in a **Optimized way**.

## Triggers
It is a Query or some actions that will trigger by firing some actions or events(Insert or delete or update).
> Trigger is based on table, any action related to that table triggers the trigger.
* There are three types of Triggers
    1. DML Triggers
    2. DDL Triggers
    3. Logon Triggers
* DML Triggers are further classified into two types
    1. For or Action Trigger
    2. Instead Of Trigger
### For or Action Trigger
* It will trigger particular action, when the referenced table got any new rows.
```SQL
    CREATE TRIGGER tr_tblEvent_ForInsert
    ON tblEvent
    FOR INSERT
    AS
    BEGIN
        SELECT * FROM inserted
    END
```
* `Inserted` is the new table which was created by the trigger and it having the new records with the `same structure` of original table (where the trigger was created).
* We should only access the Inserted table inside the **context of triggers only**.

