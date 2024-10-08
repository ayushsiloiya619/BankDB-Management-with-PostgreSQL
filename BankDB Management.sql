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
---call the procedure---
call insert_account(4,'Kushagra Singh',20000);
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
---call the procedure---
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

----Procedure to add balance-----
CREATE OR REPLACE PROCEDURE add_balance(
    emp_id INT,
    amount INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    current_time TIMESTAMP;
BEGIN
    -- Get the current date and time
    current_time := NOW();

    -- Update the account balance
    UPDATE accounts 
    SET balance = balance + amount, 
        last_transaction = current_time + date
    WHERE id = emp_id;

    -- Display the details
    RAISE NOTICE 'Account Holder ID: %, Updated Balance: %, Transaction Date: %', emp_id, amount, current_time;
    RAISE NOTICE 'Updated Details Successfully';
END;
$$;
CALL add_balance(6, 2000);
-----------------------------------------------------------------
----Procedure to withdraw a cash from bank---

CREATE OR REPLACE PROCEDURE cash_withdraw(
    emp_id INT,
    withdraw_amount DECIMAL
)
LANGUAGE plpgsql
AS $$
DECLARE
    emp_name TEXT;
    current_balance DECIMAL(15,2);
BEGIN
    -- Retrieve the name and balance for the given employee ID
    SELECT name, balance INTO emp_name, current_balance
    FROM accounts
    WHERE id = emp_id;

    -- Check if the balance is sufficient for withdrawal
    IF current_balance >= withdraw_amount THEN
        -- Update the account balance
        UPDATE accounts 
        SET balance = balance - withdraw_amount
        WHERE id = emp_id;

        -- Display the details
        RAISE NOTICE 'Cash withdrawn by ID: %, Name: %, Withdrawn Amount: %', emp_id, emp_name, withdraw_amount;
        RAISE NOTICE 'Withdrawal successful. Remaining Balance: %', current_balance - withdraw_amount;
    ELSE
        RAISE NOTICE 'Insufficient balance. Current Balance: %', current_balance;
    END IF;
END;
$$;

CALL cash_withdraw(2, 2000);
--------------------------------------------------------------------
---------Count the total account holder in bank-----
CREATE OR REPLACE PROCEDURE count_holder()
LANGUAGE plpgsql
AS $$
DECLARE
    total_account_holders INT;
BEGIN
    -- Count the distinct account holders and store the result in a variable
    SELECT COUNT(DISTINCT name) INTO total_account_holders FROM accounts;

    -- Display the result
    RAISE NOTICE 'Total Account Holders: %', total_account_holders;
END;
$$;

call count_holder();
--------------------------------------------------

------Employee with sorted id------
SELECT * FROM accounts ORDER BY id;

SELECT FROM DATE;



---To be release soon.
---1. Last transaction upto 4




