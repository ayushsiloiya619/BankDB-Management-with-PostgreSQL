create table accounts (
    id int generated by default as identity,
    name varchar(100) not null,
    balance dec(15,2) not null,
    primary key(id)
);

insert into accounts(name,balance)
values('Bob',10000);

insert into accounts(name,balance)
values('Alice',10000);

insert into accounts(name,balance)
values('John','12000');

-----------------------------------------------------------------
----procedure for inserting customer details----
CREATE OR REPLACE PROCEDURE insert_account(
EMP_ID INT,
EMP_NAME VARCHAR,
BAL INT
)
LANGUAGE plpgsql
as $$
begin
     insert into accounts(id,name,balance)values(EMP_ID,EMP_NAME,BAL);
     RAISE NOTICE 'Account_Holder_Name:%,Acccount_Balance:%',EMP_NAME,BAL;
	 commit;
end;
$$;

call insert_account(4,'Kushagra Singh',20000);
call insert_account(5,'Kartik Awasthi',5000);
call insert_account(6,'Nikhil',12000);
-----------------------------------------------------------------------

-----procedure to search account holder through id----
CREATE OR REPLACE PROCEDURE search_id(
    acc_id INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    acc_name TEXT;
BEGIN
    -- Retrieve the name for the given account ID
    SELECT name INTO acc_name
    FROM accounts
    WHERE id = acc_id;

    -- Check if a name was found
    IF acc_name IS NOT NULL THEN
        RAISE NOTICE 'Account Holder Name: %', acc_name;
    ELSE
        RAISE NOTICE 'No account holder found with ID: %', acc_id;
    END IF;

    -- Inform that the procedure executed successfully
    RAISE NOTICE 'Fetched Successfully';
END;
$$;

-- Call the procedure
CALL search_id(2);
call search_id(6);
------------------------------------------------------------------

-----procedure to search account holder through id----
CREATE OR REPLACE PROCEDURE search_id_bal(
    acc_id INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    acc_name TEXT;
	amount INT;
BEGIN
    -- Retrieve the name for the given account ID
    SELECT name,balance INTO acc_name, amount
    FROM accounts
    WHERE id = acc_id;

    -- Check if a name was found
    IF acc_name IS NOT NULL THEN
        RAISE NOTICE 'Account Holder Name: % , Amount: %', acc_name, amount;
    ELSE
        RAISE NOTICE 'No account holder found with ID: %', acc_id;
    END IF;

    -- Inform that the procedure executed successfully
    RAISE NOTICE 'Fetched Successfully';
END;
$$;

-- Call the procedure
CALL search_id_bal(2);
-----------------------------------------------------------------

------Employee with sorted id------
SELECT * FROM accounts ORDER BY id;

-----Transfer Balance-----
create or replace procedure transfer(
   sender int,
   receiver int, 
   amount dec
)
language plpgsql    
as $$
begin
    -- subtracting the amount from the sender's account 
    update accounts 
    set balance = balance - amount 
    where id = sender;

    -- adding the amount to the receiver's account
    update accounts 
    set balance = balance + amount 
    where id = receiver;

    commit;
end;$$;

call transfer(1,2,1000);
-----------------------------------------------------------------

--------check balance for the employee_id---
CREATE OR REPLACE PROCEDURE balance_slip(
    emp_id INT
) 
LANGUAGE plpgsql
AS $$
DECLARE
    emp_name TEXT;
    emp_balance NUMERIC;
BEGIN
    -- Retrieve the name and balance for the given employee ID
    SELECT name, balance INTO emp_name, emp_balance
    FROM accounts
    WHERE id = emp_id;

    -- Display the result
    RAISE NOTICE 'Employee: %, Balance: %', emp_name, emp_balance;
END;
$$;

---call the procedure---
CALL balance_slip(1);
-----------------------------------------------------------------



-----Procedure Last Transaction upto 4-----
-----4 transaction show------
----Date -> Show-----
----balance add------
----Cash withdraw-----



